# 2.Perform Detailed exploratory analysis:
# 2.1 Understanding how many customers acquired every month (x)
# 2.2 Understand the retention of customers on month on month basis 
# 2.3 How the revenues from existing/new customers on month on month basis
# 2.4 How the discounts playing role in the revenues?
# 2.5 Analyse KPI’s like Revenue, number of orders, average order value, number of customers (existing/new), 
# quantity, by category, by month, by week, by day etc…
# 2.6 Understand the trends/seasonality of sales by category, location, month etc…
# 2.7 How number order varies and sales with different days?
# 2.8 Calculate the Revenue, Marketing spend, percentage of marketing spend out of revenue, Tax, percentage of delivery charges by month.
# 2.9 How marketing spend is impacting on revenue?
# 2.10 Which product was appeared in the transactions?
# 2.11 Which product was purchased mostly based on the quantity?

# 0. Load the packages
library("pacman")
pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes, ggvis, httr,
               lubridate, plotly, rio, rmarkdown, shiny, stringr, tidyr, psych)

# 1. Load cleaned datasets
load(file = "D:/Coding Projects/Customer Lifetime Value Analysis/transformed datasets/tables_cleaned.RData")
print("Datasets loaded.")

# --------------2.1 How many new customers acquired every month?----------------
## Expected row: c("Jan 2019", 23)
# View(table_OnlineSales)
View_CustomerMonth <- table_OnlineSales[, c("CustomerID", "Transaction_Date")]
View_CustomerMonth$Month <- format(View_CustomerMonth$Transaction_Date, "%Y-%m")

## sort the dataset by Date in ascending order
View_CustomerMonth <- View_CustomerMonth[order(View_CustomerMonth$Month, decreasing = FALSE), ]
# View(View_CustomerMonth)

# calculate number of new customers of each month
## remove duplicates of customerID
View_CustomerFirstTime <- distinct(View_CustomerMonth, CustomerID, .keep_all = TRUE)
colnames(View_CustomerFirstTime)[colnames(View_CustomerFirstTime) == "Month"] <- "First_Transaction_Month"
colnames(View_CustomerFirstTime)[colnames(View_CustomerFirstTime) == "Transaction_Date"] <- "First_Transaction_Date"
View(View_CustomerFirstTime)

## count the ID for each month
View_NewCustomerbyMonth <- aggregate(CustomerID ~ First_Transaction_Month,
                                     data = View_CustomerFirstTime,
                                     FUN = function(x) length(x)
                                     # a simpler way is to use unique(x), so that don't have to remove duplicates before
                                     )

View(View_NewCustomerbyMonth)
print("The number of new customers of each month calculated. See View_NewCustomerbyMonth.")

# ------2.2 Understand the retention of customers on month on month basis-------
## need to create 11 groups:
## new customers of Jan -> Feb -> Mar -> ... -> Dec
## new customers of Feb -> Mar -> Apr -> ... -> Dec
## ...
## new customers of Nov -> Dec


## for each group of customers, calculating how many of them continue shopping in the next few months
## OnlineSales - View-CustomerUniqueMonth: on CustomerID
View_CustomerRetention <- left_join(table_OnlineSales, View_CustomerFirstTime,
                                    by= "CustomerID")

View_CustomerRetention <- View_CustomerRetention[, c("CustomerID", "Transaction_Date", "First_Transaction_Month")]
View_CustomerRetention$Transaction_Month <- format(View_CustomerRetention$Transaction_Date, "%Y-%m")

## For any new customer group, exclude different "First Month Label", and then aggregate by counting IDs
## E.g. For January New Customers (First_Transaction_Month = 2019-01)

# View_CustomerRetention_Jan <- View_CustomerRetention[View_CustomerRetention$First_Transaction_Month == "2019-01", ]
# View_CustomerRetention_Jan <- aggregate(CustomerID ~ Transaction_Month, 
#                                         data = View_CustomerRetention_Jan,
#                                         FUN = function(x) length(unique(x))
#                                         )
# View(View_CustomerRetention_Jan)


create_CustomerRetentionTable <- function(dataset, date_label) {
  # set view name
  full_view_name <- paste0("View_CustomerRetention_", as.character(date_label))
  
  # excluding irrelevant transactions
  dataset_filtered <- dataset[dataset$First_Transaction_Month == as.character(date_label), ]
  
  # aggregate
  aggregated_data <- aggregate(CustomerID ~ Transaction_Month, 
                                data = dataset_filtered,
                                FUN = function(x) length(unique(x))
                                )
  
  # assign as global variables
  assign(full_view_name, aggregated_data, envir = .GlobalEnv)

  # view
  View(aggregated_data)
}

date_list <- c(unique(View_CustomerFirstTime$First_Transaction_Month))

for (date_month in date_list) {
  create_CustomerRetentionTable(View_CustomerRetention, as.character(date_month))
}

print("Customer retention analysis for 12 months completed.")

