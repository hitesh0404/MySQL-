use classicmodels;
select customernumber,phone from customers;

CREATE
    [DEFINER = user]
    PROCEDURE [IF NOT EXISTS] sp_name ([proc_parameter[,...]])
    [characteristic ...] routine_body

CREATE
    [DEFINER = user]
    FUNCTION [IF NOT EXISTS] sp_name ([func_parameter[,...]])
    RETURNS type
    [characteristic ...] routine_body

proc_parameter:
    [ IN | OUT | INOUT ] param_name type

func_parameter:
    param_name type

type:
    Any valid MySQL data type

characteristic: {
    COMMENT 'string'
  | LANGUAGE SQL
  | [NOT] DETERMINISTIC
  | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
  | SQL SECURITY { DEFINER | INVOKER }
}

routine_body:
    SQL routine


delimiter $

drop function dev$

create function dev(a int,b int)
returns float 
no SQL
begin
declare result int default 0;
select customernumber into result from customers limit 1;
return a/b;
end$

select dev(23,3)$

-- case Statement
-- when then condition
select country ,case 
				when country ="France" 
				then "Europe "
                when country = "USA"
                then"North America"
                end as continent from customers;
                
                
drop function continent;
create function continent (country varchar(40))
returns varchar(20)
reads SQL data
begin
	declare result varchar(20) default "not matched"; 
	select case 
				when country ="France" 
				then "Europe"
                when country = "USA"
                then"North America"
                end into result;
return result;
end$


select country , continent(country) from customers;



use classicmodels;

-- delimiter $

create function find_larger(first_value int, second_value int)
returns int
DETERMINISTIC
begin
       if first_value > second_value
			then
				return first_value;
	   else
			return second_value;
	  end if;
end$


use classicmodels;
-- delimiter $

create function calculate_price(total_weight_in_gram int, price_perkg int)
returns int 
READS SQL DATA
begin
       if  total_weight_in_gram < 1000
			then
				return price_perkg;
	   else
			return (total_weight_in_gram/1000) * price_perkg;
	  end if;
end$

select calculate_price(300,70)$






create procedure countdown(in num int)
begin 
	repeat 
			select num;
            set num = num-1;
            until num>-1
	end repeat;
end $
call countdown(3);


drop procedure if exists countdown;
create procedure countdown(in num int)
begin 
	drop table if exists `count`; 
	create table if not exists `count`(val int);   
    repeat 
		insert into `count` value(num);            
        set num = num-1;            
        until num<0 
	end repeat; 
    select * from  `count` ; 
end $
call countdown(2)$
drop procedure if exists fetchemp$
create procedure fetchemp()
begin 
	declare num int default 0;
    declare mail varchar(30) ;
	declare simple_cur cursor for select employeenumber,email from employees;
    open simple_cur;
    fetch simple_cur into num,mail;
    select num,mail;
    fetch simple_cur into num,mail;
    select num,mail;
    close simple_cur;
end$

-- CRUD  create read  update delete
-- select 

 insert into offices values 
 (10,"Bandra","4343434","25 Old Broad Street",null,null,"india","423401","NA");
 insert into offices(city,officecode)
 values ("Bandra",11);

start transaction;
update offices set city = "dadar";
select * from offices;
rollback;


start transaction;
update offices set city = "dadar" where officecode = 8 ;
select * from offices;
commit;





