class Question
  attr_reader :id, :question_id, :parent_id, :user_id, :body

  def self.find_by_title(title)
    select = <<-SQL
      SELECT *
      FROM questions
      WHERE title = ?
    SQL

    Question.new(QuestionDatabase.instance.execute(select, title).first)
  end

  def self.find_by_id(id)
    select = <<-SQL
      SELECT *
      FROM questions
      WHERE id = ?
    SQL

    QuestionDatabase.instance.execute(select, id)
  end

  def self.most_liked(n)
    select = <<-SQL
      SELECT questions.*
      FROM questions
      LEFT JOIN question_likes
      ON questions.id = question_id
      GROUP BY question_id
      ORDER BY COUNT(*) DESC
      LIMIT ?
    SQL

    QuestionDatabase.instance.execute(select, n).map {|hash| Question.new(hash)}
  end

  def self.most_followed(n)
    select = <<-SQL
      SELECT questions.*
      FROM questions
      LEFT JOIN question_followers
      ON questions.id = question_id
      GROUP BY questions.title
      ORDER BY COUNT(*) DESC
      LIMIT ?
    SQL

    QuestionDatabase.instance.execute(select, n).map {|hash| Question.new(hash)}
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
      FROM question_likes
      WHERE question_id = ?
    SQL

    QuestionDatabase.instance.execute(select, id)[0]['num_likes']
  end

  def followers
    select = <<-SQL
      SELECT users.*
      FROM users
      JOIN question_followers
      ON user_id = users.id
      WHERE question_id = ?
    SQL

    QuestionDatabase.instance.execute(select, id).map {|hash| User.new(hash)}
  end

  def save
    if @id.nil?
      save = <<-SQL
        INSERT INTO questions
        (title, user_id, body)
        VALUES (?, ?, ?)
      SQL
      QuestionDatabase.instance.execute(save, title, user_id, body)
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      save = <<-SQL
        UPDATE questions
        (title, user_id, body)
        VALUES (?, ?, ?)
        WHERE questions.id = ?
      SQL
      QuestionDatabase.instance.execute(save, title, user_id, body, id)
    end
  end

  def asking_student
    select = <<-SQL
      SELECT users.*
      FROM users
      JOIN questions
      ON questions.user_id = users.id
      WHERE questions.id = ?
    SQL

    User.new(QuestionDatabase.instance.execute(select,id).first)
  end
end
