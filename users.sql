CREATE TABLE users (
  uid bigint identity NOT NULL primary key,
  username varchar(50) NOT NULL unique,
  password varchar(50) NOT NULL,
  email varchar(100) NOT NULL unique,
  regtime datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modtime datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fname varchar(50) DEFAULT NULL,
  lname varchar(50) DEFAULT NULL,
  profpic bigint foreign key references attachments(attachid) default null,
  canpost bit default 1,
  cancomment bit default 1,
  ismod int default 0,
  banned bit default 0,
  reported int default 0
);

insert into users (username, password, email, fname, lname, ismod) values ('vishalbiswas', 'testing', 'vshlbiswas@ymail.com', 'Vishal', 'Biswas', 2);

select * from users;

--drop table users;
