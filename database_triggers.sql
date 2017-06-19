---------------   NOTIFICATIONS   ------------------

create trigger user_created on users after insert as
	declare @uid as bigint;
	set @uid = (select uid from INSERTED);
	insert into notifications (uid, code, custom, threadid) values (@uid, (select code from notification_constants where codename = 'OTHERS'), 'Welcome to Splash! Be sure to read our forum rules before posting!', 1);
go

create trigger comment_inserted on comments after insert as
	if ((select count(*) from INSERTED) = 1)
	begin
	declare @commentid as bigint;
	declare @actionuid as bigint;
	declare @threadid as bigint;
	declare @parent as bigint;
	declare @tuid as bigint;
	declare @cuid as bigint;
	
	set @commentid = (select commentid from INSERTED);
	set @actionuid = (select creator_id from INSERTED);
	set @threadid = (select threadid from INSERTED);
	set @parent = (select parent from INSERTED);
	set @tuid = (select creator_id from threads where threadid = @threadid);
	set @cuid = (select creator_id from comments where commentid = @parent);
	
	if (@parent is not null AND @cuid != @actionuid)
	begin
		insert into notifications (uid, code, commentid, threadid, actionuid) values (@cuid, (select code from notification_constants where codename = 'COMMENT_TO_COMMENT'), @commentid, @threadid, @actionuid);
	end

	if (@tuid != @actionuid AND @tuid != @cuid)
	begin
		insert into notifications (uid, code, commentid, threadid, actionuid) values (@tuid, (select code from notification_constants where codename = 'COMMENT_TO_THREAD'), @commentid, @threadid, @actionuid);
	end

	end
go

/*
drop trigger user_created;
drop trigger comment_inserted;
*/


-------------------   REPORTED   -----------------------

create trigger comment_reported on reports_comments after insert as
if ((select userid from INSERTED) is not null)
begin
	declare @commentid as bigint
	set @commentid = (select commentid from INSERTED);
	update comments set reported=(select reported from comments where commentid=@commentid) + 1 where commentid=@commentid;
end
go

create trigger thread_reported on reports_threads after insert as
if ((select userid from INSERTED) is not null)
begin
	declare @threadid as bigint
	set @threadid = (select threadid from INSERTED);
	update threads set reported=(select reported from threads where threadid=@threadid) + 1 where threadid=@threadid;
end
go

create trigger user_reported on reports_users after insert as
if ((select userid from INSERTED) is not null)
begin
	declare @uid as bigint
	set @uid = (select uid from INSERTED);
	update users set reported=(select reported from users where uid=@uid) + 1 where uid=@uid;
end
go

create trigger comment_modified on comments after update as
declare @commentid as bigint
declare @threadid as bigint
declare @uid as bigint
declare @locked as tinyint
declare @hidden as tinyint

set @commentid = (select commentid from inserted);
set @threadid = (select threadid from inserted);
set @uid = (select creator_id from inserted);
set @locked = (select locked from inserted except select locked from deleted);
set @hidden = (select hidden from inserted except select hidden from deleted);

if (@locked = 1)
begin
	insert into notifications (uid, code, commentid, threadid) values (@uid, (select code from notification_constants where codename = 'COMMENT_LOCKED'), @commentid, @threadid);
end
else if (@locked = 0)
begin
	insert into notifications (uid, code, commentid, threadid) values (@uid, (select code from notification_constants where codename = 'COMMENT_UNLOCKED'), @commentid, @threadid);
end

if (@hidden = 1)
begin
	insert into notifications (uid, code, custom) values (@uid, (select code from notification_constants where codename = 'COMMENT_HIDDEN'), (select content from comments where commentid = @commentid));
end
else if (@hidden = 0)
begin
	insert into notifications (uid, code, commentid, threadid) values (@uid, (select code from notification_constants where codename = 'COMMENT_UNHIDDEN'), @commentid, @threadid);
end
go

create trigger thread_modified on threads after update as
declare @threadid as bigint
declare @uid as bigint
declare @locked as tinyint
declare @hidden as tinyint

set @threadid = (select threadid from inserted);
set @uid = (select creator_id from inserted);
set @locked = (select locked from inserted except select locked from deleted);
set @hidden = (select hidden from inserted except select hidden from deleted);

if (@locked = 1)
begin
	insert into notifications (uid, code, threadid) values (@uid, (select code from notification_constants where codename = 'THREAD_LOCKED'), @threadid);
end
else if (@locked = 0)
begin
	insert into notifications (uid, code, threadid) values (@uid, (select code from notification_constants where codename = 'THREAD_UNLOCKED'), @threadid);
end

if (@hidden = 1)
begin
	insert into notifications (uid, code, custom) values (@uid, (select code from notification_constants where codename = 'THREAD_HIDDEN'), (select content from threads where @threadid = @threadid));
end
else if (@hidden = 0)
begin
	insert into notifications (uid, code, threadid) values (@uid, (select code from notification_constants where codename = 'THREAD_UNHIDDEN'), @threadid);
end
go

create trigger user_modified on users after update as
declare @uid as bigint
declare @cancomment as tinyint
declare @canpost as tinyint
declare @banned as tinyint

set @uid = (select uid from inserted);
set @canpost = (select canpost from inserted except select canpost from deleted);
set @cancomment = (select cancomment from inserted except select cancomment from deleted);
set @banned = (select banned from inserted except select banned from deleted);

if (@cancomment = 0 OR @canpost = 0)
begin
	insert into notifications (uid, code) values (@uid, (select code from notification_constants where codename = 'REVOKED'));
end
else if (@cancomment = 1 OR @canpost = 1)
begin
	insert into notifications (uid, code) values (@uid, (select code from notification_constants where codename = 'REVIVED'));
end

if (@banned = 0)
begin
	insert into notifications (uid, code) values (@uid, (select code from notification_constants where codename = 'UNBANNED'));
end

if ((select ismod from inserted) > (select ismod from deleted))
begin
	insert into notifications (uid, code) values (@uid, (select code from notification_constants where codename = 'PROMOTED'));
end
else if ((select ismod from inserted) < (select ismod from deleted))
begin
	insert into notifications (uid, code) values (@uid, (select code from notification_constants where codename = 'DEMOTED'));
end
go

/*
drop trigger comment_reported;
drop trigger thread_reported;
drop trigger user_reported;

drop trigger comment_modified;
drop trigger thread_modified;
drop trigger user_modified;
*/