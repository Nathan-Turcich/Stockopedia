'''
Python code to demonstrate table creation and insertions with SQL
This script is ran every night at midnight.  It is ran through a crontab on Linux.
This script scrapes the website Yahoo Fianance. It scraps the website and puts the data into the Maria DB SQL Server.
This will ensure the data is RealTime daily for our users of the app. The script will first get all the URLs needed for scraping.
Then the script will then scrape the url to get the topic. Once the topic is found, it will be inserted into the Maria DB.
The script will then scrap the websites to get the RealTime data for each URL. Once the data is found it is inserted into Maria DB.
The changes are committed and saved to the DB.
'''

#########################################################################################################################################
# IMPORTS
import Prediction

# Connects python code with SQL DB
import mysql.connector

# Used to randomize sleep the python script
import datetime
import random
import time

# Used to help scrap the website
from requests import get
from requests.exceptions import RequestException
from contextlib import closing
from bs4 import BeautifulSoup

#########################################################################################################################################
# Constants to connect to the Database

host = "sp19-cs411-49.cs.illinois.edu"
user = "root"
password = "374sucks"
database = 'Stockopedia'

#########################################################################################################################################
# URL FUNCTIONS

# Function that will generate all the URLs
# Will get a list of URLs from the baseURL, but will make unique urls based on the unique stocks in the Stocks Table
# If we are getting stocks for RealTimeStocks we must use a different baseURL
def getURLs(isRealTime):
    # Gets all the names from the Stocks table that are unique
    cursor.execute("SELECT name FROM Stocks GROUP BY name;")
    data = cursor.fetchall()
    
    # Create an array with unique Stocks
    stockNames = []
    for d in data:
        stockNames.append(d[0])
    
    # Sample Topic URL: https://finance.yahoo.com/quote/AAPL/profile?p=AAPL
    # Sample RealTime URL: https://finance.yahoo.com/quote/AAPL?p=AAPL
    baseURL = "https://finance.yahoo.com/quote/"

    # Creates all the URLs and returns them
    urls = []
    counter = 0
    for name in stockNames:
        if isRealTime:
            url = baseURL + name + "?p=" + name
        else:
            url = baseURL + name + "/profile?p=" + name
    	urls.append(url)
        counter += 1
    return urls

# Function that gets the URL data
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

# Function that checks if the html is valid and returns accordingly
def isGoodResponse(resp):
    content_type = resp.headers['Content-Type'].lower()
    return (resp.status_code == 200
            and content_type is not None
            and content_type.find('html') > -1)

#########################################################################################################################################
# TOPICS
def scrapeWebsitesForTopics(listOfURLs):
    topics = list()
    deleteNames = list()
    counter = 0
    for url in listOfURLs:
        rawHTML = getURLData(url)
        if rawHTML != None:
            html = BeautifulSoup(rawHTML, 'html.parser')
            sector = html.findAll('span',class_='Fw(600)')
            company = html.find('h1', attrs={"data-reactid": "7"})
            if len(sector) > 1 and sector[1] is not None and company is not None:
                company_text = company.get_text()
                end = 0
                for x in range(len(company_text)):
                    if(company_text[x] == '-'):
                        end = x
                        break
            
                abbr = company_text[0: end - 1]
                fullName = company_text[end + 2: len(company_text)]
                topic = sector[1].get_text()
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

            # Random sleeps to decrease chance of being black listed with webscraper
        randomizeLoop(counter)
        counter += 1

    return topics, deleteNames

# Function that will insert all the topics previously collected and put them in to the DB
# Since dailyUpdateScaper is ran every night, the data to the app will always be up to date even if a stock changes there company topic
def insertTopicsToDB(listOfTopics):
    # We must first delete everything from the Topics so that the data if refreshed every night
    cursor.execute("DELETE FROM Topics")
    for (abbr, fullName, topic) in listOfTopics:
        cursor.execute("INSERT INTO Topics (abbr, fullname, topic) VALUES (%s, %s, %s)", (abbr, fullName, topic.replace("&", "and")))

