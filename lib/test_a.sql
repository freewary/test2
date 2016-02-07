#Test that getting the User's cash account key will generate a new one if it doesn't exist.
CALL a.p_ret_cashacct_k(1, @tmp);
select @tmp;

select a.APP_RET_CASH(1001,utc_timestamp) as trading_cash;
select a.APP_RET_REQUIRED_COLLATERAL(1001) as required_collateral;
select a.APP_RET_CASH_FOR_TRADING(1001,utc_timestamp) as trading_cash;
select a.APP_RET_MARKET_VALUE(1001) as market_value;
select a.APP_RET_PORTFOLIO_VALUE(1001) as portfolio_value;
select a.APP_RET_MIN_POSITION_SIZE(1001) as min_position_size;
select a.APP_RET_MAX_POSITION_SIZE(1001) as max_position_size;

call a.APP_NEW_USR(1001,@trading_cash);
select @trading_cash;

select f_etc('daily_short_fee');

call a.APP_IS_USR_READY(1001,@o_is_ready);
select @o_is_ready;

#test every possible combination of order type and position size
#four order types 0 buy to open, 1 buy to close, 2 sell to open, 3 sell to close
#possible position sizes are negative, 0 or positive
call a.p_check_ordertype_netposition(0,-1,@o_ot_netpos_check,@o_ot_netpos_msg);
select @o_ot_netpos_check,@o_ot_netpos_msg;
call a.p_check_ordertype_netposition(0,0,@o_ot_netpos_check,@o_ot_netpos_msg);
select @o_ot_netpos_check,@o_ot_netpos_msg;
call a.p_check_ordertype_netposition(0,1,@o_ot_netpos_check,@o_ot_netpos_msg);
select @o_ot_netpos_check,@o_ot_netpos_msg;
call a.p_check_ordertype_netposition(1,-1,@o_ot_netpos_check,@o_ot_netpos_msg);
select @o_ot_netpos_check,@o_ot_netpos_msg;
call a.p_check_ordertype_netposition(1,0,@o_ot_netpos_check,@o_ot_netpos_msg);
select @o_ot_netpos_check,@o_ot_netpos_msg;
call a.p_check_ordertype_netposition(1,1,@o_ot_netpos_check,@o_ot_netpos_msg);
select @o_ot_netpos_check,@o_ot_netpos_msg;
call a.p_check_ordertype_netposition(2,-1,@o_ot_netpos_check,@o_ot_netpos_msg);
select @o_ot_netpos_check,@o_ot_netpos_msg;
call a.p_check_ordertype_netposition(2,0,@o_ot_netpos_check,@o_ot_netpos_msg);
select @o_ot_netpos_check,@o_ot_netpos_msg;
call a.p_check_ordertype_netposition(2,1,@o_ot_netpos_check,@o_ot_netpos_msg);
select @o_ot_netpos_check,@o_ot_netpos_msg;
call a.p_check_ordertype_netposition(3,-1,@o_ot_netpos_check,@o_ot_netpos_msg);
select @o_ot_netpos_check,@o_ot_netpos_msg;
call a.p_check_ordertype_netposition(3,0,@o_ot_netpos_check,@o_ot_netpos_msg);
select @o_ot_netpos_check,@o_ot_netpos_msg;
call a.p_check_ordertype_netposition(3,1,@o_ot_netpos_check,@o_ot_netpos_msg);
select @o_ot_netpos_check,@o_ot_netpos_msg;

select sum(Qty_Open) into @p_net_position from a.v_positions
where a.v_positions.Usr_ak = 1001 and a.v_positions.Security_k = 1;
select @p_net_position;
call a.p_check_ordersize(1001
							,@p_net_position
							,99.99
							,-90000
							,@ordersize_check
							,@ordersize_msg
							);
select @ordersize_check,@ordersize_msg;

#has 95000 + 100 = 9,500,000
#user 99, security; Apple, quote: $116.85, order type: Buy to open, qty: 9500, limit: 40
call a.APP_IS_ORDER_VALID(1001,1,99.99,0,10000,95,0,@o_is_valid,@o_msg,@Order_k);
select @o_is_valid,@o_msg,@Order_k;

