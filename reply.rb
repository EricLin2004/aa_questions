class Reply
  def self.search_body(body)
    select = <<-SQL
      SELECT *
      FROM questions
      JOIN replies
      ON questions.id = replies.question_id
      WHERE replies.body = ?
    SQL

    Reply.new(QuestionDatabase.instance.execute(select, body).first)
  end

  def self.most_replied
    select = <<-SQL
      SELECT title, COALESCE(COUNT(replies.id), 0) most_replied
      FROM questions
      LEFT JOIN replies
      ON questions.id = question_id
      GROUP BY questions.title
      ORDER BY COUNT(replies.id) DESC
    SQL

    puts QuestionDatabase.instance.execute(select).first
  end

  def initialize(hash)
    @id = hash["id"]
    @question_id = hash["question_id"]
    @user_id = hash["user_id"]
    @body = hash["body"]
  end

  def replies(text)
    #debugger
     insert = <<-SQL
       INSERT INTO replies
       (question_id, parent_id, user_id, body)
       VALUES (?, ?, ?, ?);
     SQL

     QuestionDatabase.instance.execute(insert, @question_id, @id, @user_id, text)
  end

end
