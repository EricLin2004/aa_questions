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