show tables;

create table help(
	hidx int not null auto_increment,
	title varchar(50) not null,
	content text not null,
	conf char(5) default 'off',
	answer text,
	mid varchar(20) not null,
	writeDay datetime default now(),
	answerDay datetime default null,
	primary key(hidx),
	FOREIGN KEY(mid) REFERENCES user(mid) 
	ON UPDATE CASCADE
);

select * from help;

alter table help add column writeDay datetime default now();

alter table help add column answerDay datetime default null;