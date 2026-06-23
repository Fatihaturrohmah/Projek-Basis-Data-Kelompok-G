CREATE TABLE log_keamanan (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_pelanggan VARCHAR(10),
    aksi VARCHAR(50),
    tanggal_kejadian DATETIME DEFAULT NOW()
);

DELIMITER $$

CREATE TRIGGER trg_audit_perubahan_password
AFTER UPDATE ON pelanggan
FOR EACH ROW
BEGIN
    -- Logika: Hanya mencatat JIKA kolom password mengalami perubahan
    IF OLD.password <> NEW.password THEN
        INSERT INTO log_keamanan (id_pelanggan, aksi)
        VALUES (NEW.id_pelanggan, 'Pelanggan mengganti password akun');
    END IF;
END$$

DELIMITER ;

UPDATE pelanggan SET password = 'password_baru_123' WHERE id_pelanggan = 'PLG-01';
SELECT * FROM log_keamanan;
