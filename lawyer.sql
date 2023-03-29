-- CREATE DATABASE db01;
USE db01;
CREATE TABLE lawyer_status(
id int auto_increment,
bar varchar(255),
name varchar(255),
link varchar(255),
law_firm_name varchar(255),
law_firm_address varchar(255),
law_firm_city varchar(255),
law_firm_zip int,
law_firm_state varchar(255),
phone varchar(255),
email varchar(255),
status varchar(255),
date_admitted date,
status_date date,
judicial_district varchar(255),
board_certified varchar(255),
CONSTRAINT PK_Person PRIMARY KEY (id)
);

select * from lawyer_status;
select count(*);
drop table lawyer_status;