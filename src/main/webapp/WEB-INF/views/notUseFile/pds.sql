show tables;

create table pds (
	pIdx int not null auto_increment,
	fOriName varchar(100) not null,
	fSysName varchar(110) not null,
	fSize int not null,
	mid varchar(20) not null,
	inDate datetime default now(),
	primary key(pIdx),
	FOREIGN KEY(mid) REFERENCES user(mid) 
	ON UPDATE CASCADE
);
FOREIGN KEY(mid) REFERENCES user(code) 
	ON UPDATE CASCADE
	
select * from pds;

alter table pds add column inDate datetime default now();

select * from user;
select * from pds order by inDate desc limit 3,3;

delete from pds where fSysName = '124124.jpg';



drop table pds;