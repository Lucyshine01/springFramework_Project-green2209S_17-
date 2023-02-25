show tables;


create table point (
	idx int not null auto_increment primary key,
	useMid varchar(20) not null,
	usePoint int not null,
	leftPoint int not null,
	useContent text,
	FOREIGN KEY(useMid) REFERENCES user(mid) 
	ON UPDATE CASCADE
)

desc point;



