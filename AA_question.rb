require 'sqlite3'
require 'singleton'
require 'debugger'
require './reply'
require './question'

class QuestionDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("aa_questions.db")
    self.results_as_hash = true
    self.type_translation = true
  end
end

class User
  attr_reader :id

  def self.find_by_name(fname,lname)
    select = <<-SQL
      SELECT *
      FROM users
      WHERE fname = '#{fname}'
      AND lname = '#{lname}'
    SQL
    #debugger
    User.new(QuestionDatabase.instance.execute(select).first)
  end

  def initialize(hash)
    @id = hash["id"]
    @fname = hash["fname"]
    @lname = hash["lname"]
    @is_instructor = hash["is_instructor"] == 0 ? false : true
  end

  def average_karma
    select = <<-SQL #rounds down
      SELECT COUNT(question_likes.id) / COUNT(DISTINCT questions.title) average_karma
      FROM users
      JOIN questions
      ON (users.id = questions.user_id)
      LEFT JOIN question_likes
      ON (questions.id = question_id)
      WHERE users.id = '#{self.id}'
    SQL

    puts QuestionDatabase.instance.execute(select)
  end

  def questions
    select = <<-SQL #rounds down
      SELECT questions.title
      FROM users
      JOIN questions
      ON (users.id = questions.user_id)
      WHERE users.id = '#{self.id}'
    SQL

    puts QuestionDatabase.instance.execute(select)
  end

  def replies
    select = <<-SQL #rounds down
      SELECT replies.body
      FROM users
      JOIN replies
      ON (users.id = replies.user_id)
      WHERE users.id = '#{self.id}'
    SQL

    puts QuestionDatabase.instance.execute(select)
  end

  def save
    if @id.nil?
      save = <<-SQL
        INSERT INTO users
        (fname, lname, is_instructor)
        VALUES ('#{@fname}', '#{@lname}', '#{@is_instructor == true ? 1 : 0}')
      SQL
    else
      save = <<-SQL
        UPDATE users
        SET lname         = '#{@lname}',
            fname         = '#{@fname}',
            is_instructor = '#{@is_instructor == true ? 1 : 0}'
        WHERE id = '#{@id}'
      SQL
    end
    QuestionDatabase.instance.execute(save)
  end
end


User.new({'fname' => 'Jonathan', 'lname' => 'Tamboer', 'is_instructor' => true}).save
p User.find_by_name('Jonathan','Tamboer')
#p User.find_by_name('Eric','Lin')
# User.find_by_name('Eric','Lin').questions
#p User.find_by_name('Luke','Persola')
# p Reply.search_body("Left foot!").replies("You're wrong!")
# User.find_by_name('Luke','Persola').replies
# Reply.most_replied
# Reply.new({parent => 2}).replies
# Question.find_by_title('How walk?').num_likes
# Question.most_liked(2)
# Question.most_followed(2)
