CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(30) NOT NULL,
  lname VARCHAR(30) NOT NULL,
  is_instructor ENUM(0,1) NOT NULL
);

INSERT INTO users
  (fname, lname, is_instructor)
  VALUES ('Luke', 'Persola', 1),
         ('Eric', 'Lin', 0);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(100),
  user_id INTEGER,
  body TEXT,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO questions
  (title, user_id, body)
  VALUES ('How database?', 2, "How do I do a thing?"),
         ('How walk?', 1, "Are legs be walk?"),
         ('How talk?', 1, "Talking?");

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  question_id SMALLINT,
  user_id SMALLINT,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO question_followers
  (question_id, user_id)
  VALUES (2, 2),
         (2, 1);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id SMALLINT,
  parent_id SMALLINT,
  user_id SMALLINT,
  body TEXT,

  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id)  REFERENCES users(id)
);

INSERT INTO replies
  (question_id, parent_id, user_id, body)
  VALUES (2, null, 1, "Left foot!"),
         (2, null, 2, "Right foot!"),
         (2, 1, 2, "Me right too!"),
         (1, null, 2, "SQL make computer!");

CREATE TABLE question_actions (
  id INTEGER PRIMARY KEY,
  question_id SMALLINT,
  user_id SMALLINT,
  action VARCHAR(30),

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id)  REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id SMALLINT,
  user_id SMALLINT,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id)  REFERENCES users(id)
);

INSERT INTO question_likes
  (question_id, user_id)
  VALUES (2, 1),
         (2, 2),
         (3, 2),
       (3, 1);
