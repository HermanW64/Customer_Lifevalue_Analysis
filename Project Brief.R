# The Marketing and Customer Analytics Project (R programming)
# The project requirement website: https://www.kaggle.com/datasets/rishikumarrajvansh/marketing-insights-for-e-commerce-company

# --------------------------------Business Objective----------------------------
# 1.Calculate Invoice amount or sale_amount or revenue for each transaction and item level 
# 1.1 Invoice Value =((Quantity * Avg_price)(1 - Discount_pct)*(1+GST))+Delivery_Charges (X, PowerBI)

# 2.Perform Detailed exploratory analysis 
# 2.1 Understanding how many customers acquired every month (X, PowerBI)
# 2.2 Understand the retention of customers on month on month basis (X, PowerBI)
# 2.3 How the revenues from existing/new customers on month on month basis (X, PowerBI)

# 2.4 How the discounts playing role in the revenues? (PowerBI)

# 2.5 Analyse KPI’s like Revenue, number of orders, average order value, number of customers (existing/new), 
# quantity, by category, by month, by week, by day etc… (PowerBI)

# 2.6 Understand the trends/seasonality of sales by category, user gender, user location, month etc… (PowerBI)
# 2.7 How number of order varies and sales with different days? (PowerBI)

# 2.8 Calculate the Revenue, Marketing spend, percentage of marketing spend out of revenue, Tax, 
# percentage of delivery charges by month. (PowerBI)

# 2.9 How marketing spend is impacting on revenue? (PowerBI)
# 2.10 Which product was appeared mostly in the transactions? (PowerBI)
# 2.11 Which product was purchased mostly based on the quantity? (PowerBI)
# - dimension: month, category, user location/gender

# 3.Performing Customer Segmentation
# 3.1 Heuristic (Value based, RFM) (PowerBI)
# – Divide the customers into Premium, Gold, Silver, Standard customers and define strategy on the same.
# - set today as: Jan 1, 2020, period as Jan 1, 2019 - Dec 31, 2019

# 3.2 Scientific (Using K-Means) & Understand the profiles. Define strategy for each segment.

# 4.Predicting Customer Lifetime Value (Low Value/Medium Value/High Value)
# 4.1 First define dependent variable with categories low value, medium value, high value using customer revenue.
# 4.2 Then perform Classification model Cross-Selling (Which products are selling together)
# 4.3 You can perform exploratory analysis & market basket analysis to understand which of items can be bundled together.
# 4.4 Predicting Next Purchase Day(How soon each customer can visit the store (0-30 days, 30-60 days, 60-90 days, 90+ days)
# For this, we need create dependent variable at customer level 
# (average days per one transaction for only repeat customers and divide into groups 0-30 days, 30-60 days,
# 60-90 days and 90+ days) then build classification model to predict next purchase of given customer.

# 5.Perform cohort analysis by defining below cohorts
# 5.1 Customers who started in each month and understand their behaviour
# 5.2 Which Month cohort has maximum retention?
