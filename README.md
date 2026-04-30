Bank Customer Churn & Trend Analysis

Project Overview :-
This project focuses on identifying high-value "loyal" customers and uncovering the underlying patterns behind customer churn for a banking institution. Using PostgreSQL in pgAdmin, I performed extensive Exploratory Data Analysis (EDA) to move beyond simple averages and understand the "why" behind customer exits.


🛠️ Tech Stack & Methodology :-
Database: PostgreSQL (pgAdmin)SQL 
Techniques: Window Functions (ROW_NUMBER, DENSE_RANK, OVER), Common Table Expressions (CTEs), DDL/DML Commands, Case Statements, and Aggregate Functions.Analysis 
Focus: Customer Segmentation, Statistical Summary (Mean vs. Median), and Behavioral Pattern Recognition.


📈 Key Insights & Statistical Summary :-
1) One of the most critical findings was the discrepancy between the Mean and Median of account balances.
Mean Balance: 76,485.89  
Median Balance: 97,208.46  

2) Observation: The Mean is significantly lower because 36% of our customers hold a $0 balance. These "ghost accounts" pull down the average, making the customer base look less wealthy than it actually is. The Median provides a more accurate picture of our typical engaged customer.  


Identifying Top Loyal Customers :-
To identify the top 10 loyal customers, I filtered for Active Members who have not churned (Exited = 0) and ranked them by their Account Balance using the ROW_NUMBER() window function.


The "VIP 5" Selection :-
For the absolute top-tier rewards program, I developed a custom scoring algorithm using a CTE (Customer_Scoring). This weighted formula considers Credit Score, Balance, Tenure, and Product Usage to rank the most deserving customers.  

Top 5 Surnames: Hansen, Davidson, Speth, Ward, and Lee.  


Customer Churn Analysis: The "Red Flags" :-
1) Age & Wealth: Churn peaks at 56% for customers in their 50s. These wealthy seniors are likely seeking specialized investment or retirement services that are currently missing from our portfolio.
   
2) The "Over-Banked" Paradox: Surprisingly, customers with 3 or 4 products churned at a nearly 100% rate. This suggests that more products may lead to higher fees or service confusion rather than loyalty.
  
3) Geographic Trend: German customers are leaving at twice the rate (32%) of those in France or Spain, indicating a potential local service model misalignment or stronger competitor offers in that region.

4) Gender Factor: Data shows that Females (2,278 exits) are churned more frequently than Males (1,796 exits).


Top 3 Strategic Focus Areas :-
1) Retention of Wealthy Seniors: Offer VIP/Priority banking or specialized wealth management to customers aged 45–60 with balances over $100,000.

2) Activation Program: Launch a "First 5 Transactions" reward program specifically targeting the 36% of customers with a $0 balance to convert them into active members.

3)  Product Simplification: Investigate and simplify the fee structure for multi-product users (3+ products) to ensure they feel rewarded for their deep relationship rather than "over-banked".

 
Project Structure :-
data/: Contains the Bank Churn Dataset.
queries/: Includes all SQL scripts for DDL, DML, and Advanced Analytics.
visuals/: Charts generated via pgAdmin Graph Visualizer (Gender churn, Age-Balance relations, etc.).
