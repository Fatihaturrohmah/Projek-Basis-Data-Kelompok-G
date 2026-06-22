-- 1. 10 Query SELECT (Kompleksitas Bertingkat)
-- A. 3 Query Sederhana
-- 1. menampilkan pelanggan yang menggunakan email dari gmail.com
select id_pelanggan, nama_pelanggan, email 
from pelanggan
where email like '%@gmail.com';
-- 2. menampilkan pesanan yang masuk lebih dulu (dari tanggal terlama)
select id_pesanan, tanggal_pesanan, total_harga, status_pesanan
from pesanan
order by tanggal_pesanan asc;
-- 3. menampilkan pembayaran yang sudah dibayarkan (=! 0) dengan jumlah bayar diurutkan dari yg terbesar
-- hanya menampilkan 5 baris teratas
select id_pembayaran, metode_pembayaran, jumlah_bayar, tanggal_bayar, status_pembayaran
from pembayaran
where jumlah_bayar <> 0
order by jumlah_bayar desc
limit 5;

-- B. 4 Query dengan JOIN (Minimal 3 Tabel)
-- 4. Menampilkan alamat pengiriman pesanan lengkap dengan kota dan provinsi untuk pesanan yang sudah 'Selesai'
SELECT 
	p.id_pesanan, 
    pl.nama_pelanggan, 
    a.alamat_lengkap, 
    w.kota, 
    w.provinsi
FROM pesanan p
JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
JOIN alamat a ON p.id_alamat = a.id_alamat
JOIN wilayah w ON a.kode_pos = w.kode_pos
WHERE p.status_pesanan = 'Selesai';

-- 5. menampilkan pesanan seorang pelanggan dan status pengirimannya
SELECT 
    p.id_pesanan,
    p.tanggal_pesanan,
    a.nama_penerima,
    a.no_hp,
    pg.kurir,
    pg.nomor_resi,
    a.alamat_lengkap,
    pg.status_pengiriman
FROM pesanan p
JOIN alamat a ON p.id_alamat = a.id_alamat
JOIN pengiriman pg ON p.id_pesanan = pg.id_pesanan;

-- 6. menampilkan pesanan dengan kategori, produk dan pembayarannya (hanya menampilkan status pembayaran yang lunas) 
SELECT 
    k.nama_kategori,
    pr.nama_produk,
    dp.jumlah_beli,
    dp.subtotal AS harga_item,
    pmb.metode_pembayaran,
    pmb.status_pembayaran
FROM detail_pesanan dp
JOIN produk pr ON dp.id_produk = pr.id_produk
JOIN kategori k ON pr.id_kategori = k.id_kategori
JOIN pembayaran pmb ON dp.id_pesanan = pmb.id_pesanan
WHERE pmb.status_pembayaran = 'Lunas';

-- 7.Menampilkan ulasan produk (review) yang diberikan oleh pelanggan lengkap dengan nama kategori produknya
SELECT 
	r.id_review, 
    pl.nama_pelanggan, 
    pr.nama_produk, 
    k.nama_kategori, 
    r.rating, 
    r.komentar
FROM review r
JOIN pelanggan pl ON r.id_pelanggan = pl.id_pelanggan
JOIN produk pr ON r.id_produk = pr.id_produk
JOIN kategori k ON pr.id_kategori = k.id_kategori;

-- C. 2 Query dengan Subquery atau CTE
-- 8. Menampilkan daftar produk yang harganya di atas rata-rata harga seluruh produk (Subquery)
SELECT id_produk, nama_produk, harga_produk, stok
FROM produk
WHERE harga_produk > (SELECT AVG(harga_produk) FROM produk);

-- 9. Menampilkan total belanja per pelanggan menggunakan CTE (Common Table Expression)
WITH TotalBelanjaPelanggan AS (
    SELECT id_pelanggan, SUM(total_harga) AS total_pengeluaran
    FROM pesanan
    WHERE status_pesanan = 'Selesai'
    GROUP BY id_pelanggan
)
SELECT p.id_pelanggan, p.nama_pelanggan, t.total_pengeluaran
FROM pelanggan p
JOIN TotalBelanjaPelanggan t ON p.id_pelanggan = t.id_pelanggan
ORDER BY t.total_pengeluaran DESC;

-- D. 1 Query dengan Fungsi Agregat & GROUP BY + HAVING
-- 10. Menampilkan kategori produk yang memiliki total pendapatan (subtotal selesai) lebih dari Rp 200.000
SELECT 
    k.nama_kategori, 
    COUNT(dp.id_produk) AS jumlah_produk_terjual,
    SUM(dp.subtotal) AS total_pendapatan
FROM detail_pesanan dp
JOIN produk pr ON dp.id_produk = pr.id_produk
JOIN kategori k ON pr.id_kategori = k.id_kategori
JOIN pesanan p ON dp.id_pesanan = p.id_pesanan
WHERE p.status_pesanan = 'Selesai'
GROUP BY k.nama_kategori
HAVING total_pendapatan > 200000;
