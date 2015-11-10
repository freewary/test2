#drop schema a;

#create schema a;
use a;

#drop database tmp;
#drop USER etl_LOAD@localhost;
#drop table a.t_eod_data;
#drop table a.t_rel_exch_security;
#drop table a.t_exch;
#drop table a.t_security_facts_bigint;
#drop table a.t_security_facts_def;
#drop table a.t_securities;
#drop table .a.t_corp;
#drop procedure a.APP_IS_USR_READY;
#drop procedure  a.APP_NEW_USR;
#drop function a.APP_RET_CASH_FOR_TRADING;
#drop procedure a.p_ret_cashacct_k;
#drop function a.f_etc;
#drop table a.t_cash_trans;
#drop table a.t_etc;
#drop table a.t_cash_acct;
#drop table a.t_cash_acct_usr;


CREATE TABLE a.t_cash_acct_usr (
  Usr_ak bigint(20) NOT NULL,
  CashAcct_k bigint(20) NOT NULL,
  PRIMARY KEY (CashAcct_k),
  UNIQUE KEY Usr_ak_UNIQUE (Usr_ak)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE a.t_cash_acct (
  Acct_k bigint(20) NOT NULL AUTO_INCREMENT,
  Nm varchar(50) NOT NULL,
  PRIMARY KEY (Acct_k),
  unique key t_cash_acct_UNIQUE_NM (Nm)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

insert into a.t_cash_acct (Nm) values
	('alphamental_capital')
	,('brokerage_trust')
	,('trade_fees')
	,('short_fees')
	,('dividends');


create table a.t_etc (
	cfg_lbl varchar(50) not null
	,cfg_value float not null
	,primary key (cfg_lbl)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into a.t_etc (cfg_lbl,cfg_value) values 
	('trade_fee', 0.005)
	,('daily_short_fee', 0.0000136986301369863)
	,('short_collateral_pct', 0.5)
	,('initial_acct_value', 100000000)
	,('min_market_cap', 100000000)
	,('min_pct_new_position', 0.01)
	,('max_pct_new_position', 0.1)
	,('max_pct_company', 0.01)
	,('max_pct_volume_allowed', 0.2)
	,('max_leverage_allowed', 2);

delimiter $$
create function a.f_etc (p_cfg_lbl varchar(50))
	returns float
	deterministic
	begin
		declare o_cfg_value float;
		select cfg_value into o_cfg_value from t_etc where cfg_lbl = p_cfg_lbl;
		return (o_cfg_value);
	end $$
delimiter ;

CREATE TABLE a.t_cash_trans (
  TransTmsp datetime NOT NULL,
  User_ak bigint(20) NOT NULL,
  Credit_CashAcct_k bigint(20) NOT NULL,
  Debit_CashAcct_k bigint(20) NOT NULL,
  Amt double NOT NULL,
  PRIMARY KEY (TransTmsp,User_ak,Credit_CashAcct_k),
  KEY fk_t_cash_trans_credit_idx (Credit_CashAcct_k),
  KEY fk_t_cash_trans_debit_idx (Debit_CashAcct_k),
  CONSTRAINT fk_t_cash_trans_credit FOREIGN KEY (Credit_CashAcct_k) REFERENCES t_cash_acct (Acct_k) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_t_cash_trans_debit FOREIGN KEY (Debit_CashAcct_k) REFERENCES t_cash_acct (Acct_k) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DELIMITER $$
CREATE PROCEDURE a.p_ret_cashacct_k(p_Usr_ak bigint, out o_CashAcct_k bigint)
BEGIN
	select max(CashAcct_k) into @CashAcct_k from a.t_cash_acct_usr where Usr_ak = p_Usr_ak;
	if @CashAcct_k is null then begin
		#DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @e = 1;
		start transaction;
			insert into t_cash_acct (Nm) values (concat('User: ',p_Usr_ak));
			insert into a.t_cash_acct_usr(Usr_ak, CashAcct_k) (select p_Usr_ak, Acct_k from t_cash_acct where Nm = concat('User: ',p_Usr_ak));
			insert into t_cash_trans (TransTmsp,User_ak,Credit_CashAcct_k,Debit_CashAcct_k,Amt) (
					select utc_timestamp() as TransTmsp
							,p_Usr_ak as User_ak
							,a.t_cash_acct.Acct_k as Credit_CashAcct_k
							,t2.Acct_k as Debit_CashAcct_k
							,a.t_etc.cfg_value as Amt
					from a.t_cash_acct
						cross join a.t_cash_acct t2
							on t2.nm = 'alphamental_capital'
						cross join a.t_etc
							on a.t_etc.cfg_lbl = 'initial_acct_value'
						where a.t_cash_acct.Nm = concat('User: ',p_Usr_ak)
				);
		#if @e = 1 then rollback;
		#else
			commit;
		#end if;
		end;
	end if;
	select max(CashAcct_k) into o_CashAcct_k from a.t_cash_acct_usr where Usr_ak = p_Usr_ak;
END$$
DELIMITER ;


delimiter $$
create function a.APP_RET_CASH_FOR_TRADING(p_Usr_ak bigint,p_ts datetime)
	returns double
	not deterministic
begin
	select sum(amt) as amt into @amt from (
	select
		sum(t1.amt) as amt
		#into @CashCredits
	from a.t_cash_trans t1
		inner join a.t_cash_acct_usr usr
			on usr.Usr_ak = p_Usr_ak
	where (t1.Credit_CashAcct_k = usr.CashAcct_k
			and p_ts >= t1.TransTmsp)
	union all
	select
		sum(t1.amt) * -1 as amt
		#into @CashCredits
	from a.t_cash_trans t1
		inner join a.t_cash_acct_usr usr
			on usr.Usr_ak = p_Usr_ak
	where (t1.Debit_CashAcct_k = usr.CashAcct_k
			and p_ts >= t1.TransTmsp)
	) u;

	Return @amt;
end$$
delimiter ;

DELIMITER $$
CREATE PROCEDURE a.APP_NEW_USR(p_Usr_ak bigint, out o_trading_cash double)
BEGIN
	call a.p_ret_cashacct_k(p_Usr_ak,@CashAcct_k);
	select a.APP_RET_CASH_FOR_TRADING(p_Usr_ak,utc_timestamp) as trading_cash into o_trading_cash;
END$$
DELIMITER ;

DELIMITER $$
create procedure a.APP_IS_USR_READY(p_Usr_ak bigint,out o_is_ready int)
begin
	select CashAcct_k into o_is_ready from a.t_cash_acct_usr where Usr_ak = p_Usr_ak; 
	select case when o_is_ready is null then 0 else 1 end into o_is_ready;
end$$
DELIMITER ;


create table a.t_corp (
	Corp_k bigint(20) NOT NULL AUTO_INCREMENT,
	Nm varchar(50) not null,
	PRIMARY KEY (Corp_k),
	UNIQUE KEY Usr_uk_corp_nm (Nm)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

Insert into a.t_corp(Nm) values ('Apple Inc')
	,('Microsoft Corp')
	,('Exxon Mobile Corporation')
	,('Johnson & Johnson')
	,('Wells Fargo & Co')
	,('Berkshire Hathaway Inc.')
	,('Google Inc.')
	,('Zillow Group, Inc.');

#Need another table for securities
#for example, zillow is one company with two classes of common shares

create table a.t_securities (
	Security_k bigint(20) not null auto_increment
	,Corp_k bigint(20) not null
	,Desc_ varchar(255) not null
	,primary key (Security_k)
	,UNIQUE KEY Usr_uk_security_composite (Corp_k,Desc_)
	,CONSTRAINT fk_t_rel_corp_security FOREIGN KEY (Corp_k) REFERENCES t_corp(Corp_k) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

Insert into a.t_securities (Corp_k, Desc_)
	values (1,'Common Stock')
			,(2,'Common Stock')
			,(3,'Common Stock')
			,(4,'Common Stock')
			,(5,'Common Stock')
			,(6,'Class A Common Stock')
			,(6,'Class B Common Stock')
			,(7,'Class A Common Stock')
			,(7,'Class B Common Stock')
			,(7,'Class C Common Stock')
			,(8,'Class A Common Stock')
			,(8,'Class B Common Stock')
			,(8,'Class C Common Stock')
	;

create table a.t_security_facts_def(
	SecurityFactDef_k int not null auto_increment
	,Def varchar(50) not null
	,primary key (SecurityFactDef_k)
	,UNIQUE KEY Usr_uk_security_facts_def_bigint (Def)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into a.t_security_facts_def(Def)
	values ('outstanding_count')
			,('float_count')
			,('economic_weight')
			,('voting_weight')
			,('authorized_count')
			,('issued_count')
			,('restricted_count')
			,('treasury_shares_count');

create table a.t_security_facts_bigint(
	Security_k bigint(20) not null AUTO_INCREMENT
	,SecurityFactDef_k int not null
	,Eff_dt date not null
	,Value_ bigint not null
	,primary key (Security_k,SecurityFactDef_k,eff_dt)
	,CONSTRAINT fk_t_rel_security_facts_def FOREIGN KEY (SecurityFactDef_k) REFERENCES t_security_facts_def(SecurityFactDef_k) ON DELETE NO ACTION ON UPDATE NO ACTION
	,CONSTRAINT fk_t_rel_securities FOREIGN KEY (Security_k) REFERENCES t_securities(Security_k) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


insert into a.t_security_facts_bigint(Security_k, SecurityFactDef_k,Eff_dt,Value_) values
	#apple common shares
	(1,5,'2015-06-07',12600000000) #apple authorized
	,(1,6,'2015-06-07',5705400000) #Apple issued
	,(1,1,'2015-06-07',5866161000) #apple outstanding
	,(1,7,'2015-06-07',103545000) #Apple restricted
#microsoft common shares
	,(2,5,'2015-03-31',24000000000) #microsoft authorized
	,(2,6,'2015-03-31',8239000000) #microsoft issued
	,(2,1,'2015-03-31',8027000000) #microsoft outstanding
	#,(2,6,'2015-03-31',) #microsoft restricted
#exxon common shares
	,(3,5,'2015-06-30',9000000000) #exxon authorized
	,(3,6,'2015-06-30',8019000000) #exxon issued
	,(3,7,'2015-06-30',3850000000) #exxon treasury
#	,(3,6,'2015-06-30',) #exxon restricted
#Johnson & Johnson
	,(4,5,'2015-06-28',4320000000) #jnj authorized
	,(4,6,'2015-06-28',3119843000) #jnj issued
	,(4,7,'2015-06-28',350868000) #jnj treasury
#	,(3,6,'2015-06-30',) #jnj restricted
#Wells Fargo & co
	,(5,5,'2015-06-30',9000000000) #wfc authorized
	,(5,6,'2015-06-30',5481811474) #wfc issued
	,(5,7,'2015-06-30',336576217) #wfc treasury
#	,(3,6,'2015-06-30',) #wfc restricted
#brk/a
	,(6,5,'2015-06-30',1650000) #brk/a authorized
	,(6,6,'2015-06-30',823538) #brk/a issued
	,(6,7,'2015-06-30',11680) #brk/a treasury
	,(6,1,'2015-06-30',811858) #brk/a outstanding
#	,(3,6,'2015-06-30',) #brk/a restricted
#brk/b
	,(7,5,'2015-06-30',3225000000) #brk/b authorized
	,(7,6,'2015-06-30',1248407317) #brk/b issued
	,(7,7,'2015-06-30',1409762) #brk/b treasury
	,(7,1,'2015-06-30',1246997555) #brk/b outstanding
#	,(3,6,'2015-06-30',) #brk/b restricted
#google A
	,(8,5,'2015-06-30',9000000000) #google a authorized
	,(8,6,'2015-06-30',286560000) #google a issued
	#,(8,7,'2015-06-30',) #google a treasury
	,(8,1,'2015-06-30',289384000) #google a outstanding
#google B
	,(9,5,'2015-06-30',3000000000) #google b authorized
	,(9,6,'2015-06-30',53213000) #google b issued
	#,(9,7,'2015-06-30',) #google b treasury
	,(9,1,'2015-06-30',51748000) #google b outstanding
#google c
	,(10,5,'2015-06-30',3000000000) #google c authorized
	,(10,6,'2015-06-30',340399000) #google c issued
	#,(10,7,'2015-06-30',) #google c treasury
	,(10,1,'2015-06-30',340399000) #google c outstanding
#zillow A
	,(11,5,'2015-06-30',1245000000) #zillow a authorized
	,(11,6,'2015-06-30',52738491) #zillow a issued
	#,(11,7,'2015-06-30',) #zillow a treasury
	,(11,1,'2015-06-30',52738491) #zillow a outstanding
#zillow B
	,(12,5,'2015-06-30',15000000) #zillow b authorized
	,(12,6,'2015-06-30',6217447) #zillow b issued
	#,(12,7,'2015-06-30',) #zillow b treasury
	,(12,1,'2015-06-30',6217447) #zillow b outstanding
#zillow c
	,(13,5,'2015-06-30',600000000) #zillow c authorized
	,(13,6,'2015-06-30',58990000) #zillow c issued
	#,(13,7,'2015-06-30',) #zillow c treasury
	,(13,1,'2015-06-30',358990000) #zillow c outstanding

;

create table a.t_exch (
	Exch_k bigint(20) NOT NULL AUTO_INCREMENT,
	Nm varchar(50) not null,
	PRIMARY KEY (Exch_k),
	UNIQUE KEY Usr_uk_exch_nm (Nm)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

Insert into a.t_exch(Nm) values('NYSE')
				,('NASDAQ')
				,('AMEX');

create table a.t_rel_exch_security (
	Exch_k bigint(20) not null
	,Symbol varchar(50) not null
	,Eff_dt date not null
	,Security_k bigint(20) not null
	,PRIMARY KEY (Exch_k,Symbol,Eff_dt) 
	,CONSTRAINT fk_t_rel_exch_security_exch FOREIGN KEY (Exch_k) REFERENCES t_exch(Exch_k) ON DELETE NO ACTION ON UPDATE NO ACTION 
	#as of 2015-10-06 the following constraint is failing and I don't know why, will put it in later.
	#,CONSTRAINT fk_t_rel_exch_security_secu FOREIGN KEY (Security_k) REFERENCES t_Securities(Security_k) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO a.t_rel_exch_security (Exch_k,Symbol,Eff_dt,Security_k)
VALUES (2,'AAPL','2015-01-01',1)
		,(2,'MSFT','2015-01-01',2)
		,(1,'XOM','2015-01-01',3)
		,(1,'JNJ','2015-01-01',4)
		,(1,'WFC','2015-01-01',5)
		,(1,'BRK.A','2015-01-01',6)
		,(1,'BRK.B','2015-01-01',7)
		,(2,'GOOG','2015-01-01',10)
		,(2,'GOOGL','2015-01-01',8)
		,(2,'Z','2015-01-01',11)
		,(2,'Z','2015-08-17',13)
		,(2,'ZCVVV','2015-07-31',13)
		,(2,'ZG','2015-08-17',11);

#future- need to add ability to delist securities from exchanges

create table a.t_provider(
	Provider_k bigint(20) NOT NULL AUTO_INCREMENT,
	Nm varchar(50) not null,
	PRIMARY KEY (Provider_k),
	UNIQUE KEY Usr_uk_provider_nm (Nm)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

Insert into a.t_provider(Nm) values('NASDAQ')
				,('Yahoo')
				,('xignite');


create table a.t_rel_provider_exch_security (
	Exch_k bigint(20) not null
	,Provider_k bigint(20) not null
	,Exch_Symbol varchar(50) not null
	,Provider_Symbol varchar(50) not null
	,Eff_dt date not null
	,PRIMARY KEY (Exch_k,Provider_k,Exch_Symbol,Eff_dt) 
	,CONSTRAINT fk_t_rel_exch_security_exch_symbol FOREIGN KEY (Exch_k) REFERENCES t_exch(Exch_k) ON DELETE NO ACTION ON UPDATE NO ACTION 
	#as of 2015-10-06 the following constraint is failing and I don't know why, will put it in later.
	#,CONSTRAINT fk_t_rel_exch_security_secu FOREIGN KEY (Security_k) REFERENCES t_Securities(Security_k) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into a.t_rel_provider_exch_security (Exch_k,Provider_k,Exch_Symbol,Provider_Symbol, Eff_dt) 
	values (1,2,'BRK.A','BRK-A','2015-01-01')
			,(1,2,'BRK.B','BRK-B','2015-01-01');


create view a.v_rel_exch_security_cur as
select 
	Exch_k
	,Security_k
	,max(eff_dt) as eff_dt
from a.t_rel_exch_security
group by Exch_k, Security_k;

create view a.v_rel_provider_exch_security_cur as
select 
	Exch_k
	,Provider_k
	,Exch_Symbol
	,max(eff_dt) as eff_dt
from a.t_rel_provider_exch_security
group by Exch_k,Provider_k,Exch_Symbol;

create view a.APP_v_symbols as
Select
	res.Exch_k
	,e.Nm as Exchange
	,res.Symbol
	,coalesce(cs.Provider_Symbol,res.Symbol) as Yahoo_Symbol
	,res.Security_k
	,concat(c.Nm,'; ',s.Desc_) as Desc_
from a.t_rel_exch_security res
	inner join a.v_rel_exch_security_cur d
		on d.Exch_k = res.Exch_k
			and d.Security_k = res.Security_k
			and d.Eff_dt = res.Eff_dt
	inner join a.t_exch e
		on e.Exch_k = res.Exch_k
	inner join a.t_securities s
		on s.Security_k = res.Security_k
	inner join a.t_corp c
		on c.Corp_k = s.Corp_k
	left outer join a.t_rel_provider_exch_security cs
		on cs.Exch_k = res.Exch_k
			and cs.Exch_symbol = res.Symbol
		left outer join a.v_rel_provider_exch_security_cur cscur
			on cscur.Provider_k = 2
				and cscur.Provider_k = cs.Provider_k
				and cscur.Exch_k = cs.Exch_k
				and cscur.Exch_Symbol = cs.Exch_Symbol
;

create table a.t_eod_data(
	Dt date not null
	,Security_k bigint(20) not null
	,Closing_Price float not null
	,Volume bigint(20) not null
	,PRIMARY KEY (Dt,Security_k) 
	,CONSTRAINT fk_t_eod_data_t_securities FOREIGN KEY (Security_k) REFERENCES t_securities(Security_k) ON DELETE NO ACTION ON UPDATE NO ACTION 
	)ENGINE=InnoDB DEFAULT CHARSET=latin1
;

#create a user to execute etl process that loads end of day data
CREATE USER etl_LOAD@localhost IDENTIFIED BY 'm@ry6had6A6l!ttle6mamm()th';
create database tmp;
grant select on a.APP_v_symbols to etl_LOAD@localhost;
grant insert, select on a.t_eod_data to etl_LOAD@localhost;
#The manual claims that if a user has rights to create a temporary table
#that no further privilege checks are done on that table, but it seems that
#privilege checks are still done on the schema. I only want the etl_LOAD
#user to have very limited rights on our main schema, this is why
# I created the tmp schema and grandted more privileges there
#otherwise it would not be able to execute the load into command.
grant create temporary tables on tmp.* to etl_LOAD@localhost;
grant insert, select on tmp.* to etl_LOAD@localhost;
grant file on *.* to etl_LOAD@localhost;
#note also need to define secure_file_priv and limit file ops to that directory
#needs to be outside mysql folder, and also need to update apparmor profile

create table a.t_order_type (
	OrderType_k tinyint,
	Order_Type varchar(50) not null,
	PRIMARY KEY (OrderType_k),
	UNIQUE KEY Usr_uk_Order_Type (Order_Type)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

Create table a.t_orders(
	Order_k bigint(20) not null
	,Submit_tmsp datetime not null
	,User_ak bigint(20) NOT NULL
	,Security_k bigint(20) not null
	,OrderType_k tinyint not null
	,Qty_Limit bigint(20) not null
	,Price_Limit bigint(20) not null
	,Accepted_ind boolean not null
	,primary key (Order_k,Submit_tmsp,User_ak,Security_k)
	
	)ENGINE=InnoDB DEFAULT CHARSET=latin1;




CREATE TABLE a.t_positions_entered (
  TransTmsp datetime NOT NULL,
  User_ak bigint(20) NOT NULL,
  Security_k bigint(20) not null,



  Credit_CashAcct_k bigint(20) NOT NULL,
  Debit_CashAcct_k bigint(20) NOT NULL,
  Amt double NOT NULL,
  PRIMARY KEY (TransTmsp,User_ak,Credit_CashAcct_k),
  KEY fk_t_cash_trans_credit_idx (Credit_CashAcct_k),
  KEY fk_t_cash_trans_debit_idx (Debit_CashAcct_k),
  CONSTRAINT fk_t_cash_trans_credit FOREIGN KEY (Credit_CashAcct_k) REFERENCES t_cash_acct (Acct_k) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_t_cash_trans_debit FOREIGN KEY (Debit_CashAcct_k) REFERENCES t_cash_acct (Acct_k) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

