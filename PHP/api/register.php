<?php
require "../config/koneksi.php";

if($_SERVER['REQUEST_METHOD']=="POST"){
    #code
    $response = array();
    $email = $_POST['email'];
    $password = $_POST['password'];
    //var_dump($_POST);

    $cek = "SELECT * FROM data_user WHERE email='$email'";
    $ini = "INSERT INTO data_user (email, password) VALUES ('$email','$password')";
    $result = mysqli_query($con, $cek);

    if(mysqli_num_rows($result)===0){
        $insert = mysqli_query($con,$ini);
        //var_dump(mysqli_error($con));

        if (!$insert) {
            # code...
            $response['value']=0;
            $response['message'] = "Gagal didaftarkan";
            echo json_encode($response);
        } else {
            # code...
            $response['value']=1;
            $response['message'] = "Berhasil didaftarkan";
            
            $hasil = mysqli_query($con, $cek);
            while($fetchdata = mysqli_fetch_array($hasil)){
                $response['id_user'] = $fetchdata['id_user'];
            }
            echo json_encode($response);
        }
        
    }
    else{
        $response['value']=2;
        $response['message'] = "Email telah digunakan";
        echo json_encode($response);
    }
    
}

?>