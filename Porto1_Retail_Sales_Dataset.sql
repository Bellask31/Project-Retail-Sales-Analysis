SELECT * FROM retail_sales_dataset;
-- A. DATA CLEANING & PREPARATION
-- Mengubah nama kolom sesuai format
ALTER TABLE retail_sales_dataset
  RENAME COLUMN `Transaction ID` TO Transaction_ID,
  RENAME COLUMN `Date` TO Transaction_Date,
  RENAME COLUMN `Customer ID` TO Customer_ID,
  RENAME COLUMN `Product Category` TO Product_Category,
  RENAME COLUMN `Price per Unit` TO Price_perUnit,
  RENAME COLUMN `Total Amount` TO Total_Amount;
SELECT * FROM retail_sales_dataset;
-- Cek data kosong/null
SELECT
    MAX(CASE WHEN Transaction_ID IS NULL OR Transaction_ID = '' THEN 1 ELSE 0 END) AS Null_Transaction_ID,
    MAX(CASE WHEN Transaction_Date IS NULL THEN 1 ELSE 0 END) AS Null_Transaction_Date,
    MAX(CASE WHEN Customer_ID IS NULL OR Customer_ID = '' THEN 1 ELSE 0 END) AS Null_Customer_ID,
	MAX(CASE WHEN Gender IS NULL OR Gender = '' THEN 1 ELSE 0 END) AS Null_Gender,
    MAX(CASE WHEN Age IS NULL OR Age = '' THEN 1 ELSE 0 END) AS Null_Age,
    MAX(CASE WHEN Product_Category IS NULL OR Product_Category = '' THEN 1 ELSE 0 END) AS Null_Product_Category,
    MAX(CASE WHEN Quantity IS NULL OR Quantity = '' THEN 1 ELSE 0 END) AS Null_Quantity,
    MAX(CASE WHEN Price_perUnit IS NULL OR Price_perUnit = '' THEN 1 ELSE 0 END) AS Null_Price_perUnit,
    MAX(CASE WHEN Total_Amount IS NULL OR Total_Amount = '' THEN 1 ELSE 0 END) AS Null_Total_Amount
FROM retail_sales_dataset;
-- Cek duplikasi 
-- a) Cek duplikasi primary key = Transaction_ID
SELECT Transaction_ID, COUNT(*) AS Jumlah_Duplikasi
FROM retail_sales_dataset
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;
-- b) Cek duplikasi seluruh kolom
SELECT Transaction_Date, Customer_ID, Gender, Age, Product_Category, Quantity, Price_perUnit, Total_Amount,
       COUNT(*) AS jumlah
FROM retail_sales_dataset
GROUP BY Transaction_Date, Customer_ID, Gender, Age, Product_Category, Quantity, Price_perUnit, Total_Amount
HAVING jumlah > 1;
-- Format Data
-- a) mengubah Transaction_Date jadi format Date
ALTER TABLE retail_sales_dataset
MODIFY COLUMN Transaction_Date DATE;
DESCRIBE retail_sales_dataset; 


-- B. EKSPLORASI DATA
-- 1) Statistika Deskriptif
-- Kolom Numerik (Age, Quantity, Price per Unit, Total Amount)
SELECT
    'Age' AS Variable,
    COUNT(Age) AS Count,
    AVG(Age) AS Mean,
    MIN(Age) AS Min,
    MAX(Age) AS Max,
    STDDEV(Age) AS StdDev,
    VARIANCE(Age) AS Variance
FROM retail_sales_dataset
UNION ALL
SELECT
    'Quantity',
    COUNT(Quantity),
    AVG(Quantity),
    MIN(Quantity),
    MAX(Quantity),
    STDDEV(Quantity),
    VARIANCE(Quantity)
FROM retail_sales_dataset
UNION ALL
SELECT
    'Price_perUnit',
    COUNT(Price_perUnit),
    AVG(Price_perUnit),
    MIN(Price_perUnit),
    MAX(Price_perUnit),
    STDDEV(Price_perUnit),
    VARIANCE(Price_perUnit)
FROM retail_sales_dataset
UNION ALL
SELECT
    'Total_Amount',
    COUNT(Total_Amount),
    AVG(Total_Amount),
    MIN(Total_Amount),
    MAX(Total_Amount),
    STDDEV(Total_Amount),
    VARIANCE(Total_Amount)
FROM retail_sales_dataset;
-- Kolom kategorik (Gender dan Produk Category)
SELECT 
    Gender,
    COUNT(*) AS total_transaksi,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM retail_sales_dataset), 2) AS proporsi_persen
FROM retail_sales_dataset
GROUP BY Gender;

SELECT 
    Product_Category,
    COUNT(*) AS total_transaksi,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM retail_sales_dataset), 2) AS proporsi_persen
FROM retail_sales_dataset
GROUP BY Product_Category;
-- Waktu di Data
SELECT min(Transaction_Date) AS Min_Transaksi, max(Transaction_Date) AS Max_Transaksi
FROM retail_sales_dataset;
-- Total Transaksi 
SELECT COUNT(*) AS Total_Transaksi
FROM retail_sales_dataset;

SELECT 
    DATE_FORMAT(Transaction_Date, '%Y-%m') AS Bulan,
    COUNT(*) AS jumlah_transaksi
FROM retail_sales_dataset
GROUP BY Bulan
ORDER BY Bulan;









