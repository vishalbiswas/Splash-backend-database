create table sessions (
	sessionid varchar(80) primary key,
	uid bigint foreign key references users(uid),
	etime datetime
);

--drop table sessions;