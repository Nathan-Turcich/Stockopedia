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
    full_strings = list()
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
                full_strings.append(fullName)
                topics.append((abbr, fullName, topic))
                print(symbol_string)
            else:
                begin = 0
                for x in range(len(url)):
                    if(url[x] == '='):
                        begin = x + 1
                symbol = url[begin:]
                deleteNames.append(symbol)
                print("DELETE: " + symbol)
        break
        print("YO")

    # Get Topic
    return topics, deleteNames, full_strings

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

def insertTopicsToDB(listOfTopics, full_strings):
    cursor.execute("DELETE FROM Topics")
    for (abbr, topic, full_strings) in listOfTopics:
        cursor.execute("INSERT INTO Topics (abbr, fullname, topic) VALUES (%s, %s, %s)", (abbr, full_strings, topic.replace("&", "and")))

def deleteNoIndustryNames(deleteNames):
    for name in deleteNames:
        cursor.execute("DELETE FROM Stocks WHERE name = '" + name + "'")

def addFullNames(abbrs, full_strings):
    index = 0
    for (name, topic) in abbrs:
        cursor.execute("UPDATE Stocks SET fullname = '" + full_strings[index].replace("'", "") + "' WHERE name = '" + name + "'")
        index += 1

    myDB.commit()
    myDB.close()

if __name__ == '__main__':
    listOfTopics, deleteNames, full_strings = scrapeWebsitesForTopics(getURLs())
    insertTopicsToDB(listOfTopics, full_strings)
    deleteNoIndustryNames(deleteNames)
    addFullNames(listOfTopics, full_strings)
