CREATE TABLE customer_churn(
	"RowNumber" integer, "CustomerId" integer, "Surname" text, "CreditScore" integer,
	"Geography" text, "Gender" text, "Age" integer, "Tenure" integer, "Balance" decimal,
	"NumOfProducts" integer, "HasCrCard" integer, "IsActiveMember" integer, 
	"EstimatedSalary" decimal, "Exited" integer
);

COPY customer_churn 
FROM 'C:/Users/Public/Bank_Churn_Dataset.csv'
DELIMITER ','
CSV HEADER;


SELECT * FROM customer_churn;



-- Statistical Summary (Finding the mean and median of credit score and balance) :-

--Finding the average Average Balance:

SELECT 
ROUND(AVG("Balance"),2) AS avg_balance
FROM customer_churn;

--Finding the median(middle value) of Balance:

SELECT "Balance" AS median_balance
FROM customer_churn
ORDER BY "Balance"
LIMIT 1 OFFSET (SELECT COUNT(*) FROM customer_churn) / 2;


--Finding the average Credit score:

SELECT 
ROUND(AVG("CreditScore"),2) AS avg_credit_score
FROM customer_churn;

--Finding the median(middle value) of Credit score:

SELECT "CreditScore" AS median_credit_score
FROM customer_churn
ORDER BY "CreditScore"
LIMIT 1 OFFSET (SELECT COUNT(*) FROM customer_churn) / 2;




-- Finding out the Key Metrics responsible for the customer churn using DDL and DML :-

/*
METRIC 1
Using DDL and DML commands in the Gender based information :-
*/

-- Creating a new Table gender_data :

CREATE TABLE gender_data (
    gender_type VARCHAR(20),
    exit_status INTEGER
);

-- Inserting the specific column data into new gender_data table :

INSERT INTO gender_data (gender_type, exit_status)
SELECT "Gender", "Exited" 
FROM customer_churn;

-- Finding the number of people exited based on Gender :

SELECT gender_type, SUM(exit_status)
FROM gender_data
GROUP BY gender_type;




/*
METRIC 2
Using DDL and DML commands to find out that which Category(Age and Balance) of people
are more likely to exit :-
*/

-- Creating a new Table age_balance_relation :

CREATE TABLE age_balance_relation (
age_group VARCHAR(20),
balance_category VARCHAR(20),
exit_status INT
);

-- Inserting the specific column data into new age_balance_relation table :

INSERT INTO age_balance_relation (age_group, balance_category, exit_status)
SELECT
CASE WHEN "Age" <= 30 THEN 'Youth'
WHEN "Age" <= 50 THEN 'Elder'
ELSE 'Senior' END,

CASE WHEN "Balance" <= 30000 THEN 'Low Balance'
WHEN "Balance" <= 50000 THEN 'Medium Balance'
ELSE 'High Balance' END,

"Exited"
FROM customer_churn;

-- Finding the number of people exited based on Age and Balance :

SELECT 
age_group,
SUM(CASE WHEN balance_category = 'Low Balance' THEN exit_status ELSE 0 END) AS low_bal_exits,
SUM(CASE WHEN balance_category = 'Medium Balance' THEN exit_status ELSE 0 END) AS med_bal_exits,
SUM(CASE WHEN balance_category = 'High Balance' THEN exit_status ELSE 0 END) AS high_bal_exits
FROM age_balance_relation
GROUP BY age_group;





/*
METRIC 3
Using DDL and DML commands to find out the high Salary people are buying more products
or low salary poeple are buying more products ? and what are there churn and staying rate:-
*/

-- Creating a new Table salary_product_analysis:

CREATE TABLE salary_product_analysis (
salary_category VARCHAR(20),
product_count INT,
exit_status INT
);

-- Inserting the specific column data into new salary_product_analysis table :

INSERT INTO salary_product_analysis (salary_category, product_count, exit_status)
SELECT 
CASE WHEN "EstimatedSalary" <= 100000 THEN 'Low Salary' ELSE 'High Salary' END,
"NumOfProducts", "Exited"
FROM customer_churn;

