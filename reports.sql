use splash;

create table reports_threads (
	reportid bigint primary key identity,
	threadid bigint foreign key references threads(threadid) not null,
	userid bigint foreign key references users(uid),
	modid bigint foreign key references users(uid),
	action int default 0, -- 0 -> Report, 1 -> Release, 2 -> Lock, 3 -> Hide
	ctime datetime default CURRENT_TIMESTAMP,
	constraint user_or_mod_threads check (userid != null or modid != null),
	constraint unique_thread_key unique (threadid, userid)
);

create table reports_comments (
	reportid bigint primary key identity,
	commentid bigint foreign key references comments(commentid) not null,
	userid bigint foreign key references users(uid),
	modid bigint foreign key references users(uid),
	action int default 0, -- 0 -> Report, 1 -> Release, 2 -> Lock, 3 -> Hide
	ctime datetime default CURRENT_TIMESTAMP,
	constraint user_or_mod_comments check (userid != null or modid != null),
	constraint unique_comment_key unique (commentid, userid)
);

create table reports_users (
	reportid bigint primary key identity,
	uid bigint foreign key references users(uid) not null,
	userid bigint foreign key references users(uid),
	modid bigint foreign key references users(uid),
	action int default 0, -- 0 -> Report, 1 -> Release, 2 -> Lock, 3 -> Hide
	ctime datetime default CURRENT_TIMESTAMP,
	constraint user_or_mod_users check (userid != null or modid != null),
	constraint unique_user_key unique (uid, userid)
);

select * from reports_threads;
select * from reports_comments;
select * from reports_users;

/*
drop table reports_threads;
drop table reports_comments;
drop table reports_users;
*/