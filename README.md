# Retail Sales Data Analysis
Proyek ini bertujuan untuk menganalisis data penjualan retail menggunakan kombinasi SQL dan Python. Langkah-langkah yang dilakukan meliputi data cleaning, data preparation, exploratory data analysis (EDA), hingga visualisasi untuk menemukan insight dari dataset.
## Dataset
- Sumber : Retail Sales Dataset
- Jumlah data : 1.000 entri
- Variabel utama : Transaction_ID, Transaction_Date, Customer_ID, Gender, Age, Product_Category, Quantity, Price_perUnit, Total_Amount
## Tools & Teknologi
- **SQL** : Querying, Agregasi (COUNT,AVG,MIN,MAX, dll + GROUP BY), Advanced Aggregation (Union All), Subquery, Data Cleaning & Preparation.
- **Python** : Pandas, Matplotlib, Seaborn
## Workflow Proyek
### 1. **Data Cleaning & Preparation (SQL)**
Data cleaning & preparation dilakukan untuk memastikan dataset bebas dari duplikasi, nilai kosong, dan inkonsistensi, serta memiliki format yang sesuai sehingga siap digunakan untuk analisis lebih lanjut.

**A. Mengetahui kolom-kolom pada data**
Langkah awal adalah mengecek isi data dan struktur tabel untuk mengetahui kolom apa saja yang tersedia dalam dataset.
 ```-- 
SELECT * FROM retail_sales_dataset; 
``` 
```
DESCRIBE retail_sales_dataset;
```
**Hasil :**
Dataset memiliki kolom dan type data seperti Transaction ID (int), Date (text), Customer ID (text), Gender (text), Age (int), Product Category (text), Price per Unit (int), dan Total Amount (int).

**B. Menyesuaikan format data**
- **Mengubah Nama Kolom**
Beberapa nama kolom masih menggunakan spasi dan kata kunci SQL sehingga perlu diubah agar lebih konsisten dan sesuai standar SQL
```
ALTER TABLE retail_sales_dataset
  RENAME COLUMN `Transaction ID` TO Transaction_ID,
  RENAME COLUMN `Date` TO Transaction_Date,
  RENAME COLUMN `Customer ID` TO Customer_ID,
  RENAME COLUMN `Product Category` TO Product_Category,
  RENAME COLUMN `Price per Unit` TO Price_perUnit,
  RENAME COLUMN `Total Amount` TO Total_Amount;
SELECT * FROM retail_sales_dataset;
```
**Hasil :** Nama kolom berhasil diubah menjadi format yang sesuai dengan SQL sehingga lebih mudah digunakan pada query berikutnya.
- **Mengubah Jenis Kolom**
Kolom 'Transaction_Date' diubah ke tipe DATE agar dapat digunakan untuk analisis berbasis waktu.
``` ALTER TABLE retail_sales_dataset
MODIFY COLUMN Transaction_Date DATE;
```
**Hasil :** Transaction_Date kini bertipe DATE, sehingga fungsi tanggal (misalnya MIN(), MAX(), DATE_FORMAT()) dapat diterapkan.

**C. Mengecek Data Kosong/Null**
Pengecekan dilakukan pada setiap kolom untuk memastikan tidak ada data kosong atau NULL.
```
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
```
**Hasil :** Apabila pada tabel menunjukkan nilai 1, maka terdapat data kosong. Sedangkan, jika tabel menunjukkan nilai 0, maka kolom bersih dari nilai kosong/null. Pada data yang digunakan kali ini, semua kolom menunjukkan nilai 0. Artinya, setiap kolom bersih dari nilai kosong/null.

