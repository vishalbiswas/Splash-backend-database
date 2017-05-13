use splash;

create table topics (
    topicid int primary key identity NOT NULL,
    name varchar(150) NULL
);

insert into topics values ('Android Development');
insert into topics values ('Web Development');

drop table topics;