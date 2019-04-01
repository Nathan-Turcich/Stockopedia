# Python code to demonstrate table creation and insertions with SQL
import mysql.connector

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
    for item in listOfURLs:
        print(item)   
    return [("APPL", "Technology"), ("Ford", "Cars"), ("MCD", "Food")]

def insertTopicsToDB(listOfTopics):
    for (stock, topic) in listOfTopics:
        sql = "INSERT INTO StockTopics (name, topic) VALUES (%s, %s)"
        cursor.execute(sql, (stock, topic))

    myDB.commit()
    myDB.close()

if __name__ == '__main__':
    listOfTopics = scrapeWebsitesForTopics(getURLs())
    insertTopicsToDB(listOfTopics)
