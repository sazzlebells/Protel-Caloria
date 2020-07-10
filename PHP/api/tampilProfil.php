<?php
    require "../config/koneksi.php";
    
    if($_SERVER['REQUEST_METHOD'] == "POST"){
        $response      = array();
        $id_user       = $_POST['id_user'];

        $profil        = "SELECT `email`,`nama_user`,`tanggal_lahir`,`jenis_kelamin`,`tinggi_badan`,
                        `berat_badan`,`target`,`aktivitas` 
                        FROM `data_user` WHERE `id_user`='$id_user'";
        $hasil         = mysqli_query($con,$profil);

        if (!$hasil) {
            printf("Error: %s\n", mysqli_error($con)); //ubah ini dari $koneksi
            exit();
        }
        if(isset($hasil)){
            while ($fetchdata = mysqli_fetch_array($hasil)){
                $response[] = $fetchdata;      
            }
            echo json_encode($response);
        }
        else{
            echo json_decode('ERROR');
        }
    
    }
?>