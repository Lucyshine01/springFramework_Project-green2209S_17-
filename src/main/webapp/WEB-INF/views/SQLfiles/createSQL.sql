show tables;

create table user (
	uidx int not null auto_increment,
	mid varchar(20) not null,
	pwd varchar(100) not null,
	email varchar(100) not null,
	birth datetime not null,
	tel varchar(18) not null,
	createDay datetime default now(),
	userLevel varchar(8) default '일반',
	point int default 10000,
	primary key(uidx),
	unique key(mid)
);

select count(*) from user 
	where date_format(createDay,'%Y-%m') in ('2022-11','2022-12','2023-01','2023-02') 
	group by FIND_IN_SET(date_format(createDay,'%Y-%m'),'2022-11,2022-12,2023-01,2023-02')
	order by FIND_IN_SET(date_format(createDay,'%Y-%m'),'2022-11,2022-12,2023-01,2023-02');
	
select count(*) from user 
	where date_format(createDay,'%Y-%m') in ('2023-02','2023-01','2022-12','2022-11','2022-10','2022-09','2022-08','2022-07','2022-06','2022-05') 
	group by FIND_IN_SET(date_format(createDay,'%Y-%m'),'2023-02,2023-01,2022-12,2022-11,2022-10,2022-09,2022-08,2022-07,2022-06,2022-05')
	order by FIND_IN_SET(date_format(createDay,'%Y-%m'),'2023-02,2023-01,2022-12,2022-11,2022-10,2022-09,2022-08,2022-07,2022-06,2022-05');
	
select count(*) from user 
	where date_format(createDay,'%Y-%m') in ('2023-02','2023-01','2022-12','2022-11','2022-10','2022-09','2022-08','2022-07','2022-06','2022-05') 
	group by FIND_IN_SET(date_format(createDay,'%Y-%m'),'2023-02,2023-01,2022-12,2022-11,2022-10,2022-09,2022-08,2022-07,2022-06,2022-05')
	order by FIND_IN_SET(date_format(createDay,'%Y-%m'),'2023-02,2023-01,2022-12,2022-11,2022-10,2022-09,2022-08,2022-07,2022-06,2022-05');

select * from company where date_format(createDayCP,'%Y-%m') > '2023-02';
	
select date_format('2022/12/01','%Y-%m');
SELECT DATE_FORMAT("2021/01/24 12:33:32", "%Y-%m-%d");
select * from user where createDay like '%2022-12%';

select * from user where email = 'saasdfhr@gmail.com';
select * from user where email = 'saasdfhr@gmail.com';

select * from user order by createDay desc;

select * from user order by createDay desc limit 0,20;

select * from user
where userLevel != '관리자' and mid like '%a%' 
order by createDay desc limit 0,5;



ALTER TABLE user ADD COLUMN point int default 10000;

create table company (
	idx int not null auto_increment,
	name varchar(10) not null,
	cpName varchar(50) not null,
	cpAddr varchar(100) not null,
	cpHomePage varchar(30),
	cpIntro text,
	cpExp varchar(100) not null,
	act char(4) default 'off',
	mid varchar(20) not null,
	createDayCP datetime default now(),
	viewCP int not null default 0,
	primary key(idx),
	unique key(cpName),
	FOREIGN KEY(mid) REFERENCES user(mid) 
	ON UPDATE CASCADE
);

create table companyImg (
	idx int not null auto_increment,
	cidx int not null,
	cpImg varchar(100) not null,
	cpIntroImg text,
	imgSize int not null,
	primary key(idx),
	FOREIGN KEY(cidx) REFERENCES company(idx) 
	ON UPDATE CASCADE
);

alter table company add column mid varchar(20) not null;
alter table company add foreign key(mid) REFERENCES user(mid) ON UPDATE CASCADE;
alter table company add column viewCP int not null default 0;

alter table company add column createDayCP datetime default now();

select * from company;

update company set viewCP =  viewCP + 1 where mid = 'epXEqnKZ';

desc company;

select c.cidx,c.cpName,avg(r.rating) as '별점'
		from company c, reply r 
		where r.boardIdx = CONCAT('c',c.cidx) 
		group by c.cidx 
		order by avg(r.rating) desc;

		
select c.*,avg(r.rating) from company c, reply r where r.boardIdx = CONCAT('c',c.cidx) group by c.cidx order by avg(r.rating) desc;
select c.*,avg(r.rating) from company c, reply r where r.boardIdx = CONCAT('c',c.cidx)  group by c.cidx;
select * from company order by viewCP desc;
select * from company order by createDayCP;

