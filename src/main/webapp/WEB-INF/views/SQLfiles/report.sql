show tables;


create table report(
	replyIdx int not null,
	replyMid varchar(20) not null,
	replyContent text,
	replyWriteDay datetime,
	reportMid varchar(20) not null,
	reportWriteDay datetime default now(),
	FOREIGN KEY(replyMid) REFERENCES user(mid) 
	ON UPDATE CASCADE,
	FOREIGN KEY(reportMid) REFERENCES user(mid) 
	ON UPDATE CASCADE
);

alter table report add FOREIGN KEY(replyMid) REFERENCES user(mid) ON UPDATE CASCADE;

select * from report;

select * from information_schema.table_constraints where table_name = 'report';

alter table report drop foreign key report_ibfk_1;


insert into report values (default,replyIdx,replyMid,replyContent,replyWriteDay,'saasdfhr','없음',default) 
	select r.idx as replyIdx,r.mid as replyMid,r.content as replyContent, r.writeDay as replyWriteDay
	from reply r where r.idx = 38;

insert into report values 
	(default,(select idx from reply where idx = 38),(select mid from reply where idx = 38),
	(select content from reply where idx = 38),(select writeDay from reply where idx = 38)
	,'saasdfhr','없음',default) 
	
insert into report values 
	(default,(select idx from reply where idx = #{}),(select mid from reply where idx = #{}),
	(select content from reply where idx = #{}),(select writeDay from reply where idx = #{})
	,#{},#{},default);




delete from reply where ridx = 3;
