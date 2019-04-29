'''
This Python script creates 30-day prections for every stock in our database using more than 5 years of historical data.
Using this historical data, we perform a linear regression to create an array that contains the stock's predicted prices for
the next 30 days. We then have a specific Prediction table to hold our predictions for each stock. Every night, this script
is run using a Cron Job to use the latest prices and get the most accurate data for users.
'''

#########################################################################################################################################

#Imports for math, dates, json, and webscraping
import numpy as np
from datetime import datetime
import smtplib
import time
from selenium import webdriver
import json

#Imports to perform linear regression on data
from sklearn.linear_model import LinearRegression
from sklearn import preprocessing, svm
from sklearn.model_selection import train_test_split

#imports to help retrieve historical data
from iexfinance.stocks import Stock
from iexfinance.stocks import get_historical_data

#Import for connecting to database
import mysql.connector

#########################################################################################################################################
# Constants to connect to the Database

host = "sp19-cs411-49.cs.illinois.edu"
user = "root"
password = "374sucks"
database = 'Stockopedia'

#########################################################################################################################################

#Function to create a 30-day outlook prediction on a single stock.
#The function uses Linear Regression and 5 years of historical data
#to create the predictions.
def predictData(stock, days):
    
    #Determine how much historical data to use in prediction
    start = datetime(2014, 1, 1)
    end = datetime.now()

    #Retrieve the historical data
    df = get_historical_data(stock, start = start, end = end, output_format = 'pandas')

    #Create a CSV file of historical data to use for Linear Regression later
    csv_name = ('Exports/' + stock + '_Export.csv')
    df.to_csv(csv_name)
    df.dropna(inplace = True)
    forecast_time = int(days)
    df['prediction'] = df['close'].shift(-forecast_time)

    #Create numpy arrays to use for Linear Regression
    X = np.array(df.drop(['prediction'], 1))
    X = preprocessing.scale(X)
    X_prediction = X[-forecast_time:]
    X = X[:-forecast_time]
    
    #Create numpy arrays to use for Linear Regression
    Y = np.array(df['prediction'])
    Y = Y[:-forecast_time]

    #Create training and test sets to use for Linear Regression
    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size = 0.3)

    #Perform Linear regression and create 30 predictions
    clf = LinearRegression()
    clf.fit(X_train, Y_train)
    confidence = clf.score(X_test, Y_test)
    prediction = (clf.predict(X_prediction))

    #Format predictions to be strings so they can be easily stored in our database
    strPrediction = []
    for p in prediction:
        strPrediction.append(str(p))

    return strPrediction

if __name__ == '__main__':
    
    # Connects to the DB
    # Creates a cursor object to apply SQL Queries
    myDB = mysql.connector.connect(host = host, user = user, passwd = password, database = database)
    cursor = myDB.cursor()
    
    print("Retrieving Stocks")
    
    #Get all company abbreviations from database
    cursor.execute("SELECT name FROM Stocks GROUP BY name;")
    data = cursor.fetchall()
    
    # Create an array with unique Stocks
    stockNames = []
    for d in data:
        stockNames.append(d[0])
    
    print("Creating Predictions")

    # Delete Predictions every night to get new predictions
    cursor.execute("DELETE FROM Predictions")
    
    #Create 30-day predictions for every stock
    for company in stockNames:
        company = str(company)
        
        print(company)
        predictions = predictData(company, 30)

        # Insert every prediction from each stock into Maria DB
        cursor.execute("INSERT INTO Predictions (abbr, day1, day2, day3, day4, day5, day6, day7, day8, day9, day10, day11, day12, day13, day14, day15, day16, day17, day18, day19, day20, day21, day22, day23, day24, day25, day26, day27, day28, day29, day30) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (company, predictions[0], predictions[1], predictions[2], predictions[3], predictions[4], predictions[5], predictions[6], predictions[7], predictions[8], predictions[9], predictions[10], predictions[11], predictions[12], predictions[13], predictions[14], predictions[15], predictions[16], predictions[17], predictions[18], predictions[19], predictions[20], predictions[21], predictions[22], predictions[23], predictions[24], predictions[25], predictions[26], predictions[27], predictions[28], predictions[29]))

    # Commits all changes to maria DB and the closes the connection
    myDB.commit()
    myDB.close()