select c.*,avg(r.rating) as 'star' from company c, reply r
				 where r.boardIdx = CONCAT('c',c.cidx) and c.cpExp like '%홈 인테리어%'
				 group by c.cidx 
				 order by avg(r.rating) desc limit 0,5;

select *,avg(r.rating) from company c, reply r
				 where r.boardIdx = CONCAT('c',c.cidx) and c.cpExp like '%홈 인테리어%'
				 group by c.cidx 
				 order by avg(r.rating) desc;


select c.cpName,count(r.ridx) from company c,(select * from reply where rating > 0) as r 
where r.boardIdx = CONCAT('c',c.cidx) 
group by c.cpName;
						
-- 조인 연습

SELECT c.*,avg(r.rating) AS rat 
	FROM company c LEFT OUTER JOIN reply r 
    ON CONCAT('c',c.cidx) = r.boardIdx 
    GROUP BY c.cidx 
    ORDER BY rat desc;

SELECT c.*,avg(r.rating) AS rat 
	FROM company c LEFT OUTER JOIN reply r 
    ON CONCAT('c',c.cidx) = r.boardIdx
    GROUP BY c.cidx 
    HAVING rat <= 4.5 AND rat >= 3.5
    ORDER BY rat desc;

				 
select count(*) as 'CPCnt' from company where cpName like '%벤%';

select count(r.ridx) as CPcnt from (select * from reply group by boardidx) as r;

select * from user u, company c where u.mid = c.mid and u.mid = 'JMdFuRdM';

select * from company;
select * from user u, company c where u.mid = c.mid order by createDayCP desc limit 0,5;
select count(*) as cnt from user u, company c where u.mid = c.mid and cpName like '%디%';
select * from user u, company c 
where u.mid = c.mid and cpExp like '%상업 인테리어%' 
order by createDayCP desc;

select * from user u, company c 
where u.mid = c.mid and (cpExp like '%타일시공%' or cpExp like '%도배장판%') 
order by createDayCP desc;


-- 이메일 인증 코드 저장 테이블
create table emailAct(
	idx int not null auto_increment primary key,
	email varchar(100) not null,
	code varchar(20) not null
);





select * from company where cpExp like '%%' order by idx asc;
select * from company where cpExp REGEXP '홈 인테리어|조명 인테리어' order by idx asc;

select * from companyimg where cidx in(27,12,36) ORDER BY FIND_IN_SET(cidx,"27,12,36");

select * from company where (cpName like '%디자인%' or name like '%디자인%' or cpIntro like '%디자인%') and (cpExp REGEXP '인테리어|조명');


select c.idx,r.boardidx,group_concat(r.rating) as starAvg from company c, reply r where r.boardidx in ('c10','c38','c37','c7','c33') and r.boardidx = concat('c',c.idx) group by c.idx ORDER BY FIND_IN_SET(r.boardidx,'c10,c38,c37,c7,c33');
select group_concat(r.rating) as starAvg from reply where boardidx in ('c10','c38','c37','c7','c33') group by boardidx ORDER BY FIND_IN_SET(boardidx,'c10,c38,c37,c7,c33');

select c.*,ifnull(avg(r.rating),0) as starAvg
	from company c left join reply r on concat('c',c.idx) = r.boardidx
	where c.cpExp REGEXP '홈 인테리어|조명 인테리어'
	group by c.idx 
	ORDER BY starAvg asc
	limit 0,9;
	
select c.*,ifnull(avg(r.rating),0) as rating
	from company c left join reply r on concat('c',c.idx) = r.boardidx
	where cpExp REGEXP '홈 인테리어|조명 인테리어'
	group by c.idx 
	ORDER BY rating desc;

select c.*,ifnull(avg(r.rating),0) as rating
	from company c, reply r 
	where concat('c',c.idx) = r.boardidx 
	group by c.idx 
	order by rating desc;

	
select c.*,ifnull(avg(r.rating),0) as starAvg 
			from company c left join reply r on concat('c',c.idx) = r.boardidx
			where cpExp like '%조명%' group by c.idx order by starAvg desc limit 0,9;
	
select c.*,count(r.idx) as cnt
			from company c left join reply r on concat('c',c.idx) = r.boardidx
			where c.cpExp like '%조명%' group by c.idx order by cnt desc limit 0,9;		
			
select c.*,count(r.idx) from company c left join reply r on concat('c',c.idx) = r.boardidx group by c.idx;
			
select c.*, count(r.idx) as cnt from company c left join reply r on concat('c',c.idx) = r.boardidx where cpExp like '%조명%' and act = 'on' group by c.idx order by cnt desc;


drop table user;
drop table company;
drop table emailAct;