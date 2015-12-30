#!/usr/bin/env python
import csv, urllib2, os, mysql.connector, shutil
from urllib import urlencode
from httplib import HTTPConnection
from xml.dom import minidom
import datetime
e_dt = datetime.date.today()
#print e_dt.isoformat()
s_dt = datetime.date.today() - datetime.timedelta(days=32)
#print s_dt.isoformat()
#first get the quote symbols from the mysql database
c = mysql.connector.connect(user="etl_LOAD",password="m@ry6had6A6l!ttle6mamm()th",host="localhost",database="a")
cur = c.cursor()
cur.execute("SELECT Yahoo_Symbol as s FROM a.APP_V_SYMBOLS;")
symbols = ''
for (s) in cur:
	symbols = symbols + ",'" + "{0[0]}".format(s,'::') + "'"
#print(symbols[1:])
#print '(' + symbols[1:] + ')'
#the date range needs to be -6 weeks ago to yesterday, in order to be sure to get a full 20 trading days

yql =  'select Symbol, Date, Close, Volume from yahoo.finance.historicaldata where symbol in (' + symbols[1:] + ') and startDate = "' + s_dt.isoformat() + '" and endDate = "' + e_dt.isoformat() + '"'
#print(yql)
url = 'http://query.yahooapis.com/v1/public/yql' + '?' + urlencode({'q': yql, 'format': 'xml', 'env': 'store://datatables.org/alltableswithkeys' })
#print url
#fetch the date, symbol, closing price and volume from yahoo finance 
conn = HTTPConnection('query.yahooapis.com')
conn.request('GET',str(url))
#write the data to a csv file
qxml =  minidom.parseString(conn.getresponse().read())
quotes = qxml.getElementsByTagName("quote")
out = ''
for quote in quotes:
	out = out + quote.getAttribute("Symbol")
	out = out + '|' + quote.getElementsByTagName("Date")[0].firstChild.data
	out = out + '|' + quote.getElementsByTagName("Close")[0].firstChild.data
	out = out + '|' + quote.getElementsByTagName("Volume")[0].firstChild.data
	out = out + '\n'
#print out
outfile = open('/var/local/a/eod.txt','w')
outfile.write(out)
outfile.close()

#copy the file to here mysql can read it
#try:
#os.remove('/var/lib/mysql/eod.txt')
#except OSError:
#	pass
#shutil.copy('/var/local/a/eod.txt','/var/lib/mysql/eod.txt')
os.system('cp /var/local/a/eod.txt /var/lib/mysql/a/eod.txt')
#import the csv file to a tmp table in the mysql database
cur.execute('CREATE TEMPORARY TABLE tmp.eod (s varchar(50),dt date,p float,v bigint(20)) ENGINE=InnoDB DEFAULT CHARSET=latin1;')
cur.execute('load data infile \'eod.txt\' into table tmp.eod columns terminated by \'|\';')
cur.execute("INSERT INTO a.t_eod_data (Dt, Security_k, Closing_Price, \
Volume) select e.dt as Dt,s.Security_k ,p as Closing_Price ,v as Volume from tmp.eod e inner join \
a.APP_V_SYMBOLS s on  s.Yahoo_Symbol = e.s left outer join \
t_eod_data d on d.Dt = e.dt and d.Security_k = s.Security_k \
where d.Dt is null;")
c.commit()
#for (dt) in cur:
#        print "{0[0]}".format(dt)
#now copy any data that is not already recorded into t_eod_data
#sql = 'INSERT INTO a.t_eod_data (Dt, Security_k, Closing_Price, \
#        Volume) select e.dt,s.Security_k,p,v from a.eod e inner join \
#        a.APP_v_symbols s on  s.Yahoo_Symbol = e.s left outer join \
#        t_eod_data d on d.Dt = e.dt and d.Security_k = s.Security_k \
#        where d.Dt is null;'
#print("{0[0]}".format(sql))
#print(cur.fetchwarnings())
#cur.execute(str(sql))


#if the tmp schema does not exist, create it
#cur.execute("CREATE DATABASE IF NOT EXISTS tmp;")
#cur.execute("create table if not exists tmp.eod(s nvarchar(50),dt date, p float, v bigint(20))")
#cur.execute("load data infile '/var/local/a/eod.txt' into table tmp.eod fields terminated by '|' lines terminated by '\n';")

#insert any new or updated data from the csv file into the EOD table



#symbols = ''
#counter = float(0)
#os.remove('/var/local/a/sharecounts.csv')
#csvOUT = open('/var/local/a/sharecounts.csv','ab')
#with open('/var/local/a/companylist.csv') as csvfile:
#	sfile = csv.reader(csvfile)
#	for row in sfile:
#		if row[0].strip() <> '' and row[0].strip() <> "Symbol":
#			symbols = symbols + ',' + row[0].strip()
#			counter = counter + 1
#apparently can do 500 at a time, but if 1000 then no rows are returned.
#		if float(counter) / 500 == round(float(counter) / 500):
#			fetch()
#			counter = 0
#			symbols = ''
#fetch()
#csvOUT.close()

def fetch():
	url = 'http://download.finance.yahoo.com/d/quotes.csv?s=' + symbols + '&f=snj2f6'
	csvOUT.write(urllib2.urlopen(url).read())
	return
