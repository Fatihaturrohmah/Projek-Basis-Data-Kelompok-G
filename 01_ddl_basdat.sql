CREATE DATABASE marketplace1;
USE marketplace1;

-- 1. TABEL WILAYAH (Baru - Pecahan dari Tabel Alamat untuk 3NF)
CREATE TABLE wilayah (
    kode_pos VARCHAR(10) PRIMARY KEY,
    kota VARCHAR(100) NOT NULL,
    provinsi VARCHAR(100) NOT NULL
);

-- 2. TABEL PELANGGAN
CREATE TABLE pelanggan (
    id_pelanggan VARCHAR(10) PRIMARY KEY, -- Diubah jadi VARCHAR agar bisa membaca 'PLG-01'
    nama_pelanggan VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    no_telepon VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    status_akun VARCHAR(20) default 'aktif'
);

-- 3. TABEL ALAMAT
CREATE TABLE alamat (
    id_alamat VARCHAR(10) PRIMARY KEY,
    id_pelanggan VARCHAR(10) NOT NULL,
    nama_penerima VARCHAR(100) NOT NULL,
    no_hp VARCHAR(20),
    alamat_lengkap TEXT,
    kode_pos VARCHAR(10) NOT NULL,       -- Menjadi penghubung ke tabel wilayah
    is_utama BOOLEAN DEFAULT FALSE,-- Disesuaikan dengan data dummy ('Ya' / 'Tidak')

    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan),
    FOREIGN KEY (kode_pos) REFERENCES wilayah(kode_pos) -- Relasi ke tabel wilayah
);

-- 4. TABEL KATEGORI
CREATE TABLE kategori (
    id_kategori VARCHAR(10) PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL,
    deskripsi_kategori TEXT
);

-- 5. TABEL PRODUK
CREATE TABLE produk (
    id_produk VARCHAR(10) PRIMARY KEY,
    id_kategori VARCHAR(10) NOT NULL,
    nama_produk VARCHAR(150) NOT NULL,
    deskripsi_produk TEXT,
    harga_produk INT NOT NULL,
    stok INT NOT NULL,
    gambar_produk VARCHAR(255),
    status_produk VARCHAR(20),

    FOREIGN KEY (id_kategori) REFERENCES kategori(id_kategori)
);

-- 6. TABEL KERANJANG
CREATE TABLE keranjang (
    id_keranjang VARCHAR(10) PRIMARY KEY,
    id_pelanggan VARCHAR(10) NOT NULL,
   tanggal_dibuat DATE DEFAULT (CURRENT_DATE),

    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
);

-- 7. TABEL DETAIL KERANJANG
CREATE TABLE detail_keranjang (
    id_detail_keranjang VARCHAR(10) PRIMARY KEY,
    id_keranjang VARCHAR(10) NOT NULL,
    id_produk VARCHAR(10) NOT NULL,
    jumlah INT NOT NULL,

    FOREIGN KEY (id_keranjang) REFERENCES keranjang(id_keranjang),
    FOREIGN KEY (id_produk) REFERENCES produk(id_produk)
);

-- 8. TABEL PESANAN
CREATE TABLE pesanan (
    id_pesanan VARCHAR(10) PRIMARY KEY,
    id_pelanggan VARCHAR(10) NOT NULL,
    id_alamat VARCHAR(10) NOT NULL,
    tanggal_pesanan DATE DEFAULT (CURRENT_DATE),
    total_harga INT NOT NULL,
    status_pesanan VARCHAR(30),

    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan),
    FOREIGN KEY (id_alamat) REFERENCES alamat(id_alamat)
);

-- 9. TABEL DETAIL PESANAN
CREATE TABLE detail_pesanan (
    id_detail_pesanan VARCHAR(10) PRIMARY KEY,
    id_pesanan VARCHAR(10) NOT NULL,
    id_produk VARCHAR(10) NOT NULL,
    jumlah_beli INT NOT NULL,
    harga_satuan INT NOT NULL,
    subtotal INT NOT NULL,

    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan),
    FOREIGN KEY (id_produk) REFERENCES produk(id_produk)
);

-- 10. TABEL PEMBAYARAN
CREATE TABLE pembayaran (
    id_pembayaran VARCHAR(10) PRIMARY KEY,
    id_pesanan VARCHAR(10) NOT NULL,
    metode_pembayaran VARCHAR(50),
    tanggal_bayar DATE,
    jumlah_bayar INT,
    status_pembayaran VARCHAR(30),

    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan)
);

-- 11. TABEL PENGIRIMAN
CREATE TABLE pengiriman (
    id_pengiriman VARCHAR(10) PRIMARY KEY,
    id_pesanan VARCHAR(10) NOT NULL,
    kurir VARCHAR(50),
    nomor_resi VARCHAR(100),
    alamat_tujuan TEXT,
    tanggal_pengiriman DATE,
    status_pengiriman VARCHAR(30),

    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan)
);

-- 12. TABEL REVIEW
CREATE TABLE review (
    id_review VARCHAR(10) PRIMARY KEY, -- Diubah jadi VARCHAR untuk 'RVW-01' s.d 'RVW-15'
    id_pelanggan VARCHAR(10) NOT NULL,
    id_produk VARCHAR(10) NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    komentar TEXT,
    tanggal_review DATETIME DEFAULT (CURRENT_DATE),

    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan),
    FOREIGN KEY (id_produk) REFERENCES produk(id_produk)
);
