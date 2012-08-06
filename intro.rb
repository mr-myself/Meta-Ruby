# encoding: utf-8
class Greeting
  def initialize(text)
    @text = text
  end

  def welcome
    @teend
  end
end

my_object = Greeting.new("Hello")

p my_object.class #=> Greeting
p my_object.class.instance_methods(false) #=> [:welcome]
# 引数のfalseは継承したものは必要ないよという意味。
p my_object.instance_variables #=> [:@text]

class Entity
  attr_reader :table, :ident

  def initialize(table, ident)
    @table = table
    @ident = ident
    Database.sql "INSERT INTO #{@table} (id) VALUES (#{@ident})"
  end

  def set(col, val)
    Database.sql "UPDATE #{@table} SET #{col}='#{val}' WHERE id=#{@ident}"
  end

  def get(col)
    Database.sql ("SELECT #{col} FROM #{@table} WHERE id=#{@ident}")[0][0]
  end
end


class Movie < Entity
  def initialize(ident)
    super("movies", ident)
  end

  def title
    get("title")
  end

  def title=(title)
    set("title", title)
  end

  def director
    get("director")
  end

  def director=(value)
    set("director", value)
  end
end
=begin databaseを作ってないのでエラーになるけど(・∀・)
movie = Movie.new(1)
movie.title = "博士の異常な愛情"
movie.director = "スタンリー・キューブリック"
=end

# 上記をメタプログラミングを使うと下記のように書ける
class Movie < ActiveRecord::Base
end

