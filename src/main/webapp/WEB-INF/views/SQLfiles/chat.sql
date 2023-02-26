show tables;


create table chatRoomId(
	idx int not null auto_increment primary key,
	roomId text not null,
	userId_1 varchar(20) not null,
	userId_2 varchar(20) not null,
	createIdDay datetime default now(),
	FOREIGN KEY(userId_1) REFERENCES user(mid) 
	ON UPDATE CASCADE,
	FOREIGN KEY(userId_2) REFERENCES user(mid) 
	ON UPDATE CASCADE
);

desc chatRoomId;


create table chatContent(
	idx int not null auto_increment primary key,
	content text not null,
	sendId varchar(20) not null,
	receiveId varchar(20) not null,
	sendDay datetime default now(),
	FOREIGN KEY(sendId) REFERENCES user(mid) 
	ON UPDATE CASCADE,
	FOREIGN KEY(receiveId) REFERENCES user(mid) 
	ON UPDATE CASCADE
)

desc chatContent;



select * from chatcontent where (sendId = 'saasdfhr' or receiveId = 'saasdfhr') and (sendId = 'SzQpNcjt' or receiveId = 'SzQpNcjt') order by sendDay;
select * from chatcontent where sendId in ('saasdfhr','SzQpNcjt') and receiveId in ('saasdfhr','SzQpNcjt') order by sendDay desc limit 0,20;
select idx from chatContent where sendId in ('saasdfhr','asdf') and receiveId in ('saasdfhr','asdf') order by sendDay limit 0,1;



create table realNotice(
	idx int not null auto_increment primary key,
	noticeType varchar(20) not null,
	noticeContent text not null,
	noctieMid varchar(20) not null,
	noticeDay datetime default now(),
	url text,
	FOREIGN KEY(noctieMid) REFERENCES user(mid) 
	ON UPDATE CASCADE
)

select * from realNotice;
desc realNotice;


select cr.roomId,cc.content,cc.sendDay 
	from chatroomid cr, chatcontent cc 
	where (cr.userId_1 = 'saasdfhr' or cr.userId_2 = 'saasdfhr')
	and (cc.sendId = 'saasdfhr' or cc.receiveId = 'saasdfhr')
	group by cr.roomId
	order by cc.sendDay desc;
	
select cr.roomId,cc.content,cc.sendDay 
	from chatcontent cc, (select roomId,userId_1,userId_2 from where chatroomid userId_1 = 'saasdfhr' or userId_2 = 'saasdfhr') as cr
	where (cc.sendId = cr.userId_1 or cc.receiveId = cr.userId_1)
	and (cc.sendId = cr.userId_2 or cc.receiveId = cr.userId_2)
	group by cr.roomId
	order by cc.sendDay desc;

select content,sendDay
	from chatcontent
	where (sendId = 'saasdfhr' or receiveId = 'saasdfhr')
	and (sendId = 'SzQpNcjt' or receiveId = 'SzQpNcjt')
	order by sendDay desc;
	
	

select d.*,c.roomId from (
	select max(a.sendDay) as lastDay,b.roomId
		from chatcontent a INNER join chatroomid b 
		on (a.sendId = b.userId_1 or a.receiveId = b.userId_1) and (a.sendId = b.userId_2 or a.receiveId = b.userId_2)
		group by roomId) c, chatcontent d
			where d.sendDay = c.lastDay and (d.sendId = 'saasdfhr' or d.receiveId = 'saasdfhr');
			
select f.*,ifnull(group_concat(g.cpName),''),ifnull(group_concat(g.mid),'') from 
	(select e.* from 
		(select d.*,c.roomId from (
			select max(a.sendDay) as lastDay,b.roomId
				from chatcontent a INNER join chatroomid b 
				on (a.sendId = b.userId_1 or a.receiveId = b.userId_1) and (a.sendId = b.userId_2 or a.receiveId = b.userId_2)
				group by roomId) c, chatcontent d
					where d.sendDay = c.lastDay and (d.sendId = 'saasdfhr' or d.receiveId = 'saasdfhr')) e) f 
					left join company g on g.mid in (f.sendId,f.receiveId)
				group by f.roomId
				order by f.sendDay desc;
				
select e.*,ifnull(group_concat(f.cpName),'') as cpName ,ifnull(group_concat(f.mid),'') as cpMid from 
	(select d.*,c.roomId from (
		select max(a.sendDay) as lastDay,b.roomId
			from chatcontent a INNER join chatroomid b 
			on (a.sendId = b.userId_1 or a.receiveId = b.userId_1) and (a.sendId = b.userId_2 or a.receiveId = b.userId_2)
			group by roomId) c, chatcontent d
				where d.sendDay = c.lastDay and (d.sendId = 'saasdfhr' or d.receiveId = 'saasdfhr') group by c.roomId) e
				left join company f on f.mid in (e.sendId,e.receiveId)
				group by e.roomId,idx
				order by e.sendDay desc;
				
