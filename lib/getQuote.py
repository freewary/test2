#!/usr/bin/env python
import sys, os, random, datetime
from httplib import HTTPConnection
from urllib import urlencode
from xml.dom import minidom
#by default, all quotes are saved to /var/log/getquote/quote.log
#by default, all errors are saved to /var/log/getquote/err.log
logpath = '/var/log/getquote'
if not os.path.exists(logpath): 
	os.makedirs(logpath)
	os.chmod(logpath,0777)
#first argement will always be the name of the script, always ignore
#2nd argemunt may be parms, if it starts with '-' it is parms, otherwise assume symbol
#3rd and higher argument is always assumed to be a symbol
if str(sys.argv[1])[:1] == "-":
	#print ("The parms are '" + str(sys.argv[1]) + "'")
	parms = str(sys.argv[1])
	symstart = 2
else:
	#print ("There are no parms")
	parms = str("")
	symstart = 1
#print ("Symbols to quote " + str(sys.argv[symstart:]))
#Add code to get the actual quotes, for now, just use random numbers


#Output
if "h" in parms:
	out = str("symbol|last|last_ts|bid|ask|bid_size|ask_size\n")
else:
	out = str("")
symbols = '"'
for x in sys.argv[symstart:]:
#	q = random.uniform(1,150)
#	diff_bid = random.uniform(0,.02) * -1
#	diff_ask = random.uniform(0,.02)
#	size_bid = random.randrange(1,500)
#	size_ask = random.randrange(1,500)
#	out = out + x + "|" + str(q) + "|" + str(datetime.datetime.now()) + "|" + str(q * (1+diff_bid)) + "|" + str(q * (1 + diff_ask)) + "|" + str(size_bid) + "|" + str(size_ask) +  "\n"
	symbols = symbols + x + '","'

symbols = symbols[:len(symbols) -2]
#print (symbols)

#print (out)
#yql = 'select * from yahoo.finance.quote where symbol = '
yql = 'select symbol,LastTradePriceOnly,LastTradeDate,LastTradeTime,Bid,Ask from yahoo.finance.quotes where symbol in ('
#print (yql)
conn = HTTPConnection('query.yahooapis.com')
#print  urlencode({'q': yql + symbols + ')', 'format': 'json', 'env': 'store://datatables.org/alltableswithkeys' })
url = 'http://query.yahooapis.com/v1/public/yql' + '?' + urlencode({'q': yql + symbols + ')', 'format': 'xml', 'env': 'store://datatables.org/alltableswithkeys' })
#print (url)
conn.request('GET',str(url))
qxml =  minidom.parseString(conn.getresponse().read())
quotes = qxml.getElementsByTagName("quote")
for quote in quotes:
	out = out + quote.getAttribute("symbol")
	out = out + '|' + quote.getElementsByTagName("LastTradePriceOnly")[0].firstChild.data
	out = out + '|' + quote.getElementsByTagName("LastTradeDate")[0].firstChild.data + ' ' + quote.getElementsByTagName("LastTradeTime")[0].firstChild.data
	out = out + '|' + quote.getElementsByTagName("Bid")[0].firstChild.data
	out = out + '|' + quote.getElementsByTagName("Ask")[0].firstChild.data
	out = out + '|NULL|NULL\n'

print (out)

