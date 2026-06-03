create database cust_db;

use cust_db;

select * from customer_shopping_behavior;

ALTER TABLE customer_shopping_behavior
CHANGE `ï»¿Customer ID` cust_id INT;

# Check repeated customers
SELECT cust_id, COUNT(*) AS repeat_count
FROM customer_shopping_behavior
GROUP BY cust_id
HAVING COUNT(*) > 1;


# Check null values
SELECT
  SUM(CASE WHEN cust_id IS NULL THEN 1 ELSE 0 END) AS null_cust_id,
  SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS null_age,
  SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
  SUM(CASE WHEN `Item Purchased` IS NULL THEN 1 ELSE 0 END) AS null_item_purchased,
  SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS null_category,
  SUM(CASE WHEN `Purchase Amount (USD)` IS NULL THEN 1 ELSE 0 END) AS null_purchase_amount_usd,
  SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS null_location,
  SUM(CASE WHEN Size IS NULL THEN 1 ELSE 0 END) AS null_size,
  SUM(CASE WHEN Color IS NULL THEN 1 ELSE 0 END) AS null_color,
  SUM(CASE WHEN Season IS NULL THEN 1 ELSE 0 END) AS null_season,
  SUM(CASE WHEN `Review Rating` IS NULL THEN 1 ELSE 0 END) AS null_review_rating,
  SUM(CASE WHEN `Subscription Status` IS NULL THEN 1 ELSE 0 END) AS null_subscription_status,
  SUM(CASE WHEN `Shipping Type` IS NULL THEN 1 ELSE 0 END) AS null_shipping_type,
  SUM(CASE WHEN `Discount Applied` IS NULL THEN 1 ELSE 0 END) AS null_discount_applied,
  SUM(CASE WHEN `Promo Code Used` IS NULL THEN 1 ELSE 0 END) AS null_promo_code_used,
  SUM(CASE WHEN `Previous Purchases` IS NULL THEN 1 ELSE 0 END) AS null_previous_purchases,
  SUM(CASE WHEN `Payment Method` IS NULL THEN 1 ELSE 0 END) AS null_payment_method,
  SUM(CASE WHEN `Frequency of Purchases` IS NULL THEN 1 ELSE 0 END) AS null_frequency_of_purchases
FROM customer_shopping_behavior;

ALTER TABLE customer_shopping_behavior
CHANGE COLUMN `Purchase Amount (USD)` purchase_amount_usd INT,
CHANGE COLUMN `Review Rating` review_rating DOUBLE,
CHANGE COLUMN `Previous Purchases` previous_purchases INT,
CHANGE COLUMN `Item Purchased` item_purchased TEXT,
CHANGE COLUMN `Shipping Type` shipping_type TEXT,
CHANGE COLUMN `Payment Method` payment_method TEXT,
CHANGE COLUMN `Frequency of Purchases` frequency_of_purchases TEXT,
CHANGE COLUMN `Discount Applied` discount_applied TEXT,
CHANGE COLUMN `Promo Code Used` promo_code_used TEXT,
CHANGE COLUMN `Subscription Status` subscription_status TEXT;


ALTER TABLE customer_shopping_behavior
ADD COLUMN age_group VARCHAR(10),
ADD COLUMN purchase_frequency_score DECIMAL(5,2);

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_shopping_behavior
SET age_group = CASE
    WHEN Age > 0 AND Age <= 18 THEN '0-18'
    WHEN Age > 18 AND Age <= 25 THEN '19-25'
    WHEN Age > 25 AND Age <= 35 THEN '26-35'
    WHEN Age > 35 AND Age <= 45 THEN '36-45'
    WHEN Age > 45 AND Age <= 55 THEN '46-55'
    WHEN Age > 55 AND Age <= 100 THEN '56+'
    ELSE NULL
END;

UPDATE customer_shopping_behavior
SET purchase_frequency_score = CASE
    WHEN frequency_of_purchases = 'Weekly' THEN 4
    WHEN frequency_of_purchases = 'Fortnightly' THEN 2
    WHEN frequency_of_purchases = 'Bi-Weekly' THEN 2
    WHEN frequency_of_purchases = 'Monthly' THEN 1
    WHEN frequency_of_purchases = 'Quarterly' THEN 0.33
    WHEN frequency_of_purchases = 'Every 3 Months' THEN 0.33
    WHEN frequency_of_purchases = 'Annually' THEN 0.08
    ELSE NULL
END;
