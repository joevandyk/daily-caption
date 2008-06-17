module StarlingServer

  ##
  # This is an internal class that's used by Starling::Server to handle the
  # MemCache protocol and act as an interface between the Server and the
  # QueueCollection.
  
  class Handler

    DATA_PACK_FMT = "Ia*".freeze

    # ERROR responses
    ERR_UNKNOWN_COMMAND = "CLIENT_ERROR bad command line format\r\n".freeze

    # GET Responses
    GET_COMMAND = /^get (.{1,250})\r\n$/
    GET_RESPONSE       = "VALUE %s %s %s\r\n%s\r\nEND\r\n".freeze
    GET_RESPONSE_EMPTY = "END\r\n".freeze

    # SET Responses
    SET_COMMAND = /^set (.{1,250}) ([0-9]+) ([0-9]+) ([0-9]+)\r\n$/
    SET_RESPONSE_SUCCESS  = "STORED\r\n".freeze
    SET_RESPONSE_FAILURE  = "NOT STORED\r\n".freeze
    SET_CLIENT_DATA_ERROR = "CLIENT_ERROR bad data chunk\r\nERROR\r\n".freeze

    # STAT Response
    STATS_COMMAND = /stats\r\n$/
    STATS_RESPONSE = "STAT pid %d
STAT uptime %d
STAT time %d
STAT version %s
STAT rusage_user %0.6f
STAT rusage_system %0.6f
STAT curr_items %d
STAT total_items %d
STAT bytes %d
STAT curr_connections %d
STAT total_connections %d
STAT cmd_get %d
STAT cmd_set %d
STAT get_hits %d
STAT get_misses %d
STAT bytes_read %d
STAT bytes_written %d
STAT limit_maxbytes %d
%sEND\r\n".freeze
    QUEUE_STATS_RESPONSE = "STAT queue_%s_items %d
STAT queue_%s_total_items %d
STAT queue_%s_logsize %d
STAT queue_%s_expired_items %d\n".freeze

    ##
    # Creates a new handler for the MemCache protocol that communicates with a
    # given client.

    def initialize(client, server, queue_collection)
      @client = client
      @server = server
      @queue_collection = queue_collection
      @expiry_stats = Hash.new(0)
    end

    ##
    # Process incoming commands from the attached client.

    def run
      while running? do
        process_command(@client.readline)
        Thread.current[:last_activity] = Time.now
      end
    end

    private

    def running?
      !Thread.current[:shutdown]
    end

    def respond(str, *args)
      response = sprintf(str, *args)
      @server.stats[:bytes_written] += response.length
      @client.write response
    end

    def process_command(command)
      begin
        @server.stats[:bytes_read] += command.length
        case command
        when SET_COMMAND
          @server.stats[:set_requests] += 1
          set($1, $2, $3, $4.to_i)
        when GET_COMMAND
          @server.stats[:get_requests] += 1
          get($1)
        when STATS_COMMAND
          stats
        else
          logger.warn "Unknown command: #{command[0,4]}.\nFull command was #{command}."
          respond ERR_UNKNOWN_COMMAND
        end
      rescue => e
        logger.error "Error handling request: #{e}."
        logger.debug e.backtrace.join("\n")
        respond GET_RESPONSE_EMPTY
      end
    end

    def set(key, flags, expiry, len)
      data = @client.read(len)
      data_end = @client.read(2)
      @server.stats[:bytes_read] += len + 2
      if data_end == "\r\n" && data.size == len
        internal_data = [expiry.to_i, data].pack(DATA_PACK_FMT)
        if @queue_collection.put(key, internal_data)
          respond SET_RESPONSE_SUCCESS
        else
          respond SET_RESPONSE_FAILURE
        end
      else
        respond SET_CLIENT_DATA_ERROR
      end
    end

    def get(key)
      now = Time.now.to_i

      while response = @queue_collection.take(key)
        expiry, data = response.unpack(DATA_PACK_FMT)

        break if expiry == 0 || expiry >= now

        @expiry_stats[key] += 1
        expiry, data = nil
      end

      if data
        respond GET_RESPONSE, key, 0, data.size, data
      else
        respond GET_RESPONSE_EMPTY
      end
    end

    def stats
      respond STATS_RESPONSE, 
        Process.pid, # pid
        Time.now - @server.stats(:start_time), # uptime
        Time.now.to_i, # time
        StarlingServer::VERSION, # version
        Process.times.utime, # rusage_user
        Process.times.stime, # rusage_system
        @queue_collection.stats(:current_size), # curr_items
        @queue_collection.stats(:total_items), # total_items
        @queue_collection.stats(:current_bytes), # bytes
        @server.stats(:connections), # curr_connections
        @server.stats(:total_connections), # total_connections
        @server.stats(:get_requests), # get count
        @server.stats(:set_requests), # set count
        @queue_collection.stats(:get_hits),
        @queue_collection.stats(:get_misses),
        @server.stats(:bytes_read), # total bytes read
        @server.stats(:bytes_written), # total bytes written
        0, # limit_maxbytes
        queue_stats
    end

    def queue_stats
      @queue_collection.queues.inject("") do |m,(k,v)|
        m + sprintf(QUEUE_STATS_RESPONSE,
                      k, v.length,
                      k, v.total_items,
                      k, v.logsize,
                      k, @expiry_stats[k])
      end
    end

    def logger
      @server.logger
    end

  end
end
