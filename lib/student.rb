require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade, :id

  def initialize(id=nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
  DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, name, grade)

    if id == nil
      sql = <<-SQL
      SELECT id FROM students
      WHERE name = ?
      SQL
      nested = DB[:conn].execute(sql, name)
      self.id = nested[0][0]
    else
    sql = <<-SQL
      UPDATE students
      SET name=?, grade=?
      WHERE id=?
    SQL
    DB[:conn].execute(sql, name, grade, id)
  end
  end

  def self.create(name, grade)
    student = Student.new(nil, name, grade)
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, name, grade)
  end

  def self.new_from_db(pupil)
    student = Student.new(pupil[0],pupil[1],pupil[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    SQL
    pupil = DB[:conn].execute(sql, name)
    student = Student.new(pupil[0][0],pupil[0][1],pupil[0][2])
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET name=?, grade=?
      WHERE id=?
    SQL
    DB[:conn].execute(sql, name, grade, id)
  end

end
