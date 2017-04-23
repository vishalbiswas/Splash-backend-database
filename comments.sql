use splash;

create table comments (
  commentid bigint identity primary key,
  threadid bigint foreign key references threads(threadid),
  content text not null,
  creator_id bigint foreign key references users(uid),
  ctime datetime default CURRENT_TIMESTAMP not null,
  mtime datetime default CURRENT_TIMESTAMP not null,
);

INSERT INTO comments (threadid, content, creator_id) OUTPUT INSERTED.commentid, INSERTED.ctime, INSERTED.mtime VALUES (1, 'temporary comment', 1);

select * from comments;

--drop table comments;
