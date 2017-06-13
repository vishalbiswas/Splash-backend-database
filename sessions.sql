use splash;

create table sessions (
	sessionid varchar(80) primary key,
	uid bigint foreign key references users(uid),
	etime datetime,
	constraint ck_etime check (etime > getdate())
);

--drop table sessions;