# 1.Calculate Invoice amount or sale_amount or revenue for each transaction and item level
# Invoice Value =((Quantity*Avg_price)(1 - Dicount_pct)*(1+GST))+Delivery_Charges

# 0. Load necessary packages
library("pacman")
pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes, ggvis, httr,
               lubridate, plotly, rio, rmarkdown, shiny, stringr, tidyr, psych)

# The following tables are needed to join for the business needs:
# (1) Online Sales (Our major table): $transactionID, $product_sku, $product_category, $quantity, $avg_price, $delivery_charge, $coupon_status 
# (2) Discount Coupon
# (3) GST Amount

# 1. Load datasets (RDate)
load(file = "D:/Coding Projects/Customer Lifetime Value Analysis/transformed datasets/tables_cleaned.RData")
print("Datasets loaded.")

# 2. Left join: OnlineSales - GST on "Product_Category"
# View(table_OnlineSales)
# View(table_GST)
# View(table_Discount)

View_OnlineSales_GST <- left_join(table_OnlineSales, table_GST, by= "Product_Category")
# View(View_OnlineSales_GST)

# 3. Left join: View_OnlinesSales_GST, Discount on="Month" & "Product_Category"
# Need to create a new variable from transaction date: month("Character")
View_OnlineSales_GST$Month <- format(View_OnlineSales_GST$Transaction_Date, "%b")
# View(View_OnlineSales_GST)

# Need to create a new dummy variable (0, 1) from Coupon_Status
View_OnlineSales_GST$Coupon_Status_Bi <-  ifelse(View_OnlineSales_GST$Coupon_Status == "Used", 1, 0)

# Left join
View_OnlineSales_GST_Coupon <- left_join(View_OnlineSales_GST, table_Discount, by= c("Month", "Product_Category"))
# View(View_OnlineSales_GST_Coupon)

summary(View_OnlineSales_GST_Coupon)

# 4. Calculate Invoice Value on transaction level
# Invoice Value =((Quantity*Avg_price)(1 - Discount_pct)*(1+GST))+Delivery_Charges
View_OnlineSales_GST_Coupon$Invoice <- (
                                        (
                                         (View_OnlineSales_GST_Coupon$Quantity * View_OnlineSales_GST_Coupon$Avg_Price)
                                         *(1 - View_OnlineSales_GST_Coupon$Discount_pct * 0.01 * View_OnlineSales_GST_Coupon$Coupon_Status_Bi)
                                         *(1 + View_OnlineSales_GST_Coupon$GST)
                                        ) 
                                        + View_OnlineSales_GST_Coupon$Delivery_Charges
                                       )

View_OnlineSales_GST_Coupon$Invoice <- round(View_OnlineSales_GST_Coupon$Invoice, 2)

View_OnlineSales_Invoice_Transaction <- View_OnlineSales_GST_Coupon[, c("Transaction_ID", "Invoice")]
View_OnlineSales_Invoice_Transaction <- View_OnlineSales_Invoice_Transaction[order(View_OnlineSales_Invoice_Transaction$Invoice, 
                                                                                   decreasing = TRUE), ]
View(View_OnlineSales_Invoice_Transaction)

# 5. Summarize Invoice value on item (SKU) level
# sum() and group-by:
# View(View_OnlineSales_GST_Coupon)
View_OnlineSales_Invoice_SKU <- View_OnlineSales_GST_Coupon[, c("Product_SKU", "Product_Description", "Invoice")]
View_OnlineSales_Invoice_SKU <- aggregate(Invoice ~ Product_SKU + Product_Description, 
                                          data = View_OnlineSales_GST_Coupon,
                                          FUN = sum
                                          )
# order() to sort in descending order
View_OnlineSales_Invoice_SKU <- View_OnlineSales_Invoice_SKU[order(View_OnlineSales_Invoice_SKU$Invoice, decreasing = TRUE), ]
View(View_OnlineSales_Invoice_SKU)

print("Invoice Calculation completed.")
