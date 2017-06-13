use splash;
go

create function getCode(@CodeName varchar(50)) returns int as
begin
	return (select code from notification_constants where codename = @CodeName);
end
go


---------------   NOTIFICATIONS   ------------------

create trigger comment_inserted on comments after insert as
	if ((select count(*) from INSERTED) = 1)
	begin
	declare @commentid as bigint;
	declare @actionuid as bigint;
	declare @threadid as bigint;
	declare @parent as bigint;
	declare @uid as bigint;
	
	set @commentid = (select commentid from INSERTED);
	set @actionuid = (select creator_id from INSERTED);
	set @threadid = (select threadid from INSERTED);
	set @parent = (select parent from INSERTED);
	set @uid = (select creator_id from threads where threadid = @threadid);
	
	if (@uid != @actionuid)
	begin
	insert into notifications (uid, code, commentid, threadid, actionuid) values (@uid, (select dbo.getCode('COMMENT_TO_THREAD')), @commentid, @threadid, @actionuid);
	end

	set @uid = (select creator_id from comments where commentid = @parent);

	if (@parent is not null AND @uid != @actionuid)
	begin
		insert into notifications (uid, code, commentid, threadid, actionuid) values (@uid, (select dbo.getCode('COMMENT_TO_COMMENT')), @commentid, @threadid, @actionuid);
	end
	end
go

--drop trigger comment_inserted;
--drop function getCode;


-------------------   REPORTED   -----------------------

create trigger comment_reported on reports_comments after insert as
if ((select userid from INSERTED) != null)
begin
	declare @commentid as bigint
	set @commentid = (select commentid from INSERTED);
	update comments set reported=(select reported from comments where commentid=@commentid) + 1 where commentid=@commentid;
end
go

create trigger comment_lock on comments after update as
declare @reported_row as table (
commentid bigint,
reported int,
locked tinyint
)

select c.commentid, c.reported, c.locked into reported_row
FROM comments c
INNER JOIN Inserted I ON c.commentid = I.commentid
INNER JOIN Deleted D ON c.commentid = D.commentid
WHERE c.reported <> I.reported
AND D.reported <> I.reported

if ((select reported from reported_row) >= 10 and (select locked from reported_row) != 1)
begin
	update comments set locked=1 where commentid=(select commentid from reported_row);
end
go

/*
drop trigger comment_reported;
drop trigger comment_lock;
*/