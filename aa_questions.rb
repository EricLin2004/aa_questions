require 'sqlite3'
require 'singleton'
require 'debugger'
require './reply'
require './question'
require './user'

class QuestionDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("aa_questions.db")
    self.results_as_hash = true
    self.type_translation = true
  end
end


# User.new({'fname' => 'Jonathan', 'lname' => 'Tamboer', 'is_instructor' => true}).save
# p User.find_by_name('Jonathan','Tamboer')
# p User.find_by_name('Eric','Lin')
# User.find_by_name('Eric','Lin').questions
# p User.find_by_name('Luke','Persola')
# p Reply.search_body("Left foot!").replies("You're wrong!")
# User.find_by_name('Luke','Persola').replies
# Reply.most_replied
# Reply.new({parent => 2}).replies
# Question.find_by_title('How walk?').num_likes
# Question.most_liked(2)
 Question.most_followed(2)
