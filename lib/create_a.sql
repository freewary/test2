#drop schema a;

#create schema a;
use a;
#drop view a.APP_V_ORDER_STATUS;
#drop view a.v_order_status;	
#drop procedure a.APP_CANCEL_ORDER;
#drop table a.t_orders_closed;
# drop procedure a.APP_IS_ORDER_VALID;
# drop procedure a.p_check_ordertype_netposition;
# drop procuder a.APP_RET_MAX_STAKE;
# drop function a.APP_RET_MAX_POSITION_SIZE;
# drop function a.APP_RET_MIN_POSITION_SIZE;
# drop function a.APP_RET_PORTFOLIO_VALUE;
# drop function a.APP_RET_MARKET_VALUE;
# drop function a.APP_RET_CASH_FOR_TRADING;
# drop function a.APP_RET_REQUIRED_COLLATERAL;
# drop procedure a.APP_USR_SECURITY_TRADES;
# drop Procedure a.APP_USR_TRADES;
# drop procedure a.APP_USR_SECURITIES;
# drop procedure a.APP_USR_EXECUTIONS;
# drop view a.v_positions;
# drop table a.t_positions_closed;
# drop table a.t_positions_opened;
# drop table a.t_orders;
# drop view a.APP_V_ORDER_TYPES;
# drop table a.t_order_types;
# drop database tmp;
# drop USER etl_LOAD@localhost;
# drop table a.t_eod_data;
# drop function a.APP_RET_SYMBOL;
# drop view a.APP_V_SYMBOLS;
# drop view a.v_rel_exch_security_cur;
# drop view a.v_rel_provider_exch_security_cur;
# drop table a.t_rel_provider_exch_security;
# drop table a.t_provider;
# drop table a.t_rel_exch_security;
# drop table a.t_exch;
# drop table a.t_security_facts_bigint;
# drop table a.t_security_facts_def;
# drop table a.t_securities;
# drop table a.t_corp;
# drop procedure a.APP_IS_USR_READY;
# drop procedure  a.APP_NEW_USR;
# drop function a.APP_RET_CASH;
# drop procedure a.p_ret_cashacct_k;
# drop function a.f_etc;
# drop table a.t_cash_trans;
# drop table a.t_etc;
# drop table a.t_cash_acct;
# drop table a.t_cash_acct_usr;


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
  Usr_ak bigint(20) NOT NULL,
  Credit_CashAcct_k bigint(20) NOT NULL,
  Debit_CashAcct_k bigint(20) NOT NULL,
  Amt double NOT NULL,
  PRIMARY KEY (TransTmsp,Usr_ak,Credit_CashAcct_k),
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
			insert into t_cash_trans (TransTmsp,Usr_ak,Credit_CashAcct_k,Debit_CashAcct_k,Amt) (
					select utc_timestamp() as TransTmsp
							,p_Usr_ak as Usr_ak
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
create function a.APP_RET_CASH(p_Usr_ak bigint,p_ts datetime)
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

Insert into a.t_corp(Nm) values 
	('Apple Inc')
	,('Microsoft Corp')
	,('Exxon Mobile Corporation')
	,('Johnson & Johnson')
	,('Wells Fargo & Co')
	,('Berkshire Hathaway Inc.')
	,('Google Inc.')
	,('Zillow Group, Inc.')
	,('SPDR 500 ETF Trust')
	;

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
			,(9,'Trust Units')
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
#SPDR SP500 Trust
	,(14,1,'2015-09-30',869182116)
;

create table a.t_exch (
	Exch_k bigint(20) NOT NULL AUTO_INCREMENT,
	Nm varchar(50) not null,
	PRIMARY KEY (Exch_k),
	UNIQUE KEY Usr_uk_exch_nm (Nm)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

Insert into a.t_exch(Nm) values('NYSE')
				,('NASDAQ')
				,('AMEX')
				,('NYSE ARCA');

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
		,(2,'ZG','2015-08-17',11)
		,(4,'SPY','2015-01-01',14);

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

create view a.APP_V_SYMBOLS as
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

DELIMITER $$
CREATE FUNCTION a.APP_RET_SYMBOL(p_Security_k bigint(20)) RETURNS varchar(50)
    DETERMINISTIC
begin
		declare o_symbol varchar(50);
		select Symbol into o_symbol from a.APP_V_SYMBOLS where Security_k = p_Security_k;
		return (o_symbol);
	end$$
DELIMITER ;

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
grant select on a.APP_V_SYMBOLS to etl_LOAD@localhost;
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

CREATE TABLE a.t_order_types (
  OrderType_k tinyint(4) NOT NULL,
  Order_Type varchar(50) NOT NULL,
  Multiplier float not null,
  PRIMARY KEY (OrderType_k),
  UNIQUE KEY Usr_uk_Order_Type (Order_Type)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into a.t_order_types (OrderType_k,Order_Type,Multiplier) values
	(0,'Buy to Open',1)
	,(1,'Buy to Close',1)
	,(2,'Sell to Open',-1)
	,(3,'Sell to Close',-1);

create view a.APP_V_ORDER_TYPES as
select OrderType_k,Order_Type,Multiplier from a.t_order_types;

#no contstraint on userkey because it is an alienkey
Create table a.t_orders(
	Order_k bigint(20) not null auto_increment
	,Submit_tmsp datetime not null
	,Usr_ak bigint(20) NOT NULL
	,Security_k bigint(20) not null
	,OrderType_k tinyint(4) not null
	,Qty_Limit bigint(20) not null
	,Price_Limit double not null
	,primary key (Order_k,Submit_tmsp,Usr_ak,Security_k)
	,CONSTRAINT fk_t_rel_securities2 FOREIGN KEY (Security_k) REFERENCES t_securities(Security_k) ON DELETE NO ACTION ON UPDATE NO ACTION
	,CONSTRAINT fk_t_rel_order_type FOREIGN KEY (OrderType_k) REFERENCES t_order_types(OrderType_k) ON DELETE NO ACTION ON UPDATE NO ACTION
	)ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE a.t_positions_opened (
	TransTmsp datetime NOT NULL
	,Usr_ak bigint(20) NOT NULL
	,Security_k bigint(20) not null
	,Order_k bigint(20) not null
	,Qty bigint(20) not null
	,Price double NOT NULL
	,PRIMARY KEY (TransTmsp,Usr_ak,Security_k)
	,CONSTRAINT fk_securities_positions_opened FOREIGN KEY (Security_k) REFERENCES t_securities(Security_k) ON DELETE NO ACTION ON UPDATE NO ACTION
	,CONSTRAINT fk_t_rel_orders FOREIGN KEY (Order_k) REFERENCES t_orders(Order_k) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table a.t_positions_closed (
	TransTmsp_opened datetime NOT NULL
	,Usr_ak bigint(20) NOT NULL
	,Security_k bigint(20) not null
	,TransTmsp_closed datetime NOT NULL
	,Order_k bigint(20) not null
	,Qty bigint(20) not null
	,Price double NOT NULL
	,PRIMARY KEY (TransTmsp_opened,Usr_ak,Security_k,TransTmsp_closed)
	,CONSTRAINT fk_t_rel_securities4 FOREIGN KEY (Security_k) REFERENCES t_securities(Security_k) ON DELETE NO ACTION ON UPDATE NO ACTION
	,constraint fk_orders_positions foreign key (Order_k) references t_orders(Order_k) ON DELETE NO ACTION ON UPDATE NO ACTION
	,constraint fk_positions_opened_positions_closed 
		foreign key (TransTmsp_opened,Usr_ak,Security_k)
		references t_positions_opened(TransTmsp,Usr_ak,Security_k) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

create view a.v_positions as
SELECT 
	o.TransTmsp
    ,o.Usr_ak
    ,o.Security_k
    ,max(o.Qty) as Qty_Opened
    ,max(o.Price) as Price_Opened
	,coalesce(sum(c.Qty),0) as Qty_Closed
	,max(o.Qty) + coalesce(sum(c.Qty),0) as Qty_Open
	,sum(c.Qty * c.Price) / sum(c.Qty) as Price_Closed_Avg
FROM a.t_positions_opened o
	left outer join a.t_positions_closed c
		on c.TransTmsp_opened = o.TransTmsp
			and c.Usr_ak = o.Usr_ak
			and c.Security_k = o.Security_k
group by o.TransTmsp
    ,o.Usr_ak
    ,o.Security_k;

DELIMITER $$
CREATE PROCEDURE a.APP_USR_EXECUTIONS(p_Usr_ak bigint)
begin
	SELECT p.*,d.Closing_Price
		,d.Closing_Price * p.Qty_Open as Notional_Value
			,if(p.Qty_Open < 0
				,(p.Price_Opened - coalesce(p.Price_Closed_Avg,0)) * p.Qty_Closed
				,(p.Price_Opened - coalesce(p.Price_Closed_Avg,0)) * p.Qty_Closed) as Realized_PL
		,if(p.Qty_Open < 0
				,(d.Closing_Price - p.Price_Opened) * p.Qty_Open
				,(d.Closing_Price - Price_Opened) * p.Qty_Open) as Unrealized_PL
		,if (p.Qty_Open < 0
				,p.Qty_Open * d.Closing_Price * cfg_value 
				,0) as Required_Collateral
			,s.Symbol
	FROM a.v_positions p
		left outer join (
			select e.Security_k
			,e.Closing_Price
			from a.t_eod_data e
				inner join (
						select Security_k, max(Dt) as Dt
						from a.t_eod_data
						group by Security_k
					) m 
					on m.Dt = e.Dt
						and m.Security_k = e.Security_k
			) d
		on d.Security_k = p.Security_k
		left outer join a.t_etc 
			on cfg_lbl = 'short_collateral_pct'
		left outer join a.APP_V_SYMBOLS s
			on s.Security_k = p.Security_k
	where p.Usr_ak = p_Usr_ak
	;
End$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE a.APP_USR_SECURITIES(p_Usr_ak bigint(20))
begin
	create temporary table if not exists usrexecutions as (
	SELECT p.*,d.Closing_Price
		,d.Closing_Price * p.Qty_Open as Notional_Value
			,if(p.Qty_Open < 0
				,(p.Price_Opened - coalesce(p.Price_Closed_Avg,0)) * p.Qty_Closed
				,(p.Price_Opened - coalesce(p.Price_Closed_Avg,0)) * p.Qty_Closed) as Realized_PL
		,if(p.Qty_Open < 0
				,(d.Closing_Price - p.Price_Opened) * p.Qty_Open
				,(d.Closing_Price - Price_Opened) * p.Qty_Open) as Unrealized_PL
		,if (p.Qty_Open < 0
				,(d.Closing_Price - p.Price_Opened) * p.Qty_Open
				,d.Closing_Price * p.Qty_Open) as Market_Value
		,if (p.Qty_Open < 0
				,p.Qty_Open * d.Closing_Price * cfg_value 
				,0) as Required_Collateral
			,s.Symbol
	FROM a.v_positions p
		left outer join (
			select e.Security_k
			,e.Closing_Price
			from a.t_eod_data e
				inner join (
						select Security_k, max(Dt) as Dt
						from a.t_eod_data
						group by Security_k
					) m 
					on m.Dt = e.Dt
						and m.Security_k = e.Security_k
			) d
		on d.Security_k = p.Security_k
		left outer join a.t_etc 
			on cfg_lbl = 'short_collateral_pct'
		left outer join a.APP_V_SYMBOLS s
			on s.Security_k = p.Security_k
	where p.Usr_ak = p_Usr_ak
	);
	select 
		Usr_ak
		,Security_k
		,sum(Qty_Opened) as Qty_Opened
		,sum((Qty_Opened * Price_Opened)) / sum(Qty_Opened) as Price_Opened_Avg
		,sum(Qty_Closed) as Qty_Closed 
		,sum(Qty_Open) as Qty_Open
		,sum((Qty_Closed * Price_Closed_Avg)) / sum(Qty_Closed) as Price_Closed_Avg
		,Closing_Price
		,sum(Notional_Value) as Notional_Value
		,sum(Realized_PL) as Realized_PL
		,sum(Unrealized_PL) as Unrealized_PL
		,sum(Market_Value) as Market_Value
		,sum(Required_Collateral) as Required_Collateral
		,Symbol
		from usrexecutions
		group by Usr_ak,Security_k,Closing_Price,Symbol;
End$$
DELIMITER ;

DELIMITER $$
Create Procedure a.APP_USR_TRADES(p_Usr_ak bigint(20),p_MinDate datetime, p_MaxDate datetime)
begin
Select
	TransTmsp
	,Usr_ak
	,u.Security_k
	,s.Symbol
	,Order_k
	,OrderType_k
	,Order_Type
	,Qty
	,Price
	from (
		SELECT po.TransTmsp
			,po.Usr_ak
			,po.Security_k
			,po.Order_k
			,o.OrderType_k
			,ot.Order_Type
			,po.Qty
			,po.Price
		 FROM a.t_positions_opened po
			inner join a.t_orders o
				on o.Order_k = po.Order_k
			inner join a.t_order_types ot
				on ot.OrderType_k = o.OrderType_k
			where po.TransTmsp >= p_MinDate
				and po.TransTmsp <= p_MaxDate
				and po.Usr_ak = p_Usr_ak
		union all
		SELECT pc.TransTmsp_closed
			,pc.Usr_ak
			,pc.Security_k
			,pc.Order_k
			,o.OrderType_k
			,ot.Order_Type
			,pc.Qty
			,pc.Price
		FROM a.t_positions_closed pc
			inner join a.t_orders o
				on o.Order_k = pc.Order_k
			inner join a.t_order_types ot
				on ot.OrderType_k = o.OrderType_k
			where pc.TransTmsp_Closed >= p_MinDate
				and pc.TransTmsp_Closed <= p_MaxDate
				and pc.Usr_ak = p_Usr_ak
	) u
	inner join a.APP_V_SYMBOLS s
		on s.Security_k = u.Security_k
	order by TransTmsp;
end$$
DELIMITER ;

DELIMITER $$
Create Procedure a.APP_USR_SECURITY_TRADES(p_Usr_ak bigint(20),p_Security_k bigint(20),p_MinDate datetime, p_MaxDate datetime)
begin
Select
	TransTmsp
	,Usr_ak
	,u.Security_k
	,s.Symbol
	,Order_k
	,OrderType_k
	,Order_Type
	,Qty
	,Price
	from (
		SELECT po.TransTmsp
			,po.Usr_ak
			,po.Security_k
			,po.Order_k
			,o.OrderType_k
			,ot.Order_Type
			,po.Qty
			,po.Price
		 FROM a.t_positions_opened po
			inner join a.t_orders o
				on o.Order_k = po.Order_k
			inner join a.t_order_types ot
				on ot.OrderType_k = o.OrderType_k
			where po.TransTmsp >= p_MinDate
				and po.TransTmsp <= p_MaxDate
				and po.Usr_ak = p_Usr_ak
				and po.Security_k = p_Security_k
		union all
		SELECT pc.TransTmsp_closed
			,pc.Usr_ak
			,pc.Security_k
			,pc.Order_k
			,o.OrderType_k
			,ot.Order_Type
			,pc.Qty
			,pc.Price
		FROM a.t_positions_closed pc
			inner join a.t_orders o
				on o.Order_k = pc.Order_k
			inner join a.t_order_types ot
				on ot.OrderType_k = o.OrderType_k
			where pc.TransTmsp_Closed >= p_MinDate
				and pc.TransTmsp_Closed <= p_MaxDate
				and pc.Usr_ak = p_Usr_ak
				and pc.Security_k = p_Security_k
	) u
	inner join a.APP_V_SYMBOLS s
		on s.Security_k = u.Security_k
	order by TransTmsp;
end$$
DELIMITER ;

DELIMITER $$
Create Procedure a.APP_USR_SECURITY_TRADES2(p_Usr_ak bigint(20),p_Security_k bigint(20))
begin
Select
	TransTmsp
	,Usr_ak
	,u.Security_k
	,s.Symbol
	,Order_k
	,OrderType_k
	,Order_Type
	,Qty
	,Price
	from (
		SELECT po.TransTmsp
			,po.Usr_ak
			,po.Security_k
			,po.Order_k
			,o.OrderType_k
			,ot.Order_Type
			,po.Qty
			,po.Price
		 FROM a.t_positions_opened po
			inner join a.t_orders o
				on o.Order_k = po.Order_k
			inner join a.t_order_types ot
				on ot.OrderType_k = o.OrderType_k
			where po.Usr_ak = p_Usr_ak
				and po.Security_k = p_Security_k
		union all
		SELECT pc.TransTmsp_closed
			,pc.Usr_ak
			,pc.Security_k
			,pc.Order_k
			,o.OrderType_k
			,ot.Order_Type
			,pc.Qty
			,pc.Price
		FROM a.t_positions_closed pc
			inner join a.t_orders o
				on o.Order_k = pc.Order_k
			inner join a.t_order_types ot
				on ot.OrderType_k = o.OrderType_k
			where pc.Usr_ak = p_Usr_ak
				and pc.Security_k = p_Security_k
	) u
	inner join a.APP_V_SYMBOLS s
		on s.Security_k = u.Security_k
	order by TransTmsp;
end$$
DELIMITER ;

delimiter $$
create function a.APP_RET_REQUIRED_COLLATERAL(p_Usr_ak bigint(20))
	returns double
	not deterministic
begin
		SELECT sum(if (p.Qty_Open < 0
				,p.Qty_Open * d.Closing_Price * cfg_value 
				,0)) into @amt
			FROM a.v_positions p
				left outer join (
					select e.Security_k
					,e.Closing_Price
					from a.t_eod_data e
						inner join (
								select Security_k, max(Dt) as Dt
								from a.t_eod_data
								group by Security_k
							) m 
							on m.Dt = e.Dt
								and m.Security_k = e.Security_k
					) d
				on d.Security_k = p.Security_k
				left outer join a.t_etc 
					on cfg_lbl = 'short_collateral_pct'
				left outer join a.APP_V_SYMBOLS s
					on s.Security_k = p.Security_k
			where p.Usr_ak = p_Usr_ak;
	Return @amt;
end$$
delimiter ;

delimiter $$
create function a.APP_RET_CASH_FOR_TRADING(p_Usr_ak bigint(20),p_ts datetime)
	returns double
	not deterministic
begin
	select a.APP_RET_CASH(p_Usr_ak,utc_timestamp) +
		(select a.APP_RET_REQUIRED_COLLATERAL(p_Usr_ak)) into @amt;
	Return @amt;
end$$
delimiter ;

delimiter $$
create function a.APP_RET_MARKET_VALUE(p_Usr_ak bigint(20))
	returns double
	not deterministic
begin
SELECT 
	sum(if(p.Qty_Open < 0
		,(d.Closing_Price - p.Price_Opened) * p.Qty_Open
		,d.Closing_Price * p.Qty_Open)) into @amt 
	FROM a.v_positions p
		left outer join (
			select e.Security_k
			,e.Closing_Price
			from a.t_eod_data e
				inner join (
						select Security_k, max(Dt) as Dt
						from a.t_eod_data
						group by Security_k
					) m 
					on m.Dt = e.Dt
						and m.Security_k = e.Security_k
			) d
		on d.Security_k = p.Security_k
		left outer join a.t_etc 
			on cfg_lbl = 'short_collateral_pct'
		left outer join a.APP_V_SYMBOLS s
			on s.Security_k = p.Security_k
	where p.Usr_ak = p_Usr_ak
	;
	Return @amt;
end$$
delimiter ;

delimiter $$
create function a.APP_RET_PORTFOLIO_VALUE(p_Usr_ak bigint(20))
	returns double
	not deterministic
begin
	select a.APP_RET_CASH(p_Usr_ak,utc_timestamp) +
		(select a.APP_RET_MARKET_VALUE(p_Usr_ak)) into @amt;
	Return @amt;
end$$
delimiter ;

delimiter $$
create function a.APP_RET_MIN_POSITION_SIZE(p_Usr_ak bigint(20))
	returns double
	not deterministic
begin
	select a.APP_RET_PORTFOLIO_VALUE(p_Usr_ak) * f_etc('min_pct_new_position') into @amt;
	return @amt;
end$$
delimiter ;

delimiter $$
create function a.APP_RET_MAX_POSITION_SIZE(p_Usr_ak bigint(20))
	returns double
	not deterministic
begin
	select a.APP_RET_PORTFOLIO_VALUE(p_Usr_ak) * f_etc('max_pct_new_position') into @amt;
	return @amt;
end$$
delimiter ;

delimiter $$
create function a.APP_RET_MAX_STAKE(p_Security_k bigint(20))
	returns double
	not deterministic
begin
	select a.APP_RET_PORTFOLIO_VALUE(p_Usr_ak) * f_etc('max_pct_stake') into @amt;
	return @amt;
end$$
delimiter ;

create table a.t_messages (
		Message_k
	)

drop procedure a.p_check_ordertype_netposition;
DELIMITER $$
#ot = ordertype
#netpos = net position
create procedure a.p_check_ordertype_netposition(p_OrderType_k tinyint(4)
												,p_net_position bigint(20)
												,out o_ot_netpos_check bit(1)
												,out o_ot_netpos_msg varchar(4000)
												)
begin
set o_ot_netpos_msg = '';
case p_OrderType_k
		when 0 then
			#buy to open- must not have a short position, net position must be >= 0
			if p_net_position >= 0 then set o_ot_netpos_check = 1;
			else set o_ot_netpos_check = 0;
				set o_ot_netpos_msg = '1004:Buy to open order type is incompatible with portfolio short position in this security.';
			end if;
		when 1 then
			#buy to close, must have a short position, net position must be < 0
			if p_net_position < 0 then set o_ot_netpos_check = 1;
			else set o_ot_netpos_check = 0;
				set o_ot_netpos_msg = '1005:Buy to close order type does not apply due to portfolio is not short this security.';
			end if;
		when 2 then
			#sell to open, must not have a long position, net position must be <= 0
			if p_net_position <= 0 then set o_ot_netpos_check = 1;
			else set o_ot_netpos_check = 0;
				set o_ot_netpos_msg = '1006:Sell to open order type is incompatible with portfolio long position in this security.';
			end if;
		when 3 then
			#sell to close, must have a long position, net position must be > 0
			if p_net_position > 0 then set o_ot_netpos_check = 1;
			else set o_ot_netpos_check = -1;
				set o_ot_netpos_msg = '1007:Sell to close order type does not apply due to portfolio is not long this security.';
			end if;
	end case;
end$$
delimiter ;

drop procedure a.p_check_ordersize;
delimiter $$
create procedure a.p_check_ordersize(p_Usr_ak bigint(20)
												,p_net_position bigint(20)
												,p_Price_Limit float
												,p_Signed_Order_Qty bigint(20)
												,out o_ordersize_check bit(1)
												,out o_ordersize_msg varchar(4000)
												)
begin
select abs(p_Price_Limit * ( p_net_position + p_Signed_Order_Qty)) into @Resulting_Position;
select a.APP_RET_MIN_POSITION_SIZE(p_Usr_ak) into @MinPosSize;
select a.APP_RET_MAX_POSITION_SIZE(p_Usr_ak) into @MaxPosSize;
#Always use the limit to calculate market cap
	if @Resulting_Position < @MinPosSize  then
		set o_ordersize_check = 0;
		set o_ordersize_msg = '1002:If executed at limit price, this order would result in a smaller than allowable position size.';
	elseif @Resulting_Position > @MaxPosSize then
		set o_ordersize_check = 0;
		set o_ordersize_msg = '1003:If executed at limit price, this order would result in a larger than allowable position size.';
	else
		set o_ordersize_check = 1;
		set o_ordersize_msg = '';
	end if;
	#select o_ordersize_check, o_ordersize_msg;
end$$
delimiter ; 

delimiter $$
create procedure a.p_check_cash(p_Usr_ak bigint(20)
									,p_OrderType_k tinyint(4)
									,p_Price float
									,p_Signed_Order_Qty bigint(20)
									,out o_Sufficient_Cash bit
									,out o_Msg varchar(255)
								)
begin
declare vTradingCash float;
select a.APP_RET_CASH_FOR_TRADING(p_Usr_ak,utc_timestamp) into vTradingCash;
case p_OrderType_k
		when 0 then
			if o_Sufficient_Cash >= p_Signed_Order_Qty * p_Price then
				set o_Sufficient_Cash = 1;
				set o_Msg = '';
			else
				set o_Sufficient_Cash = 0;
				set o_Msg = '1010:Insufficient Funds to execute order or trade.';
			end if;
		when 1 then
		when 2 then
		when 3 then
			#do nothing because the user is selling owned securities
end case;
select a.APP_RET_CASH_FOR_TRADING(p_Usr_ak,utc_timestamp);
select 1 into o_Sufficient_Cash;
end$$
delimiter ;

#Order validation requires user inputs of:
#User, securitykey, price quote, order type, share qty, price limit
#and needs the follwing from the database
#share counts for the symbol, current position, 
drop procedure a.APP_IS_ORDER_VALID;
DELIMITER $$
create procedure a.APP_IS_ORDER_VALID(p_Usr_ak bigint
										,p_Security_k bigint(20)
										,p_Market_Price float
										,p_OrderType_k tinyint(4)
										,p_Order_Qty bigint(20)
										,p_Price_Limit float
										,p_Save_Order bit(1)
										,out o_is_valid bit(1)
										,out o_msg varchar(65535)
										,out o_Order_k bigint(20)
										)
APP_IS_ORDER_VALID_label:begin
	declare p_msg varchar(5000) default '';
	declare p_ot_check int;
	declare p_qty_check int;
	#returns o_is_valid = 1 if order is accepted, 0 if not accepted
	#If order is not accepted, needs to return a message of ALL reasons why
	#User has established an account?
	CALL a.APP_IS_USR_READY(p_Usr_ak, @o_is_usr_ready);
	if @o_is_usr_ready = 0 then
			select 0,'1001:User account must be configured prior to placing order.' into o_is_valid,o_msg;
			leave APP_IS_ORDER_VALID_label;
			#return 0, 'User account must be configured prior to placing order.'
		end if;
	if p_Order_Qty < 0 then
			select 0,'1009:Order Qty (or Execution count) must be a number > 0. Designate order direction by the type of order' into o_is_valid,o_msg;
			leave APP_IS_ORDER_VALID_label;
		end if;
	#for the prototype, orders will be instant only, no leaving market orders open in the prototype
	#in order for orders to be instant, when buying limit must be higher than market price
	#and when selling, limit must be lower than market price.
	#Need to force the user to submit only positive order quantities, use the order type key to modify the sign

	#Does the user have sufficient cash to executed this trade? 
	select (p_Order_Qty * p_Price_Limit) <= a.APP_RET_CASH_FOR_TRADING(1001,utc_timestamp) into @check_cash;
	if @check_cash = 0 then
		select '1010:Insufficient Funds to execute order or trade.' into @cash_msg;
	else
		set @cash_msg = '';
	end if;

	#get the user's net position in this security
	select coalesce(sum(Qty_Open),0) into 	@p_net_position from a.v_positions
	where a.v_positions.Usr_ak = p_Usr_ak and a.v_positions.Security_k = p_Security_k;
	#Is user's existing position is compatible with order type?
	call a.p_check_ordertype_netposition(p_OrderType_k,@p_net_position,@o_ot_netpos_check,@o_ot_netpos_msg);
	#for buy orders, the limit price must be >= the market price.
	#for sell orders, the limit price must be <= the market price.

	#Set the sign of the order qty, front end is always positive, but database uses - for selling and short positions
	select multiplier * p_Order_Qty into @Signed_Order_Qty 
	from t_order_types
	where OrderType_k = p_OrderType_k;
	#if order is successfully executed, what pct of portfolio will it be?
	# will it fit within the min and max pct_portfolio setting?
	call a.p_check_ordersize(p_Usr_ak
							,@p_net_position
							,p_Price_Limit
							,@Signed_Order_Qty
							,@o_ordersize_check
							,@o_ordersize_msg
							);

	#If selling short, does user have enough cash collateral to initiate the trade?

	#If buying, does user have enough cash to purchase at the limit?

	#Use quote or limit, whichever is lowest, and multiply by outstanding shares,
	#market cap must be >= min_market_capS

	#Is order size smaller than the 20 day moving average?

	#if buying, and limit is lower than quote, reject order with message_text

	#if selling, and limit is higher than quote, reject order with message accessible

	select min(chk) into @o_is_valid
	from (
			select @o_ot_netpos_check as chk
			union all
			select @o_ordersize_check
			union all
			select @check_cash
		) u;

	if (@o_is_valid = 1 and p_Save_Order = 1) then
		INSERT INTO a.t_orders
		(Submit_tmsp,Usr_ak,Security_k,OrderType_k,Qty_Limit,Price_Limit)
		select now(),p_Usr_ak,p_Security_k,p_OrderType_k,@Signed_Order_Qty,p_Price_Limit;
		SELECT LAST_INSERT_ID() into @Order_k;
		set p_msg = '1008:Order Saved.';
		select @o_is_valid,@Order_k,p_msg into o_is_valid,o_Order_k,o_msg;
	else
		select @o_is_valid,NULL,concat_ws('|',@o_ot_netpos_msg,@o_ordersize_msg,@cash_msg) into o_is_valid,o_Order_k,o_msg;
	end if;


end$$
DELIMITER ;

CREATE TABLE a.t_orders_closed (
	TransTmsp datetime NOT NULL
	,Order_k bigint(20) not null
	,primary key (Order_k)
	,CONSTRAINT fk_t_orders_closed_rel_orders FOREIGN KEY (Order_k) REFERENCES t_orders(Order_k) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DELIMITER $$
create procedure a.APP_CANCEL_ORDER(p_Order_k bigint(20),out o_Cancel_tmsp datetime)
begin
	select now() into @Cancel_tmsp;
	insert into a.t_orders_closed (TransTmsp,Order_k)
		values (@Cancel_tmsp,p_Order_k);
	select @Cancel_tmsp into o_Cancel_tmsp;
end$$
DELIMITER ;

drop view a.v_order_status;
create view a.v_order_status as
	SELECT 
	o.Order_k,Submit_tmsp,o.Usr_ak,o.Security_k,OrderType_k,Qty_Limit,Price_Limit
	,coalesce(sum(po.Qty),0) as Qty_filled
	,abs(cast(coalesce(sum(po.Qty),0) as decimal(65,2)) / Qty_Limit) as PCT_Filled
	,Qty_Limit - coalesce(sum(po.Qty),0) as Qty_Unfilled
	,oc.TransTmsp as Cancelled_Tmsp
	 FROM a.t_orders o
		left outer join a.t_positions_opened po
			on po.Order_k = o.Order_k
		left outer join a.t_orders_closed oc
			on oc.Order_k = o.Order_k
	where ordertype_k in (0,2)
	group by o.Order_k,Submit_tmsp,o.Usr_ak,o.Security_k,OrderType_k,Qty_Limit,Price_Limit
		,oc.TransTmsp
	union all
	SELECT 
	o.Order_k,Submit_tmsp,o.Usr_ak,o.Security_k,OrderType_k,Qty_Limit,Price_Limit
	,coalesce(sum(pc.Qty),0) as Qty_filled
	,abs(cast(coalesce(sum(pc.Qty),0) as decimal(65,2)) / Qty_Limit) as PCT_Filled
	,Qty_Limit - coalesce(sum(pc.Qty),0) as Qty_Unfilled
	,oc.TransTmsp as Cancelled_Tmsp
	 FROM a.t_orders o
		left outer join a.t_positions_closed pc
			on pc.Order_k = o.Order_k
		left outer join a.t_orders_closed oc
			on oc.Order_k = o.Order_k
	where ordertype_k in (1,3)
	group by o.Order_k,Submit_tmsp,o.Usr_ak,o.Security_k,OrderType_k,Qty_Limit,Price_Limit
		,oc.TransTmsp
	;

create view a.APP_V_ORDER_STATUS as
	SELECT Order_k
		,Submit_tmsp
		,Usr_ak
		,os.Security_k
		,S.Symbol
		,S.Yahoo_Symbol
		,os.OrderType_k
		,ot.Order_Type
		,Qty_Limit
		,Price_Limit
		,Qty_Filled
		,PCT_Filled
		,Cancelled_Tmsp as Cancelled_TimeStamp
		,if(PCT_Filled < 1 and Cancelled_Tmsp is null,1,0) as Order_Status_Ind
		,case when PCT_Filled = 1 then 'Filled'
			when Cancelled_Tmsp is null then 'Cancelled'
			else 'Open' end as Order_Status_Desc
	FROM a.v_order_status os
		inner join a.APP_V_SYMBOLS S
			on S.Security_k = os.Security_k
		inner join a.t_order_types ot
			on ot.OrderType_k = os.OrderType_k
	;

drop procedure a.APP_SAVE_TRADE;
DELIMITER $$
Create procedure a.APP_SAVE_TRADE(p_Order_k bigint(20)
										,p_Execution_TMSP datetime
 										,p_Execution_Price float
										,p_Execution_Count bigint(20)
										,p_SPY_price float
										,out o_saved int
										,out o_msg varchar(65535)
										)
APP_SAVE_TRADE_label:begin
		DECLARE vTransTmsp_opened datetime;
		DECLARE vQty_open bigint(20);
		DECLARE vCumulativeClosed bigint(20);
		DECLARE vClosedThisStep bigint(20);
		DECLARE vUsr_ak bigint(20);
		DECLARE vSecurity_k bigint(20);
		DECLARE curOpenPos CURSOR FOR 
		select 
			o.TransTmsp AS TransTmsp_opened
			,(max(o.Qty) + coalesce(sum(c.Qty),0)) AS Qty_Open
			 from (a.t_positions_opened o 
				left join a.t_positions_closed c 
					on(((c.TransTmsp_opened = o.TransTmsp) 
						and (c.Usr_ak = o.Usr_ak) 
						and (c.Security_k = o.Security_k)))) 
				where o.Usr_ak = vUsr_ak
					and o.Security_k = vSecurity_k
			group by o.TransTmsp,o.Usr_ak,o.Security_k
			having (max(o.Qty) <> coalesce(sum(c.Qty),0))
			order by o.TransTmsp
			;

	if p_Execution_Count < 0 then
		select 0,'1009:Order Qty (or Execution count) must be a number > 0. Designate order direction by the type of order' into o_saved,o_msg;
		leave APP_SAVE_TRADE_label;
	end if;

	select Usr_ak,Submit_tmsp,Security_k,OrderType_k,Qty_Limit,Price_Limit
		into vUsr_ak,@Submit_Tmsp,vSecurity_k,@OrderType_k,@Qty_Limit,@Price_Limit
	from a.t_orders where Order_k = p_Order_k;

	#proc will execute the minimum of 1) Execution count 2) Unfilled Qty 3) Shares that can be bought with funds available

	select multiplier, multiplier * @Qty_Limit into @Multiplier,@Order_Qty 
	from t_order_types
	where OrderType_k = @OrderType_k;
	
#	select @o_is_valid,@o_msg,@o_Order_k;
-- select @o_is_valid,@o_msg;

	#need to set the sign of order_qty to negative for selling orders
	#if opening, insert into positions_opened
	#else use loop to close by FIFO, inserting into positions closed
	select Order_type like '%Open' into @Open_ind 
	from a.t_order_types
		where a.t_order_types.OrderType_k = @OrderType_k;
	if @Open_ind = 1 then
		#save the position changed
		INSERT INTO a.t_positions_opened
		(TransTmsp,Usr_ak,Security_k,Order_k,Qty,Price)
		select p_Execution_TMSP,vUsr_ak,vSecurity_k,@Order_k,@Order_Qty,p_Execution_Price;
		set @o_saved = 1;
		set @o_msg = 'Trade execution saved';
		#record the cash transaction and fee
		if @OrderType_k = 0 then
			INSERT INTO a.t_cash_trans
				(TransTmsp,
				Usr_ak,
				Credit_CashAcct_k,
				Debit_CashAcct_k,
				Amt)
				VALUES
				(p_Execution_TMSP,
					vUsr_ak,
					12,
				(select CashAcct_k from t_cash_acct_usr where Usr_ak = vUsr_ak),
				@Order_Qty*p_Execution_Price
				)
				,(p_Execution_TMSP,
					vUsr_ak,
					13,
				(select CashAcct_k from t_cash_acct_usr where Usr_ak = vUsr_ak),
				(select cfg_value * @Order_Qty*p_Execution_Price from t_etc where cfg_lbl = 'trade_fee') 
				);
		elseif @OrderType_k = 2 then
			INSERT INTO a.t_cash_trans
				(TransTmsp,
				Usr_ak,
				Credit_CashAcct_k,
				Debit_CashAcct_k,
				Amt)
				VALUES
				(p_Execution_TMSP,
					vUsr_ak,
				(select CashAcct_k from t_cash_acct_usr where Usr_ak = vUsr_ak),
					12,
				abs(@Order_Qty)*p_Execution_Price
				)
				,(p_Execution_TMSP,
					vUsr_ak,
					13,
				(select CashAcct_k from t_cash_acct_usr where Usr_ak = vUsr_ak),
				(select cfg_value * @Order_Qty*p_Execution_Price from t_etc where cfg_lbl = 'trade_fee') 
				);
		end if;

		#save the hedge transaction
	else
		#loop through the position openings, closing the oldest ones first
		set vCumulativeClosed = 0;
		Open curOpenPos;
		ClosePos: LOOP
			FETCH curOpenPos INTO vTransTmsp_opened,vQty_open;
			#First figure out how many are going to be closed this step
			select min(test) into vClosedThisStep from (
				select vQty_open as test
				union all
				select p_Execution_Count - vCumulativeClosed
				) d;
			INSERT INTO a.t_positions_closed
			(TransTmsp_opened,
			Usr_ak,
			Security_k,
			TransTmsp_closed,
			Order_k,
			Qty,
			Price)
			VALUES
			(vTransTmsp_opened,
			vUsr_ak,
			vSecurity_k,
			p_Execution_TMSP,
			p_Order_k,
			vClosedThisStep * @Multiplier,
			p_Execution_Price);
			set vCumulativeClosed = vCumulativeClosed + vClosedThisStep;
			IF p_Execution_Count - vCumulativeClosed = 0 THEN 
				LEAVE ClosePos;
			end if;
		end loop;
		set @o_saved = 1;
	end if;
select @o_saved, @o_msg into o_saved, o_msg;
end$$
DELIMITER ;		

#todo list

#make a flowchart of order creation to saving trade
#figure out why the production server is rejecting orders for all securities except aapl
# for user 1001 with reason of existing short position.