# Function that takes in a list of invalid names
# These names can include weird ascii charactesr such as '-', '&', and accents. This can cause irregulatries with the data and also cause the app to crash
# This function deletes all the invalid names from the Stocks table.  If these names are not in the Stocks table, then the URL will not be created fot this name, and no longer ever be in any part of the DB, app to cause issues
def deleteNoIndustryNames(deleteNames):
    for name in deleteNames:
        cursor.execute("DELETE FROM Stocks WHERE name = '" + name + "'")

# Function that takes in a the fullname of the stock and updates it into the Stocks Table.
# This function helps to give the app more information then just the abbr.
# This function will also help give the app ability to easily update any names every night - Not Hard Coded
def addFullNames(listOfTopics):
    for (abbr, fullName, topic) in listOfTopics:
        cursor.execute("UPDATE Stocks SET fullname = '" + fullName.replace("'", "") + "' WHERE name = '" + abbr + "'")


#########################################################################################################################################
# REAL TIME STOCKS

# Function that takes in the abbr and the fullname
# Parses and seperates teh abbr and fullname and returns
def getAbbrFullnameRT(company_text):
    end = 0
    for x in range(len(company_text)):
        if(company_text[x] == '-'):
            end = x
            abbr = company_text[0:end - 1]
            break
            
    fullName = company_text[end + 2:len(company_text)]
    return abbr, fullName


# Function that takes the HTML and parses it to find the open price
# Returns the open price as a string
def getOpenRT(html):
    open = html.find('td', attrs={"data-test": "OPEN-value"})
    if(open is not None):
        open = open.get_text()
    else:
        # Default Value to make web scraper robust so no null values are ended
        open = "0"

    # Replaces all '+' with nothing so data is consistent
    open.replace("+", "")

    return open


# Function that takes the HTML and parses it to find the close price
# Returns the close price as a string
def getCloseRT(html):
    close = html.find('td', attrs={"data-test": "PREV_CLOSE-value"})
    if(close is not None):
        close = close.get_text()
    else:
        # Default Value to make web scraper robust so no null values are ended
        close = "0"

    return close


# Function that takes the HTML and parrses it find the low, and high prices
# Returns the low and high prices as strings
def getLowHighRT(html):
    low_high = html.find('td', attrs={"data-test": "DAYS_RANGE-value"})
    
    # Make sure that low, high value is valid
    if(low_high is not None):
        range_text = low_high.get_text()
        begin = 0
        end = 0
        amount = 0
        
        # Parse string to get individual low and high
        for x in range(len(range_text)):
            if(range_text[x] == ' ' and amount == 0):
                begin = x
                amount += 1
            elif(range_text[x] == ' ' and amount == 1):
                end = x + 1
                amount += 1
        
            low = range_text[0: begin]
            high = range_text[end: len(range_text)]
            
            # Checks for bad values again
            if high == " Week Range":
                high = "0"
    else:
        # Default Value to make web scraper robust so no null values are ended
        low = "0"
        high = "0"

    return low, high

# Function that takes the HTML and parses it to find the volume
# Returns the volume as a string
def getVolumeRT(html):
    volume = html.find('td', attrs={"data-test": "TD_VOLUME-value"})
    if(volume is not None):
        volume = volume.get_text()
    else:
        # Default Value to make web scraper robust so no null values are ended
        volume = "0"

    return volume

# Function that takes the HTML and parses it to find the market cap
# Returns the market cap as a string
def getMRKTCap(html):
    mrktcap = html.find('td', attrs={"data-test": "MARKET_CAP-value"})
    if(mrktcap is not None):
        mrktcap = mrktcap.get_text()
    else:
        # Default Value to make web scraper robust so no null values are ended
        mrktcap = "0"

    return mrktcap

# Function that gets the percent difference between the open and close prices
def getDiff(open, close):
    # Replace any commas with nothing so that value may be casted as float
    commaFreeOpen = float(open.replace(",", ""))
    commaFreeClose = float(close.replace(",", ""))
    diff = (commaFreeOpen - commaFreeClose) / commaFreeOpen * 100
    
    # Round Difference to two decimal places
    diff = round(diff, 2)

    return diff

