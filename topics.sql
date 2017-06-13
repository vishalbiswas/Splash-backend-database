use splash;

create table topics (
    topicid int primary key identity NOT NULL,
    [name] varchar(150) NULL,
    locked bit default 0,
    hidden bit default 0
);

insert into topics ([name]) values ('Android Development');
insert into topics ([name]) values ('Web Development');

select * from topics;

--drop table topics;