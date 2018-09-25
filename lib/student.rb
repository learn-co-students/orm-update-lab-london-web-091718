require_relative "../config/environment.rb"
require"pry"
class Student


  attr_accessor :id, :grade, :name
  attr_reader

  def initialize(name="",grade="")
    @name = name
    @grade  = grade
    @id=nil
  end

  def self.create_table
    sql = "CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = " DROP TABLE students;"
    DB[:conn].execute(sql)
  end

  def save
    if !self.id.nil?
      update
    else
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?,?)",self.name, self.grade)
      id=parse[0][0]
      @id = id
    end
      return self
  end

  def parse
    DB[:conn].execute("SELECT * FROM students WHERE name=?;", self.name)
  end

  def self.create(name,grade)
    self.new(name,grade).save
  end

  def self.find_by_id(given_id)
    sql="SELECT * FROM students WHERE id=?;"
    retrieved=DB[:conn].execute(sql,given_id)[0]
    new_from_db(retrieved)
  end

  def self.new_from_db(array)
    bobo=self.new
    bobo.id=array[0]
    bobo.name=array[1]
    bobo.grade=array[2]
    bobo
  end


  def self.find_or_create_by(name:name,grade:grade)
  sql="SELECT * FROM students WHERE name=? AND grade=?;"
  check=DB[:conn].execute(sql,name,grade)[0]
  #binding.pry
  if check != nil
    self.find_by_name(name)
  else
    create(name:name,grade:grade)
  end
  end



  def self.find_by_name(name)
    row=DB[:conn].execute("SELECT * FROM  students WHERE name=?" ,name)[0]
    new_from_db(row)
  end

  def update
    DB[:conn].execute("UPDATE students SET name=?,grade=? WHERE id=?", self.name, self.grade ,self.id)
    #binding.pry
  end

end
