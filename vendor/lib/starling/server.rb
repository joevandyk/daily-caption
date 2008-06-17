require 'socket'
require 'logger'

here = File.dirname(__FILE__)

require File.join(here, 'queue_collection')
require File.join(here, 'handler')

module StarlingServer

  VERSION = "0.9.3"

  class StopServer < Exception #:nodoc:
  end

  class Base

    attr_reader :logger

    DEFAULT_HOST    = '127.0.0.1'
    DEFAULT_PORT    = 22122
    DEFAULT_PATH    = "/tmp/starling/"
    DEFAULT_TIMEOUT = 60

    ##
    # Initialize a new Starling server and immediately start processing
    # requests.
    #
    # +opts+ is an optional hash, whose valid options are:
    #
    #   [:host]     Host on which to listen (default is 127.0.0.1).
    #   [:port]     Port on which to listen (default is 22122).
    #   [:path]     Path to Starling queue logs. Default is /tmp/starling/
    #   [:timeout]  Time in seconds to wait before closing connections.
    #   [:logger]   A Logger object, an IO handle, or a path to the log.
    #   [:loglevel] Logger verbosity. Default is Logger::ERROR.
    #
    # Other options are ignored.
    
    def self.start(opts = {})
      server = self.new(opts)
      acceptor = server.run
      [server, acceptor]
    end

    ##
    # Initialize a new Starling server, but do not accept connections or
    # process requests.
    #
    # +opts+ is as for +start+
    
    def initialize(opts = {})
      @opts = { :host    => DEFAULT_HOST,
                :port    => DEFAULT_PORT,
                :path    => DEFAULT_PATH,
                :timeout => DEFAULT_TIMEOUT }.merge(opts)

      @logger = case @opts[:logger]
      when IO, String; Logger.new(opts[:logger])
      when Logger; opts[:logger]
      else; Logger.new(STDERR)
      end

      @logger.level = @opts[:log_level] || Logger::ERROR

      @timeout = @opts[:timeout]

      @socket = TCPServer.new(@opts[:host], @opts[:port])
      @socket.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
      @socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, true)

      @queue_collection = QueueCollection.new(@opts[:path])

      @workers = ThreadGroup.new

      @stats = Hash.new(0)
    end

    ##
    # Start listening and processing requests.

    def run
      @stats[:start_time] = Time.now

      BasicSocket.do_not_reverse_lookup = true

      @acceptor = Thread.new do
        loop do
          begin
            accept_connection
          rescue StopServer
            @socket.close rescue Object
            break
          rescue Errno::EMFILE
            cull_workers("Too many open files or sockets")
            sleep @timeout / 100
          rescue Errno::ECONNABORTED
            begin
              client.close
            rescue Object => e
              logger.warn "Got exception closing socket (client aborted connection) #{e}"
            end
          rescue Object => e
            logger.fatal "Unhandled exception: #{e}.  TELL BLAINE HE'S A MORON."
            logger.debug e.backtrace.join("\n")
          end
        end

        graceful_shutdown
      end

      return @acceptor
    end

    ##
    # Stop accepting new connections and shutdown gracefully.

    def stop
      stopper = Thread.new { @acceptor.raise(StopServer.new) }
      stopper.priority = Thread.current.priority + 10
    end

    def stats(stat = nil) #:nodoc:
      case stat
      when nil; @stats
      when :connections; @workers.list.length
      else; @stats[stat]
      end
    end

    private

    def accept_connection #:nodoc:
      client = @socket.accept

      @stats[:total_connections] += 1

      thread = Thread.new(client) { |c| spawn_handler(c) }
      thread[:last_activity] = Time.now
      @workers.add(thread)
    end

    def spawn_handler(client) #:nodoc:
      begin
        queue_handler = Handler.new(client, self, @queue_collection)
        queue_handler.run
      rescue EOFError, Errno::EBADF, Errno::ECONNRESET, Errno::EINVAL, Errno::EPIPE
        begin
          client.close
        rescue Object => e
          logger.warn "Got exception while closing socket after connection error: #{e}"
          logger.debug e.backtrace.join("\n")
        end
      rescue TimeoutError => reason
        begin
          logger.info "Shutdown due to timeout: #{reason.message}"
          client.close
        rescue Object => e
          logger.warn "Got exception while closing socket after timeout: #{e}"
          logger.debug e.backtrace.join("\n")
        end
      rescue Errno::EMFILE
        cull_workers('Too many open files or sockets')
      rescue Object => e
        logger.error("Unknown error: #{e}")
        logger.debug(e.backtrace.join("\n"))
      ensure
        begin
          client.close
        rescue Object => e
          logger.info "Got exception while closing socket: #{e}"
          logger.debug e.backtrace.join("\n")
        end
      end
    end

    def cull_workers(reason='unknown') #:nodoc:
      if @workers.list.length > 0
        logger.info "#{Time.now}: Reaping #{@workers.list.length} threads because of #{reason}"
        error_msg = "Starling timed out this thread: #{reason}"
        mark = Time.now
        @workers.list.each do |w|
          w[:last_activity] = Time.now if not w[:last_activity]

          if mark - w[:last_activity] > @timeout
            logger.warn "Thread #{w.inspect} has been idle for #{mark - w[:last_activity]}s, killing."
            w.raise(TimeoutError.new(error_msg))
          end
        end
      end

      return @workers.list.length
    end

    def graceful_shutdown #:nodoc:
      @workers.list.each do |w|
        w[:shutdown] = true
      end

      @queue_collection.close

      while cull_workers("shutdown") > 0
        logger.info "Waiting for #{@workers.list.length} requests to finish, could take #{@timeout} seconds."
        sleep 0.5
      end
    end
  end
end