-- Finding the number of people exited based on salary and product quantity :

SELECT 
salary_category,
SUM(CASE WHEN product_count = 1 THEN exit_status ELSE 0 END) AS prod1_churned,
SUM(CASE WHEN product_count = 2 THEN exit_status ELSE 0 END) AS prod2_churned,
SUM(CASE WHEN product_count = 3 THEN exit_status ELSE 0 END) AS prod3_churned,
SUM(CASE WHEN product_count = 4 THEN exit_status ELSE 0 END) AS prod4_churned
FROM salary_product_analysis
GROUP BY salary_category;






/*
METRIC 4
Using DDL and DML commands in the :-
*/

-- Creating a new Table geo_analysis :

CREATE TABLE geo_analysis(
country VARCHAR(50), 
exit_status INT
);

-- Inserting the specific column data into new geo_analysis table :

INSERT INTO geo_analysis (country, exit_status) 
SELECT "Geography", "Exited" 
FROM customer_churn;


-- Finding the number of people exited based on Geography :

SELECT country, SUM(exit_status) AS exit_status 
FROM geo_analysis 
GROUP BY country
ORDER BY exit_status DESC;






/*
METRIC 5
Using DDL and DML commands to find out the insights from Credit Score :-
*/

-- Creating a new Table credit_analysis :

CREATE TABLE credit_analysis (
score VARCHAR(20), 
exit_status INT
);

ALTER TABLE credit_analysis 
ALTER COLUMN score TYPE VARCHAR(20);

-- Inserting the specific column data into new credit_analysis table :

INSERT INTO credit_analysis (score, exit_status)
SELECT CASE 
WHEN "CreditScore" < 500 THEN 'Poor'
WHEN "CreditScore" BETWEEN 500 AND 650 THEN 'Fair'
WHEN "CreditScore" BETWEEN 651 AND 750 THEN 'Good'
ELSE 'Excellent' END,
"Exited"
FROM customer_churn;

-- Finding the number of people exited based on Credit Score :

SELECT score, SUM(exit_status) AS total_exited
FROM credit_analysis
GROUP BY score
ORDER BY total_exited DESC;



-- Finding top 10 loyal customers who have High balance and active with the services :-

SELECT "CustomerId", "Geography", "Surname", "Balance", "CreditScore", "Tenure"
FROM (
SELECT 
"CustomerId", "Geography", "Surname", "Balance", "CreditScore", "Tenure", ROW_NUMBER() 
OVER(ORDER BY "Balance" DESC) as customer_rank
FROM customer_churn
WHERE "Exited" = 0 AND "IsActiveMember" = 1) AS ranked_table
WHERE customer_rank <= 10;

-- Finding the Negative customers who are having high balance but exited :-

SELECT "CustomerId", "Geography", "Surname", "Balance", "CreditScore", "Tenure"
FROM (
SELECT 
"CustomerId", "Geography", "Surname", "Balance", "CreditScore", "Tenure" ,ROW_NUMBER() 
OVER(ORDER BY "Balance" DESC) as loss_rank
FROM customer_churn
WHERE "Exited" = 1) AS ranked_losses
WHERE loss_rank <= 10;




-- Best Top 5 Customers to get the offer :-

WITH Customer_Scoring AS (
SELECT 
"CustomerId", "Surname", "Geography", "CreditScore", "Balance",
"Tenure", "NumOfProducts", "EstimatedSalary",
("CreditScore" + ("Balance"/1000) + ("Tenure"*10) + ("NumOfProducts"*50) + ("EstimatedSalary"/1000)) AS total_score
FROM customer_churn
WHERE "Exited" = 0 AND "IsActiveMember" = 1 AND "HasCrCard" = 1
)
SELECT 
vip_rank, "Surname", "Geography", "CreditScore", "Balance", 
"Tenure", "NumOfProducts", "EstimatedSalary", ROUND(total_score, 2) AS final_score
FROM (
SELECT *, DENSE_RANK() OVER(ORDER BY total_score DESC) as vip_rank
FROM Customer_Scoring
) AS ranked_list
WHERE vip_rank <= 5;

