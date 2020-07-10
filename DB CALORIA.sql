-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Host: 10.4.1.107:3306
-- Generation Time: May 27, 2020 at 09:58 AM
-- Server version: 10.4.13-MariaDB
-- PHP Version: 7.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u639542248_note_deep`
--

-- --------------------------------------------------------

--
-- Table structure for table `catatan_makanan`
--

CREATE TABLE `catatan_makanan` (
  `id_catatan` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `url_foto` text NOT NULL,
  `tipe_makan` int(11) NOT NULL,
  `nama_makanan` varchar(45) NOT NULL,
  `berat_makanan` float NOT NULL,
  `kalori` float NOT NULL,
  `karbohidrat` float NOT NULL,
  `protein` float NOT NULL,
  `lemak` float NOT NULL,
  `kolesterol` float NOT NULL,
  `gula` float NOT NULL,
  `waktu` datetime NOT NULL,
  `sudah_diproses` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `catatan_makanan`
--

INSERT INTO `catatan_makanan` (`id_catatan`, `id_user`, `url_foto`, `tipe_makan`, `nama_makanan`, `berat_makanan`, `kalori`, `karbohidrat`, `protein`, `lemak`, `kolesterol`, `gula`, `waktu`, `sudah_diproses`) VALUES
(1, 1001, 'img/tumpeng1.jpg', 1, 'ayam goreng', 100, 260, 10.76, 21.93, 14.55, 57, 0.26, '2020-04-09 00:00:00', 1),
(2, 1001, 'img/tumpeng1.jpg', 1, 'nasi putih', 100, 129, 27.9, 2.66, 0.28, 0, 0.05, '2020-04-09 00:00:00', 1),
(3, 1001, 'img/tumpeng1.jpg', 2, 'nasi putih', 200, 258, 55.8, 5.32, 0.56, 0, 0.1, '2020-04-09 00:00:00', 1),
(4, 1001, 'img/tumpeng1.jpg', 3, 'nasi putih', 50, 64.5, 13.95, 1.33, 0.14, 0, 0.025, '2020-04-09 00:00:00', 1),
(5, 1001, 'img/tumpeng1.jpg', 2, 'pecel', 300, 387, 83.7, 7.98, 0.84, 0, 0.15, '2020-04-09 00:00:00', 1),
(6, 1001, 'img/tumpeng1.jpg', 3, 'telur ceplok', 350, 451.5, 97.65, 9.31, 0.98, 0, 0.175, '2020-04-09 00:00:00', 1),
(11, 1002, '', 2, 'mie goreng', 321, 332, 3, 4, 42, 2, 21, '2020-04-21 08:18:15', 1),
(13, 1002, 'img/ayamgoreng1.jpg', 1, 'ayam goreng', 100, 45, 45, 45, 45, 45, 45, '2020-04-16 03:58:18', 1),
(14, 1023, 'img/ayamgoreng1.jpg', 6, 'pecel', 100, 45, 45, 45, 45, 45, 45, '2020-04-23 00:00:00', 1),
(15, 1023, 'https://b401telematics.com/Deep/img/.jpg', 2, 'test3', 100, 0, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0),
(16, 1023, 'https://b401telematics.com/Deep/img/foto_2020-04-23 16:04:14.116597.jpg', 2, 'test4', 100, 463, 40.04, 15.63, 30.38, 0, 31.68, '2020-04-23 00:00:00', 0),
(18, 1001, 'https://b401telematics.com/Deep/img/foto_2020-04-26 21:16:48.617692.jpg', 2, 'pecel', 100, 463, 40.04, 15.63, 30.38, 0, 31.68, '2020-04-26 00:00:00', 0),
(19, 1013, 'https://b401telematics.com/Deep/img/foto_2020-04-26 21:19:21.077936.jpg', 3, 'nasi putih', 100, 463, 40.04, 15.63, 30.38, 0, 31.68, '2020-04-26 00:00:00', 0),
(20, 1013, 'https://b401telematics.com/Deep/img/foto_2020-04-29 22:59:12.014420.jpg', 2, 'ayam goreng', 100, 463, 40.04, 15.63, 30.38, 0, 31.68, '2020-04-29 00:00:00', 0),
(21, 1013, 'https://b401telematics.com/Deep/img/foto_2020-05-09 13:39:46.472408.jpg', 1, 'ayam', 377, 0, 0, 0, 0, 0, 0, '2020-05-09 00:00:00', 0),
(26, 1013, 'https://www.a.com', 1, 'nasi putih', 200, 424, 100, 80, 30, 12, 22, '2020-05-27 14:41:59', 0),
(27, 1013, 'https://www.a.com', 2, 'tempe goreng', 40, 50, 16, 37, 10, 11, 7, '2020-05-27 14:41:59', 0);

-- --------------------------------------------------------

--
-- Table structure for table `data_kalori_100gram`
--

CREATE TABLE `data_kalori_100gram` (
  `id_makanan` int(11) NOT NULL,
  `nama_makanan` varchar(45) NOT NULL,
  `kalori` float NOT NULL,
  `karbohidrat (gram)` float NOT NULL,
  `protein (gram)` float NOT NULL,
  `lemak (gram)` float NOT NULL,
  `kolesterol (miligram)` float NOT NULL,
  `gula (gram)` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `data_kalori_100gram`
--

INSERT INTO `data_kalori_100gram` (`id_makanan`, `nama_makanan`, `kalori`, `karbohidrat (gram)`, `protein (gram)`, `lemak (gram)`, `kolesterol (miligram)`, `gula (gram)`) VALUES
(1, 'ayam goreng', 260, 10.76, 21.93, 14.55, 57, 0.26),
(2, 'lele goreng', 240, 8.54, 17.57, 14.53, 69, 0.85),
(3, 'mie goreng', 527, 57.54, 8.38, 30.76, 0, 0.26),
(4, 'nasi goreng', 168, 21.06, 6.3, 6.23, 52, 0.76),
(5, 'nasi putih', 129, 27.9, 2.66, 0.28, 0, 0.05),
(6, 'pecel', 463, 40.04, 15.63, 30.38, 0, 31.68),
(7, 'pisang', 89, 22.84, 1.09, 0.33, 0, 12.23),
(8, 'tahu goreng', 271, 10.49, 17.19, 20.18, 0, 2.72),
(9, 'telur ceplok', 201, 0.88, 13.63, 15.31, 457, 0.83),
(10, 'tempe goreng', 225, 11.94, 13.31, 15.21, 0, 0.18);

-- --------------------------------------------------------

--
-- Table structure for table `data_user`
--

CREATE TABLE `data_user` (
  `id_user` int(11) NOT NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `nama_user` varchar(45) DEFAULT NULL,
  `tanggal_lahir` date NOT NULL DEFAULT '0000-00-00',
  `jenis_kelamin` int(11) DEFAULT NULL,
  `tinggi_badan` float DEFAULT 0,
  `berat_badan` float NOT NULL DEFAULT 0,
  `target` int(11) NOT NULL DEFAULT 0,
  `aktivitas` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `data_user`
--

INSERT INTO `data_user` (`id_user`, `email`, `password`, `nama_user`, `tanggal_lahir`, `jenis_kelamin`, `tinggi_badan`, `berat_badan`, `target`, `aktivitas`) VALUES
(1001, 'hhh@gmail.com', '1234', 'tina', '1998-07-20', 2, 160, 45, 2, 1),
(1002, 'ddd@gmail.com', '4321', 'ddd', '2020-04-12', 0, 0, 0, 0, 0),
(1003, 'qwe@rty.com', '1111', 'winyon', '0000-00-00', 0, 0, 0, 0, 0),
(1006, 'rrr@gmail.com', '1234', 'toni', '2002-06-11', 1, 170, 76, 0, 2),
(1013, 'w', '1', 'momo', '1998-09-22', 2, 165, 45, 1, 3),
(1023, 'a', 'a', 'ayu', '2005-04-03', 0, 150, 45, 1, 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `catatan_makanan`
--
ALTER TABLE `catatan_makanan`
  ADD PRIMARY KEY (`id_catatan`);

--
-- Indexes for table `data_kalori_100gram`
--
ALTER TABLE `data_kalori_100gram`
  ADD PRIMARY KEY (`id_makanan`);

--
-- Indexes for table `data_user`
--
ALTER TABLE `data_user`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `catatan_makanan`
--
ALTER TABLE `catatan_makanan`
  MODIFY `id_catatan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `data_kalori_100gram`
--
ALTER TABLE `data_kalori_100gram`
  MODIFY `id_makanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `data_user`
--
ALTER TABLE `data_user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1024;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
