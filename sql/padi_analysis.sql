/* =====================================================
   SECTION 1: GMV BY SELLER CATEGORY
===================================================== */
-- Total GMV with finish status order, group by Seller Category
SELECT t_transaction.seller_category,
    SUM(total_price_order) AS total_GMV
FROM `revou-sql-class-402216.telkom_dataset.transaction` AS t_transaction
LEFT JOIN `revou-sql-class-402216.telkom_dataset.order` AS t_order
ON t_transaction.order_address_id = t_order.order_address_id
WHERE t_transaction.order_status = 'Selesai'
GROUP BY t_transaction.seller_category;

/* =====================================================
   SECTION 2: REVENUE
===================================================== */
SELECT SUM(revenue) AS total_revenue
FROM `revou-sql-class-402216.telkom_dataset.transaction`
WHERE order_status = 'Selesai';

/* =====================================================
   SECTION 3: NUMBER TRANSACTION
===================================================== */
SELECT COUNT(order_address_id) AS total_transaction,
FROM `revou-sql-class-402216.telkom_dataset.transaction`
WHERE order_status = 'Selesai'AND order_address_id IS NOT NULL; 

/* =====================================================
   SECTION 4: TAKE RATE
===================================================== */
WITH
order_gmv AS(
  SELECT order_address_id,
      SUM(total_price_order) AS GMV
  FROM `revou-sql-class-402216.telkom_dataset.order`
  GROUP BY order_address_id
  ),

table_base AS (
  SELECT SUM(order_gmv.GMV) AS total_GMV,
        SUM (t_transaction.revenue) AS total_revenue
  FROM `revou-sql-class-402216.telkom_dataset.transaction` AS t_transaction
  LEFT JOIN order_gmv
  ON t_transaction.order_address_id = order_gmv.order_address_id
  WHERE t_transaction.order_status = 'Selesai'
  )
SELECT (table_base.total_revenue/table_base.total_GMV)*100 AS take_rate
FROM table_base;

/* =====================================================
   SECTION 5: TOTAL USERS
===================================================== */
--registered_user
SELECT 
  (SELECT COUNT(DISTINCT uid_seller)FROM `revou-sql-class-402216.telkom_dataset.user_seller`) AS registered_seller,
  (SELECT COUNT(DISTINCT uid_buyer)FROM `revou-sql-class-402216.telkom_dataset.user_buyer`) AS registered_buyer;

--active_user
SELECT COUNT(DISTINCT seller_id) AS active_seller,
  COUNT(DISTINCT buyer_id) AS active_buyer
FROM `revou-sql-class-402216.telkom_dataset.transaction`;
