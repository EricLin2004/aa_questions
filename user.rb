class User
  attr_reader :id

  def self.find_by_name(fname,lname)
    select = <<-SQL
      SELECT *
      FROM users
      WHERE fname = ?
      AND lname = ?
    SQL
    #debugger
    User.new(QuestionDatabase.instance.execute(select, fname, lname).first)
  end

  def self.find_by_id(id)
    select = <<-SQL
      SELECT *
      FROM users
      WHERE users.id = ?
    SQL

    User.new(QuestionDatabase.instance.execute(select, id))
  end

  def initialize(hash)
    @id = hash["id"]
    @fname = hash["fname"]
    @lname = hash["lname"]
    @is_instructor = hash["is_instructor"] == 0 ? false : true
  end

  def average_karma
    select = <<-SQL
      SELECT COUNT(question_likes.id) / COUNT(DISTINCT questions.title) average_karma
      FROM users
      JOIN questions
      ON (users.id = questions.user_id)
      LEFT JOIN question_likes
      ON (questions.id = question_id)
      WHERE users.id = ?
    SQL

    QuestionDatabase.instance.execute(select, id)
  end

  def questions
    select = <<-SQL #rounds down
      SELECT *
      FROM questions
      WHERE user_id = ?
    SQL

    QuestionDatabase.instance.execute(select, id)
  end

  def replies
    select = <<-SQL #rounds down
      SELECT *
      FROM replies
      WHERE user_id = ?
    SQL

    QuestionDatabase.instance.execute(select, id)
  end

  def save
    if id.nil?
      save = <<-SQL
        INSERT INTO users
        VALUES (null, ?, ?, ?)
      SQL
      QuestionDatabase.instance.execute(save, fname, lname, is_instructor ? 1 : 0)
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      save = <<-SQL
        UPDATE users
        SET fname         = ?,
            lname         = ?,
            is_instructor = ?
        WHERE id = ?
      SQL
      QuestionDatabase.instance.execute(save, fname, lname, is_instructor ? 1 : 0, id)
    end
  end
end