**D. Mengecek Duplikasi**
- **Berdasarkan Primary Key (Transaction_ID)**
Tujuannya adalah memastikan bahwa setiap transaksi itu memiliki ID yang unik. Apabila terdapat ID yang muncul lebih dari sekali, artinya terdapat masalah di sistem pencatatan karena transaksi seharusnya unik.
```
SELECT Transaction_ID, COUNT(*) AS Jumlah_Duplikasi
FROM retail_sales_dataset
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;
```
**Hasil :** Jika query ini menghasilkan output, maka terdapat transaksi dengan Transaction_ID ganda (duplikat). Pada data yang digunakan kali ini, tidak terdapat output yang artinya tidak ada transaksi dengan Transaction_ID ganda (duplikat)
- **Berdasarkan Seluruh Kolom**
Sebelumnya telah dilakukan cek duplikasi berdasarkan primary key. Selanjutnya, akan dilakukan cek duplikasi berdasarkan seluruh kolom untuk mendeteksi baris yang benar-benar identik di semua kolom. Apabila terdapat baris yang sama persis muncul lebih dari sekali, artinya ada redundansi data.
```
SELECT Transaction_Date, Customer_ID, Gender, Age, Product_Category, Quantity, Price_perUnit, Total_Amount,
       COUNT(*) AS jumlah
FROM retail_sales_dataset
GROUP BY Transaction_Date, Customer_ID, Gender, Age, Product_Category, Quantity, Price_perUnit, Total_Amount
HAVING jumlah > 1;
```
**Hasil :** Jika query menghasilkan output, berarti terdapat baris yang identik lebih dari sekali pada dataset (seluruh nilai kolom sama persis, meskipun Transaction_ID berbeda). Pada data yang digunakan kali ini, tidak terdapat output yang artinya tidak ada transaksi yang dicurigai identik.

### 2. **Exploratory Data Analysis (SQL)**
Exploratory Data Analysis (EDA) menggunakan SQL berfokus pada statistika deskriptif untuk memahami karakteristik awal dataset. Tujuannya adalah mendapatkan gambaran umum tentang data sebelum dilakukan analisis lanjutan atau visualisasi.
**A. Analisis Waktu Transaksi**
```
SELECT min(Transaction_Date) AS Min_Transaksi, max(Transaction_Date) AS Max_Transaksi
FROM retail_sales_dataset;
```
**Hasil :** Dataset mencakup transaksi mulai dari tanggal terendah (Min) hingga tanggal tertinggi (Max), sehingga kita tahu periode transaksi dari data yang dimiliki. Transaksi pertama pada data adalah 01/01/2023 dan transaksi terakhir pada data adalah 01/01/2024.
**B. Analisis Kolom Numerik**
```
SELECT
    'Age' AS Variable, COUNT(Age) AS Count, AVG(Age) AS Mean, MIN(Age) AS Min,
    MAX(Age) AS Max, STDDEV(Age) AS StdDev, VARIANCE(Age) AS Variance
FROM retail_sales_dataset
UNION ALL
SELECT
    'Quantity', COUNT(Quantity), AVG(Quantity), MIN(Quantity), MAX(Quantity),
    STDDEV(Quantity), VARIANCE(Quantity)
FROM retail_sales_dataset
UNION ALL
SELECT
    'Price_perUnit', COUNT(Price_perUnit), AVG(Price_perUnit), 
    MIN(Price_perUnit),MAX(Price_perUnit), 
    STDDEV(Price_perUnit), VARIANCE(Price_perUnit)
FROM retail_sales_dataset
UNION ALL
SELECT
    'Total_Amount', COUNT(Total_Amount), AVG(Total_Amount), MIN(Total_Amount),
    MAX(Total_Amount), STDDEV(Total_Amount), VARIANCE(Total_Amount)
FROM retail_sales_dataset;
```
**Hasil :** Tabel ini merangkum jumlah data, rata-rata, nilai minimum & maksimum, serta ukuran sebaran (standar deviasi, variansi) dari setiap kolom numerik.
**C. Analisis Kolom Kategorik**
- **Gender**
```
SELECT 
    Gender,
    COUNT(*) AS total_transaksi,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM retail_sales_dataset), 2) AS proporsi_persen
FROM retail_sales_dataset
GROUP BY Gender;
```
**Hasil :** Memberikan jumlah transaksi berdasarkan Gender dan proporsinya terhadap keseluruhan dataset. Dengan hasil Total jumlah transaksi perempuan lebih banyak dibandingkan dengan laki-laki.
- **Gender**
```
SELECT 
    Product_Category,
    COUNT(*) AS total_transaksi,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM retail_sales_dataset), 2) AS proporsi_persen
FROM retail_sales_dataset
GROUP BY Product_Category;
```
**Hasil:** Menunjukkan kategori produk mana yang paling banyak berkontribusi dalam penjualan. Produk clothing memiliki jumlah transaksi paling banyak yang diikuti oleh electronics dan beauty. 
### 3. **Exploratory Data Analysis (Python)**
Pada tahap ini, analisis dilakukan menggunakan Python dengan tujuan menjawab beberapa pertanyaan utama melalui visualisasi data. Berikut adalah link coding with Python : 

