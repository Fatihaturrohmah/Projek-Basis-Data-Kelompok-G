-- 1 Buah FUNCTION
DELIMITER $$

CREATE FUNCTION fn_cek_loyalty_pelanggan (p_id_pelanggan VARCHAR(20))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE v_total_belanja INT DEFAULT 0;
    DECLARE v_status_loyalty VARCHAR(50);
    
    -- Menghitung total belanja pelanggan yang sukses (Selesai)
    SELECT IFNULL(SUM(total_harga), 0) INTO v_total_belanja
    FROM pesanan
    WHERE id_pelanggan = p_id_pelanggan AND status_pesanan = 'Selesai';
    
    -- Menentukan kategori tingkatan berdasarkan nominal belanja
    IF v_total_belanja >= 500000 THEN
        SET v_status_loyalty = 'Platinum Member';
    ELSEIF v_total_belanja >= 200000 THEN
        SET v_status_loyalty = 'Gold Member';
    ELSEIF v_total_belanja > 0 THEN
        SET v_status_loyalty = 'Silver Member';
    ELSE
        SET v_status_loyalty = 'New Member';
    END IF;
    
    RETURN v_status_loyalty;
END$$

DELIMITER ;

SELECT id_pelanggan, nama_pelanggan, fn_cek_loyalty_pelanggan(id_pelanggan) AS tingkatan_member 
FROM pelanggan;
