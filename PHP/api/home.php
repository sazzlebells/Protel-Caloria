<?php
    require "../config/koneksi.php";
//belum cek
    if($_SERVER['REQUEST_METHOD'] == "POST"){
        $response   = array();
        $id_user    = $_POST['id_user'];
        $waktu      = $_POST['waktu'];

        $lihat      = "SELECT `tipe_makan`,`nama_makanan`,`kalori`,`karbohidrat`,`protein`,`lemak`,`waktu` 
                    FROM `catatan_makanan` WHERE `id_user`='$id_user' and `waktu`='$waktu'";
        $hasil      = mysqli_query($con, $lihat);

        if (!$hasil) {
            printf("Error: %s\n", mysqli_error($con));
            exit();
        }
        if(isset($hasil)){
            while ($fetchdata = mysqli_fetch_array($hasil)){
                $response[]  = $fetchdata;      
            }
            echo json_encode($response);
        }
        else{
            echo json_decode('ERROR');
        }
    }
?>
   