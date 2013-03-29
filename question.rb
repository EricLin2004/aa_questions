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
      WHERE questions.id = ?
    SQL

    puts QuestionDatabase.instance.execute(select, self.id).first
  end

  def followers
    select = <<-SQL
      SELECT COUNT(question_followers.id) num_followers
      FROM questions
      JOIN question_followers
      ON questions.id = question_id
      WHERE questions.id = ?
    SQL

    puts QuestionDatabase.instance.execute(select, self.id).first
  end

  def save
    if @id.nil?
      save = <<-SQL
        INSERT INTO questions
        (title, user_id, body)
        VALUES (?, ?, ?)
      SQL
    else
      save = <<-SQL
        UPDATE questions
        (title, user_id, body)
        VALUES (?, ?, ?)
        WHERE questions.id = ?
      SQL
    end

    QuestionDatabase.instance.execute(save, @title, @user_id, @body, @id)
  end
end
