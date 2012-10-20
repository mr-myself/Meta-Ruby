#encoding: utf-8

result = class YourClass
  self
end

puts result

class MyClass
  def my_method
  end
end

def add_method_to(a_class)
  a_class.class_eval do
    def m
      puts 'Hello'
    end
  end
end

add_method_to MyClass

test = MyClass.new #=> インスタンスしなおしたらメソッドが追加されて
test.m


class TestClass
  @my_var = 1

  def self.read; @my_var; end
  def write; @my_var = 2; end
  def read; @my_var; end
end

obj = TestClass.new
puts obj.write
puts obj.read
puts "--------------"
puts TestClass.read

# selfってのはインスタンス化せずに呼び出すときにレシーバーになるもの
# newしてからつくるとレシーバーはTestClassになるからdef readの方に行く
# クラスインスタンス変数使うとオブジェクトのインスタンス変数になるわけだから
# オブジェクト自体がその値を保持する

class C
  @@v = 45
end

class D < C
  def my_method; @@v; end
end

puts D.new.my_method
# これはクラス変数によるもの

class Loan
  def initialize(book)
    @book = book
    @time = Time.now
  end

  def self.time_class
    @time_class || Time
  end

  def to_s
    "#{@book.upcase} load on #{@time}"
  end
end

c = Class.new(Array) do
  def my_method
    'Hello!'
  end
end

TEAGADFA = c
p c.name #=> nameはクラスクラスのメソッド（タブンネ）



class Paragraph
  def initialize(text)
    @text = text
  end

  def title?; @text.upcase == @text; end
  def reverse; @text.reverse; end
  def upcase; @text.upcase; end
end


def test?(t)
  test = "ABC"
  t.upcase == test
end

p test?("ABC") #=> trueが返ってくる

@test2 = "k;af;aklfj"
def test2
  @test2
end

p test2 #=> @test2の中身が返ってくる

def index(paragraph)
  p "through"
  add_to_index(paragraph) if paragraph.title?
end

str = "just a regular string"

def str.title?
  self.upcase == self
end

p str.title? #=> false
p str.methods.grep(/title?/) #=> [:title]
p str.singleton_methods #=> [:title]

paragraph = "any string can be a paragraph"

def paragraph.title?
  self.upcase == self
end

p index(paragraph) #=> nil

=begin
an_object.a_method
AClass.a_classs_method

def obj.a_singleton_method; end
def MyClass.another_class_metho; end
=end

class MyClass
  def self.yet_another_class_method; end
end

class HisClass
  attr_accessor :my_attribute
  # 上記のクラスマクロを使えば下記のメソッドが要らなくなる！
=begin
  def my_attribute=(value)
    @my_attribute = value
  end

  def my_attribute
    @my_attribute
  end
=end
end

p obj = HisClass.new
p obj.my_attribute = 'x' #=> "x"
p obj.my_attribute #=> "x"



class Book
  def title
  end

  def subtitle
  end

  def lend_to(user)
    puts "leading to #{user}"
  end

  def self.deprecate(old_method, new_method)
    define_method(old_method) do |*arg, &block|
      warn "Warning: #{old_method}() is deprecated. Use #{new_method}()."
      send(new_method, *args, &block)
    end
  end

  deprecate :GetTitle, :title
  deprecate :LEND_TO_USER, :lend_to
  deprecate :title2, :subtitle
end


def test3
  warn "WARNING!! SUCCESS!!lol"
end

test3 #=> "WARNING!! SUCCESS!!lol"

obj = Object.new
eigenclass = class << obj
  self
end
p eigenclass.class

def obj.my_singleton_method; end
p eigenclass.instance_methods.grep(/my_/) #=> [:my_singleton_method]
#p obj.instance_methods.grep(/my_/) #=> エラー
# 特異クラスはオブジェクトの特異メソッドが住んでいる場所だかららしい(・∀・)


# クラスメソッドを定義するための3つの方法
class HerClass
  def self.my_method; end
end

def HerClass.my_other_method; end

class HerClass
  class << self
    def my_method; end
  end
end
# 一番最初のself使うのが一番わかりやすいって本には書いてあるけどね(・∀・)


class Object
  def eigenclass
    class << self; self; end
  end
end

p "abc".eigenclass

class MyClass
  attr_accessor :a
end

obj = MyClass.new
obj.a = 2
p obj.a #=> 2

# クラスに属性を定義する時。つまりクラスそれ自体に対して
class MyClass
  class << self
    attr_accessor :c
  end
end


module MyModule
  def my_method; 'hello'; end
end

class ItsClass
  class << self
    include MyModule
  end
end

p ItsClass.my_method #=> "hello"

obj = Object.new
class << obj
  include MyModule
end

p obj.my_method #=> "hello"
p obj.singleton_methods #=> [:my_method]

module TestModule
  def my_method; 'hello'; end
end

obj2 = Object.new
obj2.extend TestModule
p obj2.my_method #=> "hello"

class MyClass
  def my_method; 'my_method()'; end
  alias :m :my_method
end

obj = MyClass.new
p obj.my_method #=> "my_method()"
p obj.m #=> "my_method()"

class MyClass
  alias_method :m2, :m
end

p obj.m2 #=> "my_method()"


class String
  alias :real_length :length

  def length
    real_length > 5 ? 'long' : 'short'
  end
end

p "sldkfnaldfsf lksdfja;lkjdfl;sajkl;fjak;sl".length #=> "long"
p "sdlfnal;dfns;lfakld;afjkds;ljagkl;".real_length #=> 34
# エイリアスは元のメソッドを参照しているだけで、元の目メソッドを変更するのではない。
# 新しいメソッドを定義して元のメソッドの名前をつけている


class C
  def x; "OK!"; end

  alias :y :x

  private :x
end

obj = C.new
p obj.y #=> "OK!"
#p obj.x #=> private method error


class Amazon
  def reviews_of(test)
    puts "#{test}"
  end

  alias :old_reviews_of :reviews_of

  def reviews_of(book)
    start = Time.now
    result = old_reviews_of book
    time_taken = Time.now - start
    puts "reviews_of() took more than #{time_taken} seconds" if time_taken > 2
    result
  rescue
    puts "reviews_of() failed"
    []
  end
end


class Fixnum
  alias :old_plus :+

  def +(value)
    self.old_plus(value).old_plus(1)
  end
end

p 1 + 1 #=> 3
