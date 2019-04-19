import numpy as np
from datetime import datetime
import smtplib
import time
from selenium import webdriver

from sklearn.linear_model import LinearRegression
from sklearn import preprocessing, cross_validation, svm

from iexfinance import Stock
from iexfinance import get_historical_data

def predictData(stock, days):
    start = datetime(2017, 1, 1)
    end = datetime.now()

    df = get_historical_data(stock, start = start, end = end, output_format = 'pandas')

    csv_name = ('Exports/' + stock + '_Export.csv')
    df.to_csv(csv_name)
    df['prediction'] = df['close'].shift(-1)
    df.dropna(inplace = True)
    forecast_time = int(days)

    X = np.array(df.drop(['prediction'], 1))
    Y = np.array(df['prediction'])
    X = preprocessing.scale(X)
    X_prediction = X[-forecast_time:]

    X_train, X_test, Y_train, Y_test = cross_validation.train_test_split(X, Y, test_size = 0.5)

    clf = LinearRegression()
    clf.fit(X_train, Y_train)
    prediction = (clf.predict(X_prediction))

    print(prediction)
