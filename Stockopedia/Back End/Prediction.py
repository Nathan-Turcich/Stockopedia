import numpy as np
from datetime import datetime
import smtplib
import time
from selenium import webdriver
import json

from sklearn.linear_model import LinearRegression
from sklearn import preprocessing, svm
from sklearn.model_selection import train_test_split

from iexfinance.stocks import Stock
from iexfinance.stocks import get_historical_data

import mysql.connector

host = "sp19-cs411-49.cs.illinois.edu"
user = "root"
password = "374sucks"
database = 'Stockopedia'

def predictData(stock, days):
    
    start = datetime(2014, 1, 1)
    end = datetime.now()

    df = get_historical_data(stock, start = start, end = end, output_format = 'pandas')

    csv_name = ('Exports/' + stock + '_Export.csv')
    df.to_csv(csv_name)
    df.dropna(inplace = True)
    forecast_time = int(days)
    df['prediction'] = df['close'].shift(-forecast_time)

    X = np.array(df.drop(['prediction'], 1))
    X = preprocessing.scale(X)
    X_prediction = X[-forecast_time:]
    X = X[:-forecast_time]
    
    Y = np.array(df['prediction'])
    Y = Y[:-forecast_time]

    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size = 0.3)

    clf = LinearRegression()
    clf.fit(X_train, Y_train)
    confidence = clf.score(X_test, Y_test)
    prediction = (clf.predict(X_prediction))

    #print(confidence)
    #print(prediction)
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
