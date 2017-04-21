use splash;

create table attachments (
  attachid bigint identity primary key,
  image varbinary(max) default null,
  size bigint default 0
);

select * from attachments;

drop table attachments;