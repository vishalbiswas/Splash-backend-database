create table notifications (
	id bigint identity primary key,
	uid bigint foreign key references users(uid) not null,
	code int not null,
	custom text default null,
	done bit default 0,
	commentid bigint foreign key references comments(commentid) default null,
	threadid bigint foreign key references threads(threadid) default null,
	actionuid bigint foreign key references users(uid) default null,
	ctime datetime default CURRENT_TIMESTAMP,
	constraint uid_actionuid check(actionuid != uid)
);

insert into notifications (uid, code, custom) values (1, 0, 'Welcome to Splash!');

select * from notifications;

--drop table notifications;