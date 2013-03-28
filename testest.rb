lick = 2
funk = "ger" * lick

query = <<-SQL
  SELECT *
  FROM users
  WHERE fname = '#{funk}'
  AND lname = wut
SQL

p query