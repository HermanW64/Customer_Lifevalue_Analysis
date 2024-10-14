# Section 1: Data import and cleaning (ETL)

# 0. Load necessary packages
library("pacman")
pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes, ggvis, httr,
               lubridate, plotly, rio, rmarkdown, shiny, stringr, tidyr, psych)

# ------------------1. Load all 5 datasets-------------------------------------
table_GST <-  import(file= "D:/Coding Projects/Customer Lifetime Value Analysis/datasets/Tax_amount.xlsx")
table_Customer  <-  import(file= "D:/Coding Projects/Customer Lifetime Value Analysis/datasets/CustomersData.xlsx")
table_MarketingSpend  <-  import(file= "D:/Coding Projects/Customer Lifetime Value Analysis/datasets/Marketing_Spend.csv")
table_Discount  <-  import(file= "D:/Coding Projects/Customer Lifetime Value Analysis/datasets/Discount_Coupon.csv")
table_OnlineSales  <-  import(file= "D:/Coding Projects/Customer Lifetime Value Analysis/datasets/Online_sales.csv")
print("Datasets loaded.")

# -----------------2. Check variable types in each data.frame------------------
## table GST
# str(table_GST)

## table Customer: ID to chr
# str(table_Customer)
table_Customer$CustomerID <- as.character(table_Customer$CustomerID)
# str(table_Customer)

## table Marketing Spend: Date to date format (Jan 1, 2019)
# str(table_MarketingSpend)
# ?as.Date
table_MarketingSpend$Date <- as.Date(table_MarketingSpend$Date, format = "%m/%d/%Y")
table_MarketingSpend$Date <- as.Date(table_MarketingSpend$Date, "%Y/%m/%d")
# str(table_MarketingSpend)

## table Discount:
# str(table_Discount)

## table OnlineSales: CustomerID to chr, TransactionID to chr, TransactionDate to Date
# str(table_OnlineSales)
table_OnlineSales$CustomerID <- as.character(table_OnlineSales$CustomerID)
table_OnlineSales$Transaction_ID <- as.character(table_OnlineSales$Transaction_ID)
table_OnlineSales$Transaction_Date <- as.Date(table_OnlineSales$Transaction_Date, format = "%m/%d/%Y")
table_OnlineSales$Transaction_Date <- as.Date(table_OnlineSales$Transaction_Date, "%Y/%m/%d")
# str(table_OnlineSales)
print("Data types transformed.")

# -------------------------3. Check missing values ----------------------------
# Create a named list of tables: names + values
tables_list <- list(
  CustomersData = table_Customer,
  Discount_Coupon = table_Discount,
  Tax_amount = table_GST,
  Marketing_Spend = table_MarketingSpend,
  Online_sales = table_OnlineSales
)

# Loop through each table in the named list
for (table_name in names(tables_list)) {
  table <- tables_list[[table_name]] # use [[]] to retrieve elements corresponding to the name
  if (any(is.na(table))) {
    print(paste("Missing values found in the table:", table_name))
  } else {
    print(paste("No missing values in the table:", table_name))
  }
}

# -------------------------4. Export transformed data --------------------------
# View(table_OnlineSales)
# Save as csv files
for (table_name in names(tables_list)) {
  table <- tables_list[[table_name]]
  write.table(table,
              file= paste0("D:/Coding Projects/Customer Lifetime Value Analysis/transformed datasets/", table_name, "_cleaned.csv"),
              # paste0(): no default separator
              sep = "|",
              row.names = FALSE,
              col.names = TRUE
              )
  print(paste("Dataset (csv) saved: ", table_name))
}

# Save as RData
save(table_Customer, table_Discount, table_GST, table_MarketingSpend, table_OnlineSales,
     file = "D:/Coding Projects/Customer Lifetime Value Analysis/transformed datasets/tables_cleaned.RData")

print("Dataset (RData) saved.")

