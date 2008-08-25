class Object
  def try method, *args
    return nil unless respond_to?(method)
    send(method, *args)
  end
end
