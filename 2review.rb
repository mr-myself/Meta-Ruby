# encoding: utf-8
def a_method(a, b)
  a + yield(a, b)
end

puts a_method(1, 2) {|x, y| (x + y) * 3 }

def b_method
  return yield if block_given?
  puts 'there is no blocks'
end

puts b_method
puts b_method {'there is a block!'}

def my_method
  x = 'Good bye'
  yield('cruel')
end

x = 'Hello!'
puts my_method {|y| "#{x}, #{y}, #{y} world"} #=> ブロックがローカル変数とかの束縛をつれていくから
#=> この特性がクロージャと呼ばれる

def my_method2
  yield
end

top_level_variable = 1
my_method2 do
  top_level_variable += 1
  local_to_block = 1
end

puts top_level_variable
# puts local_to_block #=> エラーになる


my_var = "sucess"

MyClass = Class.new do
  puts "#{my_var}"

  define_method :my_method do
    puts "#{my_var}"
  end
end

MyClass.new.my_method

def define_methods
  shared = 0

  Kernel.send :define_method, :counter do
    shared
  end

  Kernel.send :define_method, :inc do |x|
    shared += x
  end
end

define_methods
puts counter
puts inc(4)
puts counter


inc = Proc.new {|x| x + 1}
p inc.call(2)

dec = lambda {|x| x - 1}
p dec.class
p dec.call(2)

def math(a, b)
  yield(a, b)
end

def teach_math(a, b, &operation)
  puts "let's start caluculate!"
  puts math(a, b, &operation)
end

teach_math(2, 3){|x, y| x * y}

def my_method(&the_proc)
  the_proc
end

p = my_method {|name| "Hello, #{name}!"}
puts p.class
puts p.call("Kei")

p = Proc.new {|x| x + 1}
puts p.call(90)


def double(callable_object)
  callable_object.call * 2
end

l = lambda { return 10 }
puts double(l) #=> 20

def another_double
  p = Proc.new{ return 10 }
  result = p.call
  return result * 2
end
puts another_double #=> 10


test = lambda {|name| puts name + ' thank you'}
test.call('Kei')


class MyClass
  def initialize(value)
    @x = value
  end

  def my_method
    @x
  end
end

object = MyClass.new(1)
m = object.method :my_method
puts m.call #=> 1
