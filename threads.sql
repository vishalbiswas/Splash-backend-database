use splash;

create table threads (
  threadid bigint identity primary key,
  title varchar(100) not null,
  content text not null,
  creator_id bigint foreign key references users(uid),
  ctime datetime default CURRENT_TIMESTAMP not null,
  mtime datetime default CURRENT_TIMESTAMP not null,
  topicid int foreign key references topics(topicid) not null,
  attachid bigint foreign key references attachments(attachid) default null,
  locked bit default 0,
  hidden bit default 0,
  reported int default 0
);

INSERT INTO threads (title, content, creator_id, topicid, attachid) OUTPUT INSERTED.threadid, INSERTED.ctime, INSERTED.mtime VALUES ('hello', 'splash', 1, 1, null);

select * from threads;

--drop table threads;
