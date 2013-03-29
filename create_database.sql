DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_followers;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_actions;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(30) NOT NULL,
  lname VARCHAR(30) NOT NULL,
  is_instructor ENUM(0,1) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(100),
  user_id INTEGER,
  body TEXT,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  question_id SMALLINT,
  user_id SMALLINT,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

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

INSERT INTO users
     VALUES (null, 'Eric', 'Lin', 0);

INSERT INTO users
     VALUES (null, 'Luke', 'Persola', 1);

INSERT INTO questions
     VALUES (null, 'How database?', 2, "How do I do a thing?");

INSERT INTO questions
     VALUES (null, 'How walk?', 1, "Are legs be walk?");

INSERT INTO questions
     VALUES (null, 'How talk?', 1, "Talking?");

INSERT INTO question_followers
     VALUES (null, 2, 2);

INSERT INTO question_followers
     VALUES (null, 2, 1);

INSERT INTO replies
     VALUES (null, 2, null, 1, "Left foot!");

INSERT INTO replies
     VALUES (null, 2, null, 2, "Right foot!");

INSERT INTO replies
     VALUES (null, 2, 1, 2, "Me right too!");

INSERT INTO replies
     VALUES (null, 1, null, 2, "SQL make computer!");     

INSERT INTO question_likes
     VALUES (null, 2, 1);

INSERT INTO question_likes
     VALUES (null, 2, 2);

INSERT INTO question_likes
     VALUES (null, 3, 2);

INSERT INTO question_likes
     VALUES (null, 3, 1);

-- didn't finish bonus
-- CREATE TABLE tags (
--   id INTEGER PRIMARY KEY,
--   question_id INTEGER,
--   name VARCHAR(30) NOT NULL,
-- );
--
-- CREATE TABLE question_tags (
--   id INTEGER PRIMARY KEY,
--   question_id INTEGER,
--   tag_id INTEGER,
-- );
--
-- INSERT INTO question_tags
-- SELECT questions.id, tags.id
-- FROM questions
-- JOIN tags
-- ON questions
