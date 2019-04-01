# Python code to demonstrate table creation and insertions with SQL
import mysql.connector

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

def getURLs():
    cursor.execute("SELECT name FROM Stocks GROUP BY name;")
    data = cursor.fetchall()
    stockNames = []
    for d in data:
        stockNames.append(d[0])
    
    # Sample: https://finance.yahoo.com/quote/AAPL/profile?p=AAPL
    baseURL = "https://finance.yahoo.com/quote/"
    urls = []
    for name in stockNames:
        url = baseURL + name + "/profile?p=" + name
    urls.append(url)
    return urls

def scrapeWebsitesForTopics(listOfURLs):
    topics = ((),)
    for url in listOfURLs:
        rawHTML = getURLData(url)
        if rawHTML(url) != None:
            print(rawHTML)
    # Get Topic
    return topics

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

def insertTopicsToDB(listOfTopics):
    for (stock, topic) in listOfTopics:
        sql = "INSERT INTO StockTopics (name, topic) VALUES (%s, %s)"
        cursor.execute(sql, (stock, topic))

    myDB.commit()
    myDB.close()

if __name__ == '__main__':
    listOfTopics = scrapeWebsitesForTopics(getURLs())
    insertTopicsToDB(listOfTopics)