**A. Produk apa yang paling laku & menyumbang pemasukan paling besar?**  
**Tujuan:** Mengetahui produk dengan kuantitas terjual terbanyak dan produk yang menyumbang revenue terbesar.  
![Visualisasi Total Penjualan Per Produk](https://drive.google.com/uc?id=1b6HVgp_8XjEH4G7D9i3wx8gzpwory9qW)  
**Deskripsi:**
- Clothing: kuantitas terjual tertinggi (894 unit) dengan total revenue Rp155.580 → rata-rata Rp174,03 per unit.
- Electronics: kuantitas 849 unit dengan total revenue tertinggi Rp156.905 → rata-rata Rp184,81 per unit.
- Beauty: kuantitas paling rendah (771 unit) dengan revenue Rp143.515 → rata-rata Rp186,14 per unit.  

**Insight:**
- Dari sisi kuantitas, clothing menjadi produk yang paling laku sehingga clothing berperan sebagai volume driver yang menjaga traffic penjualan.
- Dari sisi total revenue, electronics unggul tipis dibandingkan clothing sehingga electronics menjadi revenue driver karena menghasilkan pendapatan total terbesar.
- Dari sisi nilai rata-rata per unit, Beauty justru tertinggi, walaupun kuantitas terjualnya paling sedikit sehingga beauty adalah margin driver karena tiap unitnya paling bernilai, namun membutuhkan strategi pemasaran lebih kuat agar penjualannya meningkat

Clothing menjadi produk yang paling laku. Disusul oleh produk Electronics, sementara Beauty berada di urutan terakhir. Namun, jika dilihat dari total revenue, justru Electronics menyumbang pemasukan terbesar, yaitu sekitar 156.905, sedikit lebih tinggi dibandingkan Clothing yang mencapai 155.580. Sementara itu, Beauty tertinggal jauh dengan total revenue 143.515. Hal ini menunjukkan bahwa meskipun jumlah penjualan Electronics lebih sedikit daripada Clothing, harga per unit produk elektronik jauh lebih tinggi, sehingga mampu mendongkrak total revenue.

Secara sederhana, Clothing unggul dari sisi volume penjualan, sedangkan Electronics unggul dari sisi nilai revenue. Produk Beauty berada di posisi terlemah karena kalah baik dari sisi jumlah unit terjual maupun kontribusi revenue.

**B. Bagaimana transaksi tiap bulannya? Apakah ada pola tertentu, seperti saat liburan?**
**C. Pria atau wanita yang dominan berbelanja? Produk apa saja yang dominan banyak dibeli pria dan wanita? Pria atau wanita yang dominan lebih banyak mengeluarkan uang?**
**D. Jika usia dikelompokkan (Remaja, Dewasa, Orang Tua) kelompok mana yang paling banyak bertransaksi? Produk apa yang paling dominan dibeli tiap kelompok usia? Kelompok mana yang dominan ngeluarin banyak uang?**
**E. Apakah 20% transaksi menyumbang 80% revenue?**
### 4. **Insight & Finding**
## Kesimpulan

