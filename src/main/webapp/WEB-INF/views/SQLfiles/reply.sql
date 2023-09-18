show tables;

create table reply(
	idx int not null auto_increment,
	boardIdx varchar(50) not null,
	content text,
	rating double,
	writeDay datetime default now(),
	mid varchar(20) not null,
	primary key(ridx),
	FOREIGN KEY(mid) REFERENCES user(mid) 
	ON UPDATE CASCADE
);

desc reply;

select * from reply;

select * from reply where boardIdx = 'c10' order by writeDay desc;


insert into reply values(default,?,?,?,default,?)



select * from reply where boardIdx = 'c38' order by writeDay desc limit 5,10;
select * from reply where boardIdx = 'c38' order by writeDay desc,idx desc limit 10,10;

select GROUP_CONCAT(ifNull(r.rating,0))
		from company c left join reply r on concat('c',c.idx) = r.boardidx 
		where c.idx in ('30','38','39')
		group by c.idx 
		ORDER BY FIND_IN_SET(c.idx,'30,38,39');


select r.*,u.profile as profileImg from reply r 
	inner join user u on r.mid = u.mid
	where boardIdx = 'c30'
	group by r.idx
	order by writeDay desc,idx desc;


select * from reply order by writeDay desc;

select c.cpName,r.* 
	from company c right join reply r on concat('c',c.idx) = r.boardidx 
	group by r.idx 
	order by r.writeDay desc


select count(*) from reply where content REGEXP '잘' order by rating desc ;
select * from reply where content REGEXP ' ' order by rating desc, writeDay desc;

select c.cpName as cpName,c.idx as cidx,r.* 
			from company c right join reply r
			on concat('c',c.idx) = r.boardidx 
			where true
			group by r.idx 
			order by r.writeDay desc;


select c.cpName as cpName,c.idx as cidx, r.* 
	from company c right join reply r on concat('c',c.idx) = r.boardidx
	where cpName like '%%'
	group by r.idx
	order by writeDay desc
	limit 0,10;





drop table reply;