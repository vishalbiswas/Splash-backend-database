use splash;

create table notification_constants (
	codename varchar(50) primary key,
	code int unique not null,
)

insert into notification_constants values ('OTHERS', 0);
insert into notification_constants values ('COMMENT_TO_THREAD', 1);
insert into notification_constants values ('COMMENT_TO_COMMENT', 2);

--drop table notification_constants