use splash;

create table attachments (
  attachid bigint identity primary key,
  filename varchar(256) default null,
  data varbinary(max) default null,
  type varchar(50) default 'application/octect-stream',
  size bigint default 0
);

select * from attachments;

--drop table attachments;
