# encoding: utf-8

3.times do
  class C
    puts 'Hello' #=> Hello Hello Hello
  end
end
# これはクラスを3つ定義しているというのではない↓
class D
  def x
    p 'x'
  end
end

class D
  def y
    p 'y'
  end
end

obj = D.new
obj.x #=> "x"
obj.y #=> "y"

=begin
2回目の段階でclass Dは既に存在しているので
既存のクラスを再オープンしてy()メソッドを追加する
classの主な仕事はあなたをクラスのコンテキストに連れて行くこと
=end
#=> この技術をオープンクラスと呼ぶ。StringやArrayも含まれる。

module MyModule
  MyConstant = '外部の定数'

  class MyClass
    MyConstant = '内部の定数'
  end
end

p MyModule::MyConstant #=> 外部の定数

# 定数のパス
# ディレクトリ構造のようにアクセスできる
module M
  class C
    X = 'ある定数'
  end
  p C::X #=> "ある定数"
end

module M
  Y = '他の定数'
  class C
    p ::M::Y #=> "他の定数"
  end
end

# Moduleクラスはconstants()というインスタンスメソッドとクラスメソッドを
# 持っていて、下記で現在のスコープにあるすべての定数を返す
p M.constants #=> [:C, :Y]

# 現在のパスはModule.nesting()で確認可能
module M
  class C
    module M2
      p Module.nesting #=> [M::C::M2, M::C, M]
    end
  end
end


# 継承チェーン、モジュールとメソッド探索
module Mo
  def my_method
    puts 'M#my_method()'
  end
end

class E
  include Mo
end

class F < E
end

F.new.my_method() #=> M#my_method()


class MyClass2
  def test_self
    @var = 10
    my_method()
    p self
  end

  def my_method
    @var += 1
  end
end

obj = MyClass2.new
obj.test_self #=> #<MyClass2:0x98c7838 @var=11> オブジェクトの情報を指してる？


module Printable
  def print
  end

  def prepare_cover
  end
end

module Document
  def print_to_screen
    p prepare_cover
    p format_for_screen
    p print
  end

  def format_for_screen
  end

  def print
  end
end

class Book
  include Document
  include Printable
end

b = Book.new
b.print_to_screen
p Book.ancestors #=> [Book, Printable, Document, Object, Kernel, BasicObject]
