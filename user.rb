class User
  attr_reader :id

  def self.find_by_name(fname,lname)
    select = <<-SQL
      SELECT *
      FROM users
      WHERE fname = ?
      AND lname = ?
    SQL
    User.new(QuestionDatabase.instance.execute(select, fname, lname).first)
  end

  def initialize(hash)
    @id = hash["id"]
    @fname = hash["fname"]
    @lname = hash["lname"]
    @is_instructor = hash["is_instructor"] == 0 ? false : true
  end

  def average_karma
    select = <<-SQL
      SELECT AVG(likes) AS avg
      FROM (
           SELECT COUNT(*) likes #Counts all likes > 0
           FROM questions
           JOIN question_likes
           ON question_likes.question_id = questions.id
           WHERE questions.user_id = ?
           UNION
           SELECT 0 likes #Counts all questions with no likes.
           FROM questions
           JOIN question_likes
           ON question_likes.question_id = questions.id
           WHERE questions.user_id = ? AND question_likes.id IS NULL
      )
    SQL

    QuestionDatabase.instance.execute(select, id, id)[0]["avg"]
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