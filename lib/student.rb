require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def self.create(name, grade)
    DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?);", name, grade)

    ### OR
    ### student = Student.new(name, grade)
    ### student.save
  end

  def self.new_from_db(row)
    Student.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?;
    SQL

    self.new_from_db(DB[:conn].execute(sql, name).flatten)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name,grade) VALUES (?,?);
      SQL

      DB[:conn].execute(sql, self.name, self.grade)

      sql = <<-SQL
      SELECT MAX(id) FROM students;
      SQL

      @id = DB[:conn].execute(sql)[0][0]
    end
  end

  def update
    sql = <<-SQL
    UPDATE students SET name = ?;
    SQL

    DB[:conn].execute(sql, self.name)
  end

end
