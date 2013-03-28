require 'sqlite3'
require 'singleton'

class QuestionDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("aa_questions.db")
    self.results_as_hash = true
    self.type_translation = true
  end
end

class User
  def self.find_by_name(fname,lname)
    select = <<-SQL
      SELECT *
      FROM users
      WHERE fname = '#{fname}'
      AND lname = '#{lname}'
    SQL

    User.new(QuestionDatabase.instance.execute(select).first)
  end

  def initialize(hash)
    @id = hash["id"]
    @fname = hash["fname"]
    @lname = hash["lname"]
    @is_instructor = hash["is_instructor"] == 0 ? false : true
  end
end

p User.find_by_name('Eric', 'Lin')

class Question
  attr_reader :id
  def self.find_by_title(title)
    select = <<-SQL
      SELECT *
      FROM questions
      WHERE title = '#{title}'
    SQL

    Question.new(QuestionDatabase.instance.execute(select).first)
  end

  def self.most_liked(n)
    select = <<-SQL
      SELECT title, COALESCE(COUNT(question_likes.id), 0) likes
      FROM questions
      LEFT JOIN question_likes
      ON questions.id = question_id
      GROUP BY questions.title
      ORDER BY COUNT(question_likes.id) DESC
    SQL

    puts QuestionDatabase.instance.execute(select)[0..n-1]
  end

  def self.most_followed(n)
    select = <<-SQL
      SELECT title, COALESCE(COUNT(question_followers.id), 0) followers
      FROM questions
      LEFT JOIN question_followers
      ON questions.id = question_id
      GROUP BY questions.title
      ORDER BY COUNT(question_followers.id) DESC
    SQL

    puts QuestionDatabase.instance.execute(select)[0..n-1]
  end

  def initialize(hash)
    @id = hash["id"]
    @title = hash["title"]
    @user_id = hash["user_id"]
    @body = hash["body"]
  end

  def num_likes
    select = <<-SQL
      SELECT COUNT(question_likes.id) num_likes
      FROM questions
      JOIN question_likes
      ON questions.id = question_id
      WHERE questions.id = '#{self.id}'
    SQL

    puts QuestionDatabase.instance.execute(select).first
  end

  def followers
    select = <<-SQL
      SELECT COUNT(question_followers.id) num_followers
      FROM questions
      JOIN question_followers
      ON questions.id = question_id
      WHERE questions.id = '#{self.id}'
    SQL

    puts QuestionDatabase.instance.execute(select).first
  end
end

class Reply
  def self.most_replied
    select = <<-SQL
      SELECT title, COALESCE(COUNT(replies.id), 0) most_replied
      FROM questions
      LEFT JOIN replies
      ON questions.id = question_id
      GROUP BY questions.title
      ORDER BY COUNT(replies.id) DESC
    SQL

    puts QuestionDatabase.instance.execute(select)
  end



  def initialize(hash)
    @id = hash["id"]
    @question_id = hash["question_id"]
    @user_id = hash["user_id"]
    @body = hash["body"]
  end

  def replies
    insert = <<-SQL
      INSERT INTO question_replies

    SQL
  end
end

Reply.most_replied
# Question.find_by_title('How walk?').num_likes
# Question.most_liked(2)
# Question.most_followed(2)
