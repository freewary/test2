#Test that getting the User's cash account key will generate a new one if it doesn't exist.
CALL a.p_ret_cashacct_k(1, @tmp);
select @tmp;

select a.APP_RET_CASH_FOR_TRADING(1,utc_timestamp) as trading_cash;
select a.APP_RET_CASH_FOR_TRADING(1,'2018-01-01') as trading_cash;

call a.APP_NEW_USR(99,@trading_cash);
select @trading_cash;

select f_etc('daily_short_fee');

call a.APP_IS_USR_READY(99,@o_is_ready);
select @o_is_ready;

#user 99, security; Apple, quote: $116.85, order type: Buy to open, qty: 9500, limit: 40
call a.APP_IS_ORDER_VALID(99,1,116.85,2,9500,117,@o_is_valid,@o_msg);
select @o_is_valid,@o_msg;



#user 99, buy 100000 shares of AAPL
#first create an order
INSERT INTO a.t_orders
(Submit_tmsp,User_ak,Security_k,OrderType_k,Qty_Limit,Price_Limit,Accepted_ind)
select now(),99,1,0,100000,107.10,1;
INSERT INTO a.t_positions_opened
(TransTmsp,User_ak,Security_k,Order_k,Qty,Price)
select now(),99,1,(select max(order_k) from a.t_orders),100000,107.1;

#Another buy order
INSERT INTO a.t_orders
(Submit_tmsp,User_ak,Security_k,OrderType_k,Qty_Limit,Price_Limit,Accepted_ind)
select now(),99,1,0,75000,107.02,1;
INSERT INTO a.t_positions_opened
(TransTmsp,User_ak,Security_k,Order_k,Qty,Price)
select now(),99,1,(select max(order_k) from a.t_orders),75000,107.02;

#now sell some shares in two orders. First order sells a portion of the first open execution.
INSERT INTO a.t_orders
(Submit_tmsp,User_ak,Security_k,OrderType_k,Qty_Limit,Price_Limit,Accepted_ind)
select now(),99,1,3,60000,106.86,1;
Insert into a.t_positions_closed
(TransTmsp_opened,User_ak,Security_k,TransTmsp_closed,Order_k,Qty,Price)
select '2015-12-28 10:40:11',99,1,now(),(select max(order_k) from a.t_orders),60000,106.86;

#second order sells the rest of the first open execution and a portion of the 2nd execution
INSERT INTO a.t_orders
(Submit_tmsp,User_ak,Security_k,OrderType_k,Qty_Limit,Price_Limit,Accepted_ind)
select now(),99,1,3,20000,106.89,1;
Insert into a.t_positions_closed
(TransTmsp_opened,User_ak,Security_k,TransTmsp_closed,Order_k,Qty,Price)
select '2015-12-28 10:40:11',99,1,now(),(select max(order_k) from a.t_orders),15000,106.89;
Insert into a.t_positions_closed
(TransTmsp_opened,User_ak,Security_k,TransTmsp_closed,Order_k,Qty,Price)
select '2015-12-28 10:43:20',99,1,now(),(select max(order_k) from a.t_orders),5000,106.89;


