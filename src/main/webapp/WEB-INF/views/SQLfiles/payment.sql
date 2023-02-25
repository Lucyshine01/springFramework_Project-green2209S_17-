show tables;


create table payment(
	idx int not null auto_increment primary key,
	merchant_uid varchar(20) not null, /* merchant_uid */
	pay_method varchar(10) not null, /* pay_method */
	currency varchar(10), /* currency */
	buyer_name varchar(20), /* buyer_name */
	buyer_email text, /* buyer_email */
	card_name varchar(50), /* crd_name */
	name text, /* name */
	card_number varchar(50), /* card_number */
	paid_amount varchar(20), /* paid_amount */
	pg_tid text, /* pg_tid */
	receipt_url text, /* receipt_url */
	success varchar(10) not null, /* success */
	error_msg text,
	buyDay datetime default now(),
	FOREIGN KEY(buyer_name) REFERENCES user(mid) 
	ON UPDATE CASCADE
)

desc payment;








drop table payment;