require 'sqlite3'
require 'singleton'

class User

end

class QuestionDatabase < SQLite3::Database
  include Singleton
  def select

  end

  def initialize
    super("aa_questions.db")
    self.results_as_hash = true
    self.type_translation = true
  end

  def create_table(name, arr)
    query = "CREATE TABLE name ("

    arr.each do |hash|
      query += "#{hash[:col_name]} #{hash[:type]}"
      unless hash[constraint].nil?
        query += " #{hash[:constraint]}"
      end
      ","
    end

    query = query[0..-2] + ');'

    QuestionDatabase.instance.execute(query)
  end

end

class Question
  def self.most_liked(n)

  end

  def self.most_followed(n)
  end

  def num_likes

  end

  def
end

class Question_replies
end

class Question_followers
end

class Question_actions
end

class Question_likes
end

QuestionDatabase.new