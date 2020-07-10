<?php
require "../config/koneksi.php";
// menyimpan data kedalam variabel
if($_SERVER['REQUEST_METHOD'] == "POST"){
    $response      = array();
    $id_user       = $_POST['id_user'];
    $url_foto      = $_POST['url_foto'];
    $tipe_makan    = $_POST['tipe_makan'];
    $nama_makanan  = $_POST['nama_makanan'];
    $berat_makanan = $_POST['berat_makanan'];
    $kalori        = $_POST['kalori'];
    $karbohidrat   = $_POST['karbohidrat'];
    $protein       = $_POST['protein'];
    $lemak         = $_POST['lemak'];
    $kolesterol    = $_POST['kolesterol'];
    $gula          = $_POST['gula'];
    $waktu         = $_POST['waktu'];
    $sudah_diproses= $_POST['sudah_diproses'];

    // query SQL untuk insert data
    $query="INSERT INTO `catatan_makanan` SET `id_user`='$id_user',`url_foto`='$url_foto',`tipe_makan`='$tipe_makan',
    `nama_makanan`='$nama_makanan',`berat_makanan`='$berat_makanan',`kalori`='$kalori',`karbohidrat`='$karbohidrat',
    `protein`='$protein',`lemak`='$lemak',`kolesterol`='$kolesterol',`gula`='$gula',`waktu`='$waktu',
    `sudah_diproses`='$sudah_diproses'";

    $hasil = mysqli_query($con, $query);
        if(isset($hasil)){
            $response['value']   = '1';
            $response['message'] = 'Catatan makanan telah ditambahkan';
            echo json_encode($response);
        } else{
                $response['value']   = '0';
                $response['message'] = 'Gagal menambahkan catatan makanan';
                echo json_encode($response);
        }
    }
?>