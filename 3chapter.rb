# encoding: utf-8

def a_method(a, b)
  a + yield(a, b)
end

p a_method(1, 2) {|x, y| (x + y) * 3}

def b_method
  p block_given?
  return yield if block_given?
  p 'ブロックがありません'
end

b_method
b_method { "ブロックがあるよ" }


def my_method
  x = "Good bye"
  yield("cruel")
end

x = "Hello"
my_method {|y| p "#{x}, #{y} world"} #=> Hello cruel world

def my_method
  yield
end

top_level_variable = 1
my_method do
  top_level_variable += 1
  local_to_block = 1
end
p top_level_variable #=> 2
# p local_to_block #=> Error

v1 = 1
class MyClass
  v2 = 2
  p local_variables

  def my_method
    v3 = 3
    p local_variables
  end

  p local_variables
end

obj = MyClass.new
obj.my_method
obj.my_method
p local_variables
# プログラムがスコープを変えると束縛は新しいと束縛と交換される

def a_scope
  $var = "何らかの値"
end

def another_scope
  $var
end

a_scope
p another_scope #=> "何らかの値"

@var = "トップレベルの変数 @var"

def my_method
  @var
end
p my_method #=> "トップレベルの変数 @var"

var = "ローカル"

=begin
def my_method
  var
end
p my_method #=> 未定義Error
=end
# トップレベルのインスタンス変数はmainがselfになる場所であれば
# どこでも呼び出せるが、他のオブジェクトがselfになればスコープからはずれる

my_var = "Success"

YourClass = Class.new do
  puts "#{my_var}はクラス定義の中！"

  define_method :my_method do
    puts "#{my_var}はメソッド定義の中！"
  end
end

YourClass.new.my_method

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

p counter #=> 0
p inc(4) #=> 4
p counter #=> 4

class MyClass
  def initialize
    @v = 1
  end
end

obj = MyClass.new
obj.instance_eval do
  p self #=> #<MyClass:0x992161c @v=1>
  p @v #=> 1
end

v = 2
p obj.instance_eval {@v = v} #=> 2
p obj.instance_eval {@v} #=> 2


class CleanRoom

  def complex_calculation
    @val = 20
  end

  def do_something
    @val += 20
  end
end

clean_room = CleanRoom.new
clean_room.instance_eval do
  if complex_calculation > 10
    p do_something #=> 40
  end
end