call a.APP_CANCEL_ORDER(
#set sql_safe_updates = 0;
#delete from a.t_orders;
#delete from a.t_positions_opened;
#delete from a.t_positions_closed;

#user 1001, buy 100000 shares of AAPL
#first create an order
INSERT INTO a.t_orders
(Submit_tmsp,Usr_ak,Security_k,OrderType_k,Qty_Limit,Price_Limit,Accepted_ind)
select '2015-11-06 3:51',1001,1,0,100000,122,1;
INSERT INTO a.t_positions_opened
(TransTmsp,Usr_ak,Security_k,Order_k,Qty,Price)
select '2015-11-06 3:51',1001,1,(select max(order_k) from a.t_orders),100000,121.75;

#Another buy order
INSERT INTO a.t_orders
(Submit_tmsp,Usr_ak,Security_k,OrderType_k,Qty_Limit,Price_Limit,Accepted_ind)
select '2015-11-09 3:54',1001,1,0,75000,107.02,1;
INSERT INTO a.t_positions_opened
(TransTmsp,Usr_ak,Security_k,Order_k,Qty,Price)
select '2015-11-09 3:54',1001,1,(select max(order_k) from a.t_orders),75000,107.02;

#now sell some shares in two orders. First order sells a portion of the first open execution.
INSERT INTO a.t_orders
(Submit_tmsp,Usr_ak,Security_k,OrderType_k,Qty_Limit,Price_Limit,Accepted_ind)
select '2015-12-02 3:51',1001,1,3,60000,115,1;
Insert into a.t_positions_closed
(TransTmsp_opened,Usr_ak,Security_k,TransTmsp_closed,Order_k,Qty,Price)
select '2015-11-06 3:51',1001,1,'2015-12-02 3:51',(select max(order_k) from a.t_orders),-60000,116.23;

#second order sells the rest of the first open execution and a portion of the 2nd execution
INSERT INTO a.t_orders
(Submit_tmsp,Usr_ak,Security_k,OrderType_k,Qty_Limit,Price_Limit,Accepted_ind)
select '2015-12-15 3:57',1001,1,3,20000,110,1;
Insert into a.t_positions_closed
(TransTmsp_opened,Usr_ak,Security_k,TransTmsp_closed,Order_k,Qty,Price)
select '2015-11-06 3:51',1001,1,'2015-12-15 3:57',(select max(order_k) from a.t_orders),-15000,110.41;
Insert into a.t_positions_closed
(TransTmsp_opened,Usr_ak,Security_k,TransTmsp_closed,Order_k,Qty,Price)
select '2015-11-09 3:54',1001,1,'2015-12-15 3:57',(select max(order_k) from a.t_orders),-5000,110.42;

#Example of a profitable short position. For fun we will say that user 99 sold zillow short on Oct 12, 2015
INSERT INTO a.t_orders
(Submit_tmsp,Usr_ak,Security_k,OrderType_k,Qty_Limit,Price_Limit,Accepted_ind)
select '2015-10-12 3:58',1001,13,2,-200000,31,1;
INSERT INTO a.t_positions_opened
(TransTmsp,Usr_ak,Security_k,Order_k,Qty,Price)
select '2015-10-12 3:58',1001,13,(select max(order_k) from a.t_orders),-200000,31.99;

#example of closing part of the zillow position to lock in some profits
INSERT INTO a.t_orders
(Submit_tmsp,Usr_ak,Security_k,OrderType_k,Qty_Limit,Price_Limit,Accepted_ind)
select '2015-11-10 3:58',1001,13,1,130000,25,1;
Insert into a.t_positions_closed
(TransTmsp_opened,Usr_ak,Security_k,TransTmsp_closed,Order_k,Qty,Price)
select '2015-10-12 3:58',1001,13,'2015-11-10 3:59',(select max(order_k) from a.t_orders),130000,24.41;


#example of an unprofitable short position. Shorting GOOG:
INSERT INTO a.t_orders
(Submit_tmsp,Usr_ak,Security_k,OrderType_k,Qty_Limit,Price_Limit,Accepted_ind)
select '2015-10-14 3:58',1001,10,2,-8000,650,1;
INSERT INTO a.t_positions_opened
(TransTmsp,Usr_ak,Security_k,Order_k,Qty,Price)
select '2015-10-14 3:58',1001,10,(select max(order_k) from a.t_orders),-8000,650.22;

#example of selecting symbol info with latest closing price:
SELECT eod.Dt
    ,eod.Security_k
	,s.Yahoo_Symbol as Symbol
	,s.Desc_
	,s.Exch_k
	,s.Exchange
    ,eod.Closing_Price
    ,eod.Volume
FROM a.t_eod_data eod
	inner join (select max(Dt) as Dt, Security_k from a.t_eod_data group by Security_k) m
		on m.Dt = eod.Dt and m.Security_k = eod.Security_k
	inner join a.APP_V_SYMBOLS s
		on s.Security_k = eod.Security_k;

call a.APP_USR_EXECUTIONS(1001);
call a.APP_USR_SECURITIES(1001);
call a.APP_USR_TRADES(1001,'2015-01-01',now());
call a.APP_USR_SECURITY_TRADES(1001,1,'2015-01-01',now());
call a.APP_USR_SECURITY_TRADES2(1001,1);


