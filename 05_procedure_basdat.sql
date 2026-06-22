  -- 1 Buah STORED PROCEDURE
DELIMITER //

CREATE PROCEDURE sp_laporan_pelanggan_by_provinsi(
    IN p_nama_provinsi VARCHAR(100) -- Parameter input provinsi sesuai panjang kolom Anda
)
BEGIN
    SELECT 
        p.id_pelanggan AS ID_Pelanggan,
        p.nama_pelanggan AS Nama_Pelanggan,
        w.provinsi AS Provinsi,
        COUNT(ps.id_pesanan) AS Jumlah_Transaksi,
        SUM(ps.total_harga) AS Total_Belanja
    FROM pelanggan p
    INNER JOIN alamat a ON p.id_pelanggan = a.id_pelanggan
    INNER JOIN wilayah w ON a.kode_pos = w.kode_pos
    INNER JOIN pesanan ps ON p.id_pelanggan = ps.id_pelanggan
    WHERE w.provinsi = p_nama_provinsi
    GROUP BY p.id_pelanggan, p.nama_pelanggan, w.provinsi
    ORDER BY Total_Belanja DESC;
END //

DELIMITER ;
CALL sp_laporan_pelanggan_by_provinsi('Jawa Tengah');
