class Object
  def try method, *args
    return nil unless respond_to?(method)
    send(method, *args)
  end

  def queue_up category, *args
    STARLING.set category, args
  end
end
