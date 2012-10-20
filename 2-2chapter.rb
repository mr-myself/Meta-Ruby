# encoding: utf-8

# require 'ruport' # gem install ruport しないとあかん

class Lawyer; end
nick = Lawyer.new

# nick.send :method_missing, :my_method #=> `<main>': undefined method `my_method' for #<Lawyer:0x9503850> (NoM|  1 # encoding: utf-8ethodError)

class Lawyer
  def method_missing(method, *args)
    puts "#{method}(#{args.join(', ')})を呼び出した"
    puts "（ブロックを渡した）" if block_given?
  end
end

bob = Lawyer.new
bob.talk_simple('a', 'b') do
  # ブロック
end
#=> talk_simple(a, b)を呼び出した
#=>（ブロックを渡した）

=begin
table = Ruport::Data::Table.new :column_names => ["country", "white"],
                                :data => [["France", "Bordeaux"],
                                          ["Italy", "Chianti"],
                                          ["France", "Chablits"]]
puts table.to_text
=end

require 'ostruct'
icecream = OpenStruct.new
icecream.flavor = "ストロベリー"
puts icecream.flavor #=> ストロベリー


class MyOpenStruct
  def initialize
    @attributes = {}
  end

  def method_missing(name, *args)
    attribute = name.to_s
    if attribute =~ /=$/
      @attributes[attribute.chop] = args[0]
    else
      @attributes[attribute]
    end
  end
end

icecream = MyOpenStruct.new
icecream.flavor = "バニラ"
p icecream.flavor #=> "バニラ"

require 'delegate'

class Assistant
  def initialize(name)
    @name = name
  end

  def read_email
    puts "(#{@name})ほとんどスパムです"
  end

  def check_schedule
    puts "(#{@name})今日は打ち合わせがあります"
  end
end

class Manager < DelegateClass(Assistant)
  def initialize(assistant)
    super(assistant)
  end

  def attend_meeting
    puts "電話は取り次がないでください"
  end
end

frank = Assistant.new("Frank")
anne = Manager.new(frank)
anne.attend_meeting
anne.read_email
anne.check_schedule
#=> 電話は取り次がないでください
#=> (Frank)ほとんどスパムです
#=> (Frank)今日は打ち合わせがあります

def Object.const_missing(name)
  name.to_s.downcase.gsub(/_/, ' ')
end

p MY_CONSTANT #=> my constant"

class Roulette
  def method_missing(name, *args)
    person = name.to_s.capitalize
    super unless %w[Bob Frank Bill].include? person
    number = 0
    3.times do
      number = rand(10) + 1
      puts "#{number}..."
    end
    puts "#{person} got a #{number}"
  end
end

number_of = Roulette.new
puts number_of.bob
puts number_of.frank

class String
  def method_missing(method, *args)
    method == :ghost_reverse ? reverse : super
  end
end

require 'benchmark'

Benchmark.bm do |b|
  b.report 'Normal method' do
    1000000.times {"abc".reverse}
  end
  b.report 'Ghost method' do
    1000000.times {"abc".ghost_reverse}
  end
end



class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
    data_source.methods.grep(/^get_(.*)_info/) {Computer.define_component $1}
  end

  def self.define_component(name)
    define_method(name){
      info = @data_source.send "get_#{name}_info", @id
      price = @data_source.send "get_#{name}_price", @id
      result = "#{name.capitalize}: #{info} ($#{price})"
      return "* #{result}" if price >= 100
      result
    }
  end
end

class Computer
  instance_methods.each do |m|
    undef_method m unless m.to_s =~ /^__|method_missing|respond_to?/
  end

  def method_missing(name, *args)
    super if !respond_to?(name)
    info = @data_source.send("get_#{name}_info", args[0])
    price = @data_source.send("get_#{name}_price", args[0])
    result = "#{name.to_s.capitalize}: #{info} ($#{price})"
    return "* #{result}" if price >= 100
  end

  def respond_to?(method)
    @data_source.respond_to?("get_#{method}_info") || super
  end
end