select e.*,ifnull(group_concat(f.cpName),'') as cpName ,ifnull(group_concat(f.mid),'') as cpMid, ifnull(group_concat(f.idx),'') as cpIdx from 
	(select d.*,c.roomId from (
		select max(a.sendDay) as lastDay,b.roomId
			from chatcontent a INNER join chatroomid b 
			on (a.sendId = b.userId_1 or a.receiveId = b.userId_1) and (a.sendId = b.userId_2 or a.receiveId = b.userId_2)
			and (a.sendId = 'SzQpNcjt' or a.receiveId = 'SzQpNcjt') group by roomId) c
			inner join chatcontent d on sendDay in (c.lastDay) group by c.roomId) e
				left join company f on f.mid in (e.sendId,e.receiveId)
				group by e.roomId,idx
				order by e.sendDay desc;
				

select e.*,ifnull(group_concat(f.cpName),'') as cpName ,ifnull(group_concat(f.mid),'') as cpMid, ifnull(group_concat(f.idx),'') as cpIdx from 
	(select d.*,c.roomId from 
		(select max(a.sendDay) as lastDay,b.roomId
			from chatcontent a INNER join chatroomid b 
			on (a.sendId = b.userId_1 or a.receiveId = b.userId_1) and (a.sendId = b.userId_2 or a.receiveId = b.userId_2)
			and (a.sendId = 'saasdfhr' or a.receiveId = 'saasdfhr') group by roomId) c
			inner join chatcontent d on sendDay in (c.lastDay) group by c.roomId) e
				left join company f on f.mid in (e.sendId,e.receiveId)
				group by e.roomId,e.idx		
				
----------
select g.*,ifnull(group_concat(h.cpImg),(select profile from user where mid in (g.sendId,g.receiveId) and mid not in ('saasdfhr'))) as oppImg from
	(select e.*,ifnull(group_concat(f.cpName),'') as oppCpName ,ifnull(group_concat(f.mid),'') as oppCpMid, ifnull(group_concat(f.idx),'') as oppCpIdx from 
		(select d.*,c.roomId from 
			(select max(a.sendDay) as lastDay,b.roomId
				from chatcontent a INNER join chatroomid b 
				on (a.sendId = b.userId_1 or a.receiveId = b.userId_1) and (a.sendId = b.userId_2 or a.receiveId = b.userId_2)
				and (a.sendId = 'saasdfhr' or a.receiveId = 'saasdfhr') group by roomId) c
				inner join chatcontent d on sendDay in (c.lastDay) group by c.roomId) e
					left join company f on f.mid in (e.sendId,e.receiveId) and f.mid not in ('saasdfhr')
					group by e.roomId,e.idx) g 
					left join companyImg h
						on h.cidx in (g.oppCpIdx)
						group by g.idx
						order by g.sendDay desc;
--------				

select g.*,h.cidx as tidx,ifnull(group_concat(h.cpImgOri),'') from
(select e.*,ifnull(group_concat(f.cpName),'') as cpName ,ifnull(group_concat(f.mid),'') as cpMid, ifnull(group_concat(f.idx),'') as cpIdx from 
	(select d.*,c.roomId from 
		(select max(a.sendDay) as lastDay,b.roomId
			from chatcontent a INNER join chatroomid b 
			on (a.sendId = b.userId_1 or a.receiveId = b.userId_1) and (a.sendId = b.userId_2 or a.receiveId = b.userId_2)
			and (a.sendId = 'Q1vLoSvw' or a.receiveId = 'Q1vLoSvw') group by roomId) c
			inner join chatcontent d on sendDay in (c.lastDay) group by c.roomId) e
				left join company f on f.mid in (e.sendId,e.receiveId)
				group by e.roomId,e.idx) g 
				left join companyImg h
					on h.cidx in (g.cpIdx)
					group by g.idx;

				
				order by e.sendDay desc;
				(select ci.cidx,ci.cpImg,ci.cpimgOri from companyImg ci inner join company co on ci.cidx = co.idx group by ci.cidx)
				
select * from
	(select * from companyImg ci inner join company co on ci.cidx = co.idx and co.idx in (37,36) group by ci.idx)
					
				,ifnull(group_concat(g.cpName),'') as cpName,ifnull(group_concat(h.mid),'') as cpMid 
					(select cpName from company where mid in (d.sendId,d.receiveId)) g,
					(select mid from company where mid in (d.sendId,d.receiveId)) h
				group by e.idx
				order by e.sendDay desc;
				
				
				
				where f.mid in (e.sendId,e.receiveId) or g.mid in (e.sendId,e.receiveId)
			

select g.*,ifnull(group_concat(h.cpImg),(select profile from user where mid in (g.sendId,g.receiveId) and mid not in (#{mid}))) as oppImg
			from (select e.*,ifnull(group_concat(f.cpName),'') as oppCpName ,ifnull(group_concat(f.mid),'') as oppCpMid, ifnull(group_concat(f.idx),'') as oppCpIdx
							from (select d.*,c.roomId 
											from (select max(a.sendDay) as lastDay,b.roomId
															from chatcontent a INNER join chatroomid b 
															on (a.sendId = b.userId_1 or a.receiveId = b.userId_1) and (a.sendId = b.userId_2 or a.receiveId = b.userId_2)
															and (a.sendId = #{mid} or a.receiveId = #{mid}) group by roomId) c
											inner join chatcontent d on sendDay in (c.lastDay) group by c.roomId) e
							left join company f on f.mid in (e.sendId,e.receiveId) and f.mid not in (#{mid})
							group by e.roomId,e.idx) g 
			left join companyImg h
			on h.cidx in (g.oppCpIdx)
			group by g.idx
			order by g.sendDay desc;



drop table chatRoomId;
drop table chatContent;
