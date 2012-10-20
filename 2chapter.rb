# encoding: utf-8

class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end

  def mouse
    info = @data_source.get_mouse_info(@id)
    price = @data_source.get_mouse_price(@id)
    result = "Mouse: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end

  def cpu
    info = @data_source.get_cpu_info(@id)
    price = @data_source.get_cpu_price(@id)
    result = "Cpu: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end

  def keyboard
    info = @data_source.get_keyboard_info(@id)
    price = @data_source.get_keyboard_price(@id)
    result = "Keyboard: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end
end

class MyClass
  def my_method(my_arg)
    p my_arg * 2
  end
end

obj = MyClass.new
obj.my_method(3) #=> 6
obj.send(:my_method, 3) #=> 6 send(シンボル, 引数)


# 連続したあらゆる文字のプレフィックスにコロンをつけるとシンボルになる
# x = :this_is_a_symbol
=begin
if conf.rc and File.exists?(conf.rc)
  YAML.load_file(conf.rc).each do |k,v|
    conf.send("#{k}=", v)
  end
end
=end

# 動的にメソッドを定義する
class MyClass
  define_method :my_method do |my_arg|
    my_arg * 3
  end
end

obj = MyClass.new
puts obj.my_method(99) #=> 297

=begin
class Computere
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end

  def mouse
    info = @data_source.get_mouse_info(@id)
    price = @data_source.get_mouse_price(@id)
    result = "Mouse: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    puts result
  end

  def cpu
    info = @data_source.get_cpu_info(@id)
    price = @data_source.get_cpu_price(@id)
    resut = "Cpu: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    puts result
  end

  def keyboard
    info = @data_source.get_keyboard_info(@id)
    price = @data_source.get_keyboard_price(@id)
    resut = "Keyboard: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    puts result
  end
end
=end

# リファクタ
# DSクラスというのを前もって作っていてそこにinfoとか定義されてるって前提で
class Computere
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end

  def mouse
    component :mouse
  end

  def cpu
    component :cpu
  end

  def keyboard
    component :keyboard
  end

  def component(name)
    info = @data_source.send "get_#{name}_info", @id
    price = @data_source.send "get_#{name}_price", @id
    result = "#{name.to_s.capitalize}: #{info} ($#{price})" # nameはシンボルで渡されてるから文字列に変換して大文字に
    return "#{result}" if price >= 100
    puts reult
  end
end

my_computer = Computer.new(42, DS.new)
my_computer.cpu

# 上記をさらに動的メソッドでリファクタ
class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end

  def self.define_component(name)
    define_method(name) {
      info = @data_source.send "get_#{name}_info", @id
      price = @data_source.send "get_#{name}_price", @id
      result = "#{name.to_s.capitalize}: #{info} ($#{price})"
      return "* #{result}" if price >= 1000
      puts result
    }
  end

  define_componet :mouse
  define_component :cpu
  define_component :keyboard
end

# さらにリファクタ
class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
    data_source.methods.grep(/^get_(.*)_info$/) { Computer.define_component $1 } # String#grepはマッチしすべての要素に対してブロックは評価される
                                                                                 # $1にマッチした文字列が入ってくる
  end

  def self.define_component(name)
    define_method(name) {
      info = @data_source.send "get_#{name}_info", @id
      price = @data_source.send "get_#{name}_price", @id
      result = "#{name.capitalize}: #{info} ($#{price})"
      return "* #{result}" if price >= 1000
      puts result
    }
  end
end

puts 1
