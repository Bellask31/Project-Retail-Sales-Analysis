# Retail Sales Data Analysis
Proyek ini bertujuan untuk menganalisis data penjualan retail menggunakan kombinasi SQL dan Python. Langkah-langkah yang dilakukan meliputi data cleaning, data preparation, exploratory data analysis (EDA), hingga visualisasi untuk menemukan insight dari dataset.
## Dataset
- Sumber : Retail Sales Dataset (https://www.kaggle.com/datasets/mohammadtalib786/retail-sales-dataset?)
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
- Clothing: kuantitas terjual tertinggi (894 unit) dengan total revenue 155.580 → rata-rata harga per unit 174,03.
- Electronics: kuantitas 849 unit dengan total revenue tertinggi 156.905 → rata-rata harga per unit 184,81.
- Beauty: kuantitas paling rendah (771 unit) dengan revenue 143.515 → rata-rata harga per unit 186,14.  

**Insight:**
- Clothing menjadi volume driver karena paling laku dari sisi kuantitas, Electronics berperan sebagai revenue driver karena menyumbang pendapatan terbesar meski kuantitasnya lebih sedikit, sedangkan Beauty menjadi margin driver karena memiliki harga rata-rata per unit yang lebih tinggi meski total transaksinya lebih kecil.  

**B. Bagaimana transaksi tiap bulannya? Apakah ada pola tertentu, seperti saat liburan?**  
**Tujuan:** Menganalisis grafik frekuensi transaksi dan total revenue, untuk mendeteksi adanya pola musiman.  
<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1hu01OGsME06ECJnJpK4TQ4I-8XA3oJbt" alt="Frekuensi Transaksi vs Pendapatan Bulanan" width="45%"/>
  <img src="https://drive.google.com/uc?export=view&id=1TqHNlzHZOaloSffRDZczRpc_ENhZAJFn" alt="Produk Terjual per Kategori Bulanan" width="45%"/>
</p>  

**Deskripsi:**  
- Data menunjukkan frekuensi transaksi dan total pendapatan bulanan sepanjang 2023. Terlihat adanya fluktuasi baik dari sisi jumlah transaksi maupun revenue.  
- Lonjakan signifikan terjadi pada bulan Mei (105 transaksi, revenue 53.150), Oktober (96 transaksi, revenue 46.580), dan Desember (91 transaksi, revenue 44.690). Sebaliknya, penurunan tajam juga terjadi di Maret (73 transaksi, revenue 28.990) dan September (65 transaksi, revenue 23.620).  
- Pola item yang terjual tiap bulannya tampak konsisten di seluruh kategori produk, hanya saja dominasi kategori berbeda setiap bulannya.  
- Secara umum, semakin banyak transaksi maka revenue ikut naik. Akan tetapi, nilai produk yang terjual juga memiliki peran penting. Contohnya, bulan Desember jumlah transaksi lebih sedikit (91) dibandingkan dengan bulan Agustus (94), tetapi revenue bulan Desember lebih tinggi dibandingkan Agustus karena lebih banyak produk dengan harga mahal (seperti electronics) yang terjual dibulan tersebut.

**Insight:**
- Terdapat indikasi kuat bahwa lonjakan transaksi cenderung bertepatan di bulan dengan event besar, seperti promo mid year atau diskon awal musim dibulan Mei, "autumn sale" atau mid-quarter campaign pada bulan Oktober, dan promo natal dan tahun baru dibulan Desember.
- Clothing sering menjadi penyumbang volume terbesar di awal tahun (, electronics mendominasi di pertengahan hingga akhir tahun (produk bernilai tinggi), sedangkan beauty lebih stabil namun tidak sekuat dua kategori lainnya.  
- Hubungan antara banyak transaksi dan revenue tidak selalu berbanding lurus. Ada bulan dengan transaksi tinggi namun revenue tidak naik secara drastis karena item yang terjual lebih banyak produk murah dan sebaliknya. Jadi, revenue ini dipengaruhi oleh dua hal : banyaknya transaksi dan nilai rata-rata pertransaksi.

**C. Pria atau wanita yang dominan berbelanja? Produk apa saja yang dominan banyak dibeli pria dan wanita? Pria atau wanita yang dominan lebih banyak mengeluarkan uang?**  
**Tujuan:** Memahami perbedaan perilaku belanja antara pria dan wanita yang hasilnya bisa digunakan untuk menyusun strategi pemasaran yang lebih tepat sasaran sesuai dengan karakteristik konsumen.  
<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1iU4av95lfXOYXft3XQsB1euAfR-eUofN" alt="Frekuensi Transaksi vs Pendapatan Bulanan" width="45%"/>
  <img src="https://drive.google.com/uc?export=view&id=1jZ3SIrljEfAf5uZG0WpcTXyE5HZbtP-q" alt="Produk Terjual per Kategori Bulanan" width="45%"/>
</p>  

**Deskripsi:**  
- Dari sisi jumlah transaksi, wanita melakukan lebih banyak transaksi (510 transaksi) dibandingkan pria (490 transaksi).
- Clothing mendominasi transaksi pada kedua gender. Perbedaan keduanya adalah wanita cenderung memiliki pola pembelian yang lebih seimbang antara clothing (174), electronics (170), dan beauty (166) yang menunjukkan variasi kebutuhan yang lebih luas. Sedangkan, pria lebih dominan membeli clothing (177) dibanding kategori lain, walau electronics (172) juga cukup tinggi. Ini mengindikasikan pria lebih fokus pada kebutuhan praktis, dengan tambahan pembelian barang elektronik.
- Dari sisi pengeluaran, baik pria maupun wanita punya distribusi pengeluaran yang hampir mirip. Artinya, total belanja mereka tidak jauh berbeda. Akan tetapi, secara median wanita cenderung mengeluarkan lebih banyak uang per transaksi dibanding pria

**Insight:**  
- Dari data, jumlah transaksi wanita (510) sedikit lebih tinggi daripada pria (490). Artinya, wanita cenderung lebih aktif dalam melakukan pembelian, meskipun selisih keduanya tidak terlalu besar.
- Transaksi pria ataupun wanita sama-sama didominasi oleh transaksi clothing (pria 177, wanita 174). Karena jumlahnya paling dominan di kedua gender, clothing bisa dianggap sebagai kebutuhan dasar yang dibeli semua orang, bukan spesifik hanya salah satu gender.
- Boxplot menunjukkan median pengeluaran wanita lebih besar dibandingkan pria. Hal ini logis karena wanita juga cukup banyak membeli produk beauty (166 transaksi vs pria 141), sementara produk beauty cenderung punya harga rata-rata lebih mahal per item dibandingkan dengan produk lain.
- Meskipun wanita lebih aktif dalam bertransaksi dan median pengeluarannya sedikit lebih tinggi, pria juga cukup banyak membeli produk electronics yang memiliki harga cukup tinggi per item sehingga strategi pemasaran sebaiknya diarahkan ke keduanya dengan penekanan yang berbeda.

**D. Jika usia dikelompokkan (Remaja, Dewasa, Orang Tua) kelompok mana yang paling banyak bertransaksi? Produk apa yang paling dominan dibeli tiap kelompok usia? Kelompok mana yang dominan mengeluarkan banyak uang?**  
**Tujuan:** Memahami perbedaan perilaku belanja berdasarkan kelompok usia yang hasilnya bisa digunakan untuk menyusun strategi pemasaran yang lebih tepat sasaran sesuai dengan karakteristik konsumen.  
<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1ZyofETllcLN0Z9r-n2Ov8EYvtwqAoX4p" alt="Frekuensi Transaksi vs Pendapatan Bulanan" width="45%"/>
  <img src="https://drive.google.com/uc?export=view&id=1-AVVhs9_iA1jiobwpLWB_7EGBiMe6YWT" alt="Produk Terjual per Kategori Bulanan" width="45%"/>
</p>  

**Deskripsi:**  
- Kelompok lansia (424)  dan juga dewasa (407) yang terlihat paling banyak melakukan transaksi, sedangkan remaja jauh lebih sedikit (169).
- Produk dominan yang dibeli lansia dan orang dewasa adalah clothing, lalu electronics, dan yang paling sedikit adalah beauty. Sedangkan, remaja cenderung memiliki pembelian produk yang seimbang antara beauty, clothing, dan electronics, meskipun beauty sedikit lebih tinggi.
- Dari boxplot, remaja dan dewasa memiliki distribusi pengeluaran yang lebih besar dibandingkan lansia. Pengeluaran remaja bahkan terlihat memiliki median yang lebih tinggi dibandingkan dengan dua kelompok lainnya. Lansia cenderung lebih rendah baik median maupun sebarannya.  

**Insight:**  
- Kelompok dewasa merupakan kelompok yang paling aktif berbelanja dan menyumbang volume transaksi terbesar, terutama di clothing. Hal ini logis karena kelompok dewasa memiliki daya beli yang stabil dan kebutuhan fashion yang tinggi (kerja, gaya hidup, dan acara sosial).
- Remaja memiliki daya beli yang besar meskipun jumlah transaksinya paling sedikit dibandingkan dua kelompok lainnya. Meskipun mereka jarang berbelanja, sekalinya berbelanja mereka cenderung mengeluarkan lebih banyak uang. Hal ini bisa disebabkan faktor tren, keinginan gaya hidup, atau pembelian barang bernilai tinggi (contohnya : beauty).
- Lansia tetap aktif meskipun mereka cenderung hemat. Jumlah transaksi lansia paling tinggi, namun nominal pengeluarannya lebih rendah. Lansia mungkin lebih sering membeli kebutuhan rutin dalam nominal kecil.
- Clothing menjadi produk lintas usia karena clothing yang paling mendominasi transaksi ketiga kelompok yang menunjukkan pakaian merupakan kebutuhan universal. Beauty lebih menonjol di kelompok remaja, sedangkan electronics terbagi relatif merata di semua kelompok.


**E. Apakah 20% transaksi menyumbang 80% revenue?**  
**Tujuan:** Mengetahui apakah sebagian kecil transaksi justru menghasilkan sebagian besar pendapatan.
![Pareto chart](https://drive.google.com/uc?id=1nAsstjnOlbElJXpD80fMwm1MjXX72m6T)  
**Deskripsi:**  
- Grafik menunjukkan bahwa 20% transaksi pertama belum mencapai 80% revenue. Revenue kumulatif pada 20% transaksi hanya hanya sekitar ~60%-70% dari total pendapatan yang berarti pola 80/20 (pareto principle) tidak berlaku sempurna pada data ini.

**Insight:**  
- Prinsip pareto tidak berlaku di data tersebut, 20% transaksi hanya menyumbang 60%-70% revenue sehingga distribusi revenue lebih merata. Artinya, tidak hanya sedikit transaksi besar yang mendominasi, namun banyak transaksi kecil yang juga berperan penting dalam pendapatan total.  

### 4. **Recommendation**
- Strategi produk : Dikarenakan clothing menjadi volume driver, electronics sebagai revenue driver, dan beauty sebagai margin driver, perusahaan sebaiknya menjaga keberlanjutan stok clothing untuk menjaga traffic, memperkuat promosi electronics karena kontribusi pendapatannya cukup besar, serta menempatkan beauty sebagai produk premium dengan strategi bundling atau upselling agar margin tetap tinggi meski kuantitasnya lebih kecil.
- Pola bulanan : Jika terdapat lonjakan transaksi di bulan tertentu (misalnya liburan, akhir tahun, atau momen diskon besar), perusahaan bisa memanfaatkan pola musiman dengan menyiapkan stok lebih banyak, memberikan diskon bundling, dan meningkatkan iklan digital menjelang periode puncak agar revenue makin optimal.
- Segmentasi gender : Wanita menunjukkan perilaku belanja yang lebih merata di semua kategori (Clothing, Beauty, Electronics), sehingga strategi promosi sebaiknya tidak hanya fokus pada Beauty saja. Beauty memang bisa tetap diarahkan secara agresif ke wanita karena kontribusinya dominan dari sisi gender, tetapi Clothing juga perlu didorong dengan kampanye fashion dan tren musiman, sedangkan Electronics bisa diposisikan sebagai bagian dari gaya hidup modern wanita. Untuk pria, Clothing masih menjadi pintu utama karena volume pembeliannya tinggi, namun peluang cross-selling ke Electronics juga besar. Dengan kata lain, wanita adalah segmen “triple potential” yang harus disentuh dengan strategi holistik, sedangkan pria bisa difokuskan ke kategori dominan sambil perlahan diarahkan ke produk bernilai lebih tinggi.
- Segmentasi usia : dengan dewasa dan lansia sebagai kelompok transaksi terbesar, fokus pemasaran perlu diarahkan pada kebutuhan dan preferensi mereka, terutama untuk clothing dan electronics. Sementara itu, strategi khusus untuk remaja dapat diarahkan pada promosi beauty dan electronics, sekaligus memanfaatkan fakta bahwa mereka memiliki median pengeluaran tertinggi meskipun jumlah transaksinya lebih kecil.
- Manajemen kontribusi transaksi : Analisis menunjukkan 20% transaksi tidak menyumbang 80% revenue, sehingga pola Pareto klasik tidak berlaku di sini. Artinya, pendapatan perusahaan tidak hanya bergantung pada segelintir high-value customers, tetapi juga ditopang oleh volume transaksi massal dari pelanggan reguler. Karena itu, strategi bisnis perlu seimbang: tetap melakukan retensi untuk pelanggan bernilai besar, namun jangan abai terhadap engagement pelanggan rutin yang jumlahnya besar. Program loyalitas, diskon berkala, atau bundling produk bisa menjaga keberlanjutan transaksi massal ini, sehingga revenue tetap stabil sekaligus membuka peluang kenaikan jangka panjang.

## Conclusion
Hasil analisis menunjukkan bahwa pendapatan perusahaan ditopang oleh kombinasi volume (clothing), nilai per unit (beauty), dan total revenue (electronics). Pola transaksi bulanan dipengaruhi jenis produk yang laku, bukan sekadar jumlah transaksi. Preferensi konsumen juga bervariasi menurut gender dan usia, sehingga strategi pemasaran perlu menyesuaikan segmen. Karena revenue tidak terpusat hanya pada 20% transaksi, menjaga volume transaksi massal sama pentingnya dengan merawat pelanggan bernilai tinggi. Perusahaan perlu strategi seimbang untuk menguatkan kinerja dan mendorong pertumbuhan berkelanjutan.