# Function that will randomize sleep
# This function runs every loop so that it will randomize sleep so that scraper will not get blacklisted
# This will cause the HTML requests to be random so that the server can not detect as easily concurrant requests
def randomizeLoop(counter):
    # DIFFERENT FORMS OF WEB SCRAPING TO MINIMIZE GETTING BLACKLISTED ALSO MAKES WEB SCRAPER ROBUST

    # Sleep 7 seconds every request
    time.sleep(5.0)
    
    time.sleep(random.uniform(0.0, 2.0)) # Random Sleep
    
    if counter % 15 == 0:
        time.sleep(30) # Sleep for 60 seconds every 7 website requests

# Function that takes the given URLs and scrapes the website of each
# Gets the HTML and parses to get the abbr, fullname, date, open, close, low, high, volume, mrktcap, and diff
def scrapeWebsitesForRealTimeData(listOfURLs):
    realTimeStocks = list()
    counter = 0
    
    # Go through URLS and get HTML data for each url
    for url in listOfURLs:
        rawHTML = getURLData(url)
        if rawHTML != None:
            
            # Use BeautifulSoup to help parse the html
            html = BeautifulSoup(rawHTML, 'html.parser')
            
            # abbr and fullname
            abbrFullname = html.find('h1', attrs={"data-reactid": "7"})
            
            # Get ABBR - FULLNAME
            abbr = ""
            fullName = ""
            if(abbrFullname is not None):
                abbr, fullName = getAbbrFullnameRT(abbrFullname.get_text())
            else:
                fullName = "None"
                abbr = "None"
            
            # Get the current time through the use of the helper function getCurrentTime()
            date = getCurrentTime()

            # GET OPEN
            open = getOpenRT(html)
           
            # GET CLOSE
            close = getCloseRT(html)
            
            # GET LOW - HIGH
            low, high = getLowHighRT(html)
            
            # GET VOLUME
            volume = getVolumeRT(html)

            # MARKET CAP
            mrktcap = getMRKTCap(html)
            
            # DIFF
            diff = getDiff(open, close)

            # Append all of these values to a tuple to make a complete realTimeStock object
            realTimeStocks.append((abbr, fullName, date, open, close, low, high, volume, mrktcap, diff))
            print(abbr)

            # Random sleeps to decrease chance of being black listed with webscraper
        randomizeLoop(counter)
        counter += 1
    
    return realTimeStocks

# Function that inserts all of the collected realTimeStocks into the DB
def insertRealTimeStocksToDB(listOfRealTimeStocks):
    for (abbr, fullName, date, open, close, low, high, volume, mrktcap, diff) in listOfRealTimeStocks:
        cursor.execute("INSERT INTO RealTimeStocks (abbr, fullName, date, open, close, low, high, volume, mrktcap, diff) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (abbr, fullName, date, open, close, low, high, volume, mrktcap, diff))

#########################################################################################################################################
# Helper Functions
def getCurrentTime():
    return datetime.datetime.now().strftime("%a, %b %d, %Y")

#########################################################################################################################################
# MAIN
if __name__ == '__main__':
    
    # We only run the scraper on the week days because the stock market is closed on the weekends
    if datetime.date.today().isoweekday() is not 7 and datetime.date.today().isoweekday() is not 1:
        # Connects to the DB
        # Creates a cursor object to apply SQL Queries
        myDB = mysql.connector.connect(host = host, user = user, passwd = password, database = database)
        cursor = myDB.cursor()
        
        # TOPICS
        print("Starting Script")
#        listOfTopics, deleteNames = scrapeWebsitesForTopics(getURLs(False))

        print("Inserting Topics Into DB")
#        insertTopicsToDB(listOfTopics)

        print("Deleting names with invalid names")
#        deleteNoIndustryNames(deleteNames)

        print("Adding Fullnames to Stocks")
#        addFullNames(listOfTopics)

        # REAL TIME STOCKS
        print("Starting RealTime")
#        listOfRealTimeStocks = scrapeWebsitesForRealTimeData(getURLs(True))

        print("Inserting RealTimeStocks Into DB")
#        insertRealTimeStocksToDB(listOfRealTimeStocks)

        # Update the date in the Date Table to be the most current
        cursor.execute("UPDATE Date SET date = '" + getCurrentTime() + "'")

        # Commits all changes to maria DB and the closes the connection
        myDB.commit()
        myDB.close()
        #########################################################################################################################################
        # RUNNING PREDICTION SCRIPT NOW
        exec(open("/home/Stockopedia/Stockopedia/Back End/Prediction.py").read())
