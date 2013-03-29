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
# User.find_by_name('Jonathan','Tamboer')
#p User.find_by_name('Eric','Lin')
#p User.find_by_name('Eric','Lin').questions
# User.find_by_name('Luke','Persola')
# Reply.search_body("Left foot!").replies("You're wrong!")
# User.find_by_name('Luke','Persola').replies
#p Reply.most_replied
# Reply.new({parent => 2}).replies
#p Question.find_by_title('How database?').asking_student
# Question.find_by_title('How walk?').followers
# Question.most_liked(2)
# Question.most_followed(2)
p User.find_by_name('Eric','Lin').average_karma
