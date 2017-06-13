use splash;

create table comments (
  commentid bigint identity primary key,
  threadid bigint foreign key references threads(threadid) not null,
  content text not null,
  creator_id bigint foreign key references users(uid) not null,
  parent bigint foreign key references comments(commentid) default null,
  ctime datetime default CURRENT_TIMESTAMP not null,
  mtime datetime default CURRENT_TIMESTAMP not null,
  locked bit default 0,
  hidden bit default 0,
  reported int default 0
);

INSERT INTO comments (threadid, content, creator_id) OUTPUT INSERTED.commentid, INSERTED.ctime, INSERTED.mtime VALUES (1, 'temporary comment', 1);

select * from comments;

--drop table comments;
