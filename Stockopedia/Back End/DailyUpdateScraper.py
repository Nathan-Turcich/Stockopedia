# Python code to demonstrate table creation and insertions with SQL
import mysql.connector

host = "sp19-cs411-49.cs.illinois.edu"
user = "root"
password = "374sucks"
database = 'Stockopedia'

myDB = None
cursor = None

def initilizeDB():
    myDB = mysql.connector.connect(host = host, user = user, passwd = password, database = database)
    cursor = myDB.cursor()

def getURLs(myDB):
    cursor.execute("SELECT name FROM Stocks GROUP BY name;")
    data = cursor.fetchall()
    stocks = []
    for d in data:
        stocks.append(d)
    return stocks

def scrapeWebsitesForTopics(listOfURLs):
    print(listOfURLs)
    return [("APPL", "Technology"), ("Ford", "Cars"), ("MCD", "Food")]

def insertTopicsToDB(listOfTopics):
    for (stock, topic) in listOfTopics:
        sql = "INSERT INTO StockTopics (name, topic) VALUES (%s, %s)"
        cursor.execute(sql, (stock, topic))

    mydb.commit()
    mydb.close()

if __name__ == '__main__':
    initilizeDB()
    listOfTopics = scrapeWebsitesForTopics(getURLs())
    insertTopicsToDB(listOfTopics)
