-- VIEW 1: Menampilkan ringkasan performa penjualan produk secara real-time
CREATE OR REPLACE VIEW view_performa_produk AS
SELECT 
    p.id_produk,
    p.nama_produk,
    p.harga_produk,
    p.stok AS sisa_stok,
    IFNULL(SUM(dp.jumlah_beli), 0) AS total_terjual,
    IFNULL(SUM(dp.subtotal), 0) AS total_omset,
    IFNULL(ROUND(AVG(r.rating), 1), 0) AS rata_rata_rating
FROM produk p
LEFT JOIN detail_pesanan dp ON p.id_produk = dp.id_produk
LEFT JOIN pesanan ps ON dp.id_pesanan = ps.id_pesanan AND ps.status_pesanan = 'Selesai'
LEFT JOIN review r ON p.id_produk = r.id_produk
GROUP BY p.id_produk, p.nama_produk, p.harga_produk, p.stok;
SELECT * from view_performa_produk;

-- VIEW 2: Menampilkan ringkasan pesanan pelanggan beserta status pembayaran dan pengirimannya
CREATE OR REPLACE VIEW view_ringkasan_transaksi AS
SELECT 
    p.id_pesanan,
    pl.nama_pelanggan,
    p.tanggal_pesanan,
    p.total_harga,
    p.status_pesanan,
    IFNULL(pmb.metode_pembayaran, 'Belum Pilih') AS metode_bayar,
    IFNULL(pmb.status_pembayaran, 'Menunggu') AS status_bayar,
    IFNULL(pg.kurir, 'Belum Diproses') AS kurir_pengirim,
    IFNULL(pg.status_pengiriman, 'Belum Dikirim') AS status_kirim
FROM pesanan p
JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
LEFT JOIN pembayaran pmb ON p.id_pesanan = pmb.id_pesanan
LEFT JOIN pengiriman pg ON p.id_pesanan = pg.id_pesanan;

SELECT * from view_ringkasan_transaksi;
DELIMITER $$
