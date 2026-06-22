CREATE TABLE log_keamanan (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_pelanggan VARCHAR(10),
    aksi VARCHAR(50),
    tanggal_kejadian DATETIME DEFAULT NOW()
);

DELIMITER $$

CREATE TRIGGER trg_audit_perubahan_password

