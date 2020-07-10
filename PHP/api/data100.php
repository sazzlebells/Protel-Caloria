<?php
    require "../config/koneksi.php";
    
    if($_SERVER['REQUEST_METHOD'] == "POST"){
        $response      = array();
        $id_makanan       = $_POST['id_makanan'];

        $query        = "SELECT * FROM `data_kalori_100gram` WHERE `id_makanan`='$id_makanan'";
        $hasil         = mysqli_query($con,$query);

        if (!$hasil) {
            printf("Error: %s\n", mysqli_error($con));
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