class Object
  def try method, *args
    return nil unless respond_to?(method)
    send(method, *args)
  end

  def queue_up category, *args
    begin
      Timeout.timeout(2) do
        STARLING.set category, args
      end
    rescue Exception => e
      puts "Exception when queing up for #{category}"
      puts e
    end
  end
end
