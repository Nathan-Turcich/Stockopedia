# Python code to demonstrate table creation and insertions with SQL
import mysql.connector
import datetime
import random
import time

from requests import get
from requests.exceptions import RequestException
from contextlib import closing
from bs4 import BeautifulSoup

host = "sp19-cs411-49.cs.illinois.edu"
user = "root"
password = "374sucks"
database = 'Stockopedia'

myDB = mysql.connector.connect(host = host, user = user, passwd = password, database = database)
cursor = myDB.cursor()

# URL FUNCTIONS
def getURLs(isRealTime):
    cursor.execute("SELECT name FROM Stocks GROUP BY name;")
    data = cursor.fetchall()
    stockNames = []
    for d in data:
        stockNames.append(d[0])
    
    # Sample Topic: https://finance.yahoo.com/quote/AAPL/profile?p=AAPL
    # Sample RealTime: https://finance.yahoo.com/quote/AAPL?p=AAPL
    baseURL = "https://finance.yahoo.com/quote/"
    urls = []
    for name in stockNames:
        if isRealTime:
            url = baseURL + name + "?p=" + name
        else:
            url = baseURL + name + "/profile?p=" + name
    	urls.append(url)
    return urls

def getURLData(url):
    try:
        with closing(get(url, stream=True)) as resp:
            if isGoodResponse(resp):
                return resp.content
            else:
                return None

    except RequestException as e:
        print(e)
        return None

def isGoodResponse(resp):
    content_type = resp.headers['Content-Type'].lower()
    return (resp.status_code == 200
            and content_type is not None
            and content_type.find('html') > -1)


# TOPICS
def scrapeWebsitesForTopics(listOfURLs):
    topics = list()
    deleteNames = list()
    for url in listOfURLs:
        rawHTML = getURLData(url)
        if rawHTML != None:
            html = BeautifulSoup(rawHTML, 'html.parser')
            sector = html.findAll('span',class_='Fw(600)')
            company = html.find('h1', class_ = 'D(ib) Fz(18px)')
            if len(sector) > 1 and sector[1] is not None and company is not None:
                company_text = company.get_text()
                begin = 0
                end = 0
                for x in range(len(company_text)):
                    if(company_text[x] == '('):
                        begin = x + 1
                    if(company_text[x] == ')'):
                        end = x
                        abbr = company_text[begin:end]
                
                topic = sector[1].get_text()
                
                fullName = company_text[:begin - 2]
                topics.append((abbr, fullName, topic))
                print(abbr)
            else:
                begin = 0
                for x in range(len(url)):
                    if(url[x] == '='):
                        begin = x + 1
                symbol = url[begin:]
                deleteNames.append(symbol)
                print("DELETE: " + symbol)

    return topics, deleteNames

def insertTopicsToDB(listOfTopics):
    cursor.execute("DELETE FROM Topics")
    for (abbr, fullName, topic) in listOfTopics:
        cursor.execute("INSERT INTO Topics (abbr, fullname, topic) VALUES (%s, %s, %s)", (abbr, fullName, topic.replace("&", "and")))

def deleteNoIndustryNames(deleteNames):
    for name in deleteNames:
        cursor.execute("DELETE FROM Stocks WHERE name = '" + name + "'")

def addFullNames(listOfTopics):
    for (abbr, fullName, topic) in listOfTopics:
        cursor.execute("UPDATE Stocks SET fullname = '" + fullName.replace("'", "") + "' WHERE name = '" + abbr + "'")


# REAL TIME STOCKS
def scrapeWebsitesForRealTimeData(listOfURLs):
    realTimeStocks = list()

    for url in listOfURLs:
        rawHTML = getURLData(url)
        if rawHTML != None:
            html = BeautifulSoup(rawHTML, 'html.parser')
            
            company = html.find('h1', class_ = 'D(ib) Fz(18px)')
            
            abbr = ""
            fullName = ""
            
            # ABBR - FULLNAME
            if(company is not None):
                company_text = company.get_text()
                begin = 0
                end = 0
                for x in range(len(company_text)):
                    if(company_text[x] == '('):
                        begin = x + 1
                    if(company_text[x] == ')'):
                        end = x
                        abbr = company_text[begin:end]
                
                fullName = company_text[:begin - 2]
            else:
                fullname = "None"
                abbr = "None"
            
            date = getCurrentTime()

            # OPEN
            open = html.find('span', attrs={"data-reactid": "46"})
            if(open is not None):
                open = open.get_text()
            else:
                open = "0"
            open.replace("+", "")

            # CLOSE
            close = html.find('span', attrs={"data-reactid": "41"})
            if(close is not None):
                close = close.get_text()
            else:
                close = "0"
    
            # LOW - HIGH
            low_high = html.find('td', attrs={"data-reactid": "60"})
            if(low_high is not None):
                range_text = low_high.get_text()
                begin = 0
                end = 0
                amount = 0
                for x in range(len(range_text)):
                    if(range_text[x] == ' ' and amount == 0):
                        begin = x
                        amount += 1
                    if(range_text[x] == ' ' and amount == 1):
                        end = x
                        amount += 1
            
                low = range_text[0: begin]
                high = range_text[end: len(range_text)]
                if high == " Week Range":
                    high = "0"
            else:
                low = "0"
                high = "0"
            print(high)
            high.replace("- ", "")
            print(high)

            # VOLUME
            volume = html.find('span', attrs={"data-reactid": "69"})
            if(volume is not None):
                volume = volume.get_text()
            else:
                volume = "0"

            # MARKET CAP
            mrktcap = html.find('span', attrs={"data-reactid": "82"})
            if(mrktcap is not None):
                mrktcap = mrktcap.get_text()
            else:
                mrktcap = "0"

            # DIFF
            diff = html.find('span', attrs={"data-reactid": "35"})
            if(diff is not None):
                diff = diff.get_text()
                diff = diff[diff.find("(")+1:diff.find(")")]
            else:
                diff = "0"

            print(abbr)
            
            realTimeStocks.append((abbr, fullName, date, open, close, low, high, volume, mrktcap, diff))

            # RANDOM
            break
            time.sleep(random.uniform(0.0, 2.0))

    return realTimeStocks

def insertRealTimeStocksToDB(listOfRealTimeStocks):
    for (abbr, fullName, date, open, close, low, high, volume, mrktcap, diff) in listOfRealTimeStocks:
        cursor.execute("INSERT INTO RealTimeStocks (abbr, fullName, date, open, close, low, high, volume, mrktcap, diff) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (abbr, fullName, date, open, close, low, high, volume, mrktcap, diff))

def getCurrentTime():
    return datetime.datetime.now().strftime("%a, %b %d, %Y")

if __name__ == '__main__':
    # TOPICS
    #listOfTopics, deleteNames = scrapeWebsitesForTopics(getURLs(False))
    #insertTopicsToDB(listOfTopics)
    #deleteNoIndustryNames(deleteNames)
    #addFullNames(listOfTopics)

    # REAL TIME STOCKS
    listOfRealTimeStocks = scrapeWebsitesForRealTimeData(getURLs(True))
    insertRealTimeStocksToDB(listOfRealTimeStocks)

    myDB.commit()
    myDB.close()
