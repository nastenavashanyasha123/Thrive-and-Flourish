'''
Thrive and Flourish

# Importing required libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Set the default font size
plt.rcParams.update({'font.size': 14})

# Reading the dataset
data = pd.read_csv("data.csv")

# Print the first 5 records
data.head()

# Computing descriptive statistics
statistics = data.describe()
print(statistics)

# Computing correlation
correlation = data.corr()

# Plotting the correlation heatmap
plt.figure(figsize=(6, 6))
plt.imshow(correlation, cmap='RdYlGn', interpolation='none', aspect='auto')
plt.colorbar()
plt.show()

# Computing the Variance Inflation Factors
vif = data.apply(lambda x: pd.Series([x.corr(x.shift(1))], index=["VIF"])).T
print(vif)

# Plotting the boxplot 
data.plot.box(vert=False, figsize=(15, 5))
plt.show()

# Split data for training and testing
X = data.iloc[:, :-1].values
y = data.iloc[:, -1].values
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=0)

# Training the model
from sklearn.linear_model import LinearRegression
regressor = LinearRegression()
regressor.fit(X_train, y_train)

# Predicting the results
y_pred = regressor.predict(X_test)

# Calculating the errors
from sklearn.metrics import mean_squared_error, r2_score
mse = mean_squared_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

# Results
print("Mean Squared Error:", mse)
print("R2 Score:", r2)

# Plotting the data
plt.scatter(X_test, y_test, color="red")
plt.plot(X_test, y_pred, color="blue")
plt.title("Linear Regression Model")
plt.xlabel("X")
plt.ylabel("Y")
plt.show()

# Saving the model
import pickle
pickle.dump(regressor, open('model.pkl','wb'))

# Loading the model
model = pickle.load(open('model.pkl','rb'))

# Making predictions
prediction = model.predict([[1,2,3,4]])
print("Predicted value:", prediction)
'''