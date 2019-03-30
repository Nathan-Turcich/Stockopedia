# Python code to demonstrate table creation and insertions with SQL
import mysql.connector

host = "sp19-cs411-49.cs.illinois.edu"
user = "root"
password = "374sucks"
database = 'StockTopics'

def scrapeWebsitesForTopics():
    return [("APPL", "Technology"), ("Ford", "Cars"), ("MCD", "Food")]

def insertTopicsToDB(listOfTopics):
    mydb = mysql.connector.connect(host = host, user = user, passwd = password, database = database)
    cursor = mydb.cursor()
    
    for (stock, topic) in listOfTopics:
        sql = "INSERT INTO StockTopics (name, topic) VALUES (%s, %s)"
        mycursor.execute(sql, (stock, topic))

    mydb.commit()
    mydb.close()

if __name__ == '__main__':
    listOfTopics = scrapeWebsitesForTopics()
    insertTopicsToDB(listOfTopics)
