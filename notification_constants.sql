create table notification_constants (
	codename varchar(50) primary key,
	code int unique not null,
)

insert into notification_constants values ('OTHERS', 0);
insert into notification_constants values ('COMMENT_TO_THREAD', 1);
insert into notification_constants values ('COMMENT_TO_COMMENT', 2);
insert into notification_constants values ('COMMENT_LOCKED', 3);
insert into notification_constants values ('THREAD_LOCKED', 4);
insert into notification_constants values ('COMMENT_UNLOCKED', 5);
insert into notification_constants values ('THREAD_UNLOCKED', 6);
insert into notification_constants values ('UNBANNED', 7);
insert into notification_constants values ('REVOKED', 8);
insert into notification_constants values ('REVIVED', 9);
insert into notification_constants values ('COMMENT_UNHIDDEN', 10);
insert into notification_constants values ('THREAD_UNHIDDEN', 11);
insert into notification_constants values ('COMMENT_HIDDEN', 12);
insert into notification_constants values ('THREAD_HIDDEN', 13);
insert into notification_constants values ('PROMOTED', 14);
insert into notification_constants values ('DEMOTED', 15);

select * from notification_constants;

--drop table notification_constants