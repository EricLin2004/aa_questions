class Reply
  def self.find_by_id(id)
    find = <<-SQL
      SELECT *
      FROM replies
      WHERE id = ?
    SQL

    QuestionDatabase.instance.execute(ind, id)
  end

  def self.most_replied
    select = <<-SQL
      SELECT repb.*
      FROM replies repa
      JOIN replies repb
      ON repa.parent_id = repb.id
      GROUP BY repa.parent_id
      ORDER BY COUNT(repa.id) DESC
      LIMIT 1
    SQL

    Reply.new(QuestionDatabase.instance.execute(select).first)
  end

  def initialize(hash)
    @id = hash["id"]
    @question_id = hash["question_id"]
    @user_id = hash["user_id"]
    @body = hash["body"]
  end

  def replies
     select = <<-SQL
       SELECT *
       FROM replies
       WHERE parent_id = ?
     SQL

     QuestionDatabase.instance.execute(select, id).map {|hash| Reply.new(hash)}
  end

  def save
    if id.nil?
      save = <<-SQL
        INSERT INTO replies
        VALUES (null, ?, ?, ?, ?)
      SQL
      QuestionDatabase.instance.execute(save, question_id, parent_id, user_id, body)
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      save = <<-SQL
        UPDATE users
        SET fname         = ?,
            lname         = ?,
            is_instructor = ?
        WHERE id = ?
      SQL
      QuestionDatabase.instance.execute(save, question_id, parent_id, user_id, body)
    end
  end
end

class Tags
  def self.most_popular(n)
    select = <<-SQL
      SELECT questions.*
      FROM questions
      JOIN question_tags
      ON questions.id = question_tags.question_id
      JOIN tags
      ON tags.id = question_tags.tag_id
      WHERE tags.name = '#{el}'
      GROUP BY questions.title
      ORDER BY COUNT(*)
      LIMIT ?
    SQL
    QuestionDatabase.instance.execute(select, n).map {|hash| Question.new(hash)}
  end
end