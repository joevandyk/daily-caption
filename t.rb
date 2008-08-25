
class Foo
  def self.c_method
    Foo.new.protected_method
  end

  protected

  def protected_method
  end
end

Foo.c_method  # Error: in `c_method': protected method `protected_method' called for #<Foo:0x220240> (NoMethodError)

