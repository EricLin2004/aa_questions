CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(30) NOT NULL,
  lname VARCHAR(30) NOT NULL,
  is_instructor ENUM(0,1)
);

INSERT INTO users
  (fname, lname, is_instructor)
  VALUES ('Luke', 'Persola', 1),
         ('Eric', 'Lin', 0);
