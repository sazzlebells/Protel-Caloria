<?php
require "../config/koneksi.php";

if($_SERVER['REQUEST_METHOD']=="POST"){
    #code
    $response = array();
    $email = $_POST['email'];
    $password = $_POST['password'];
    //var_dump($_POST);

    $cek = "SELECT * FROM `data_user` WHERE email='$email' and password='$password'";
    $result = mysqli_query($con, $cek);

    if(mysqli_num_rows($result)===0){
        $response['value']=0;
        $response['message'] = "Login gagal";
        echo json_encode($response);
    }
    else{
        $response['value']=1;
        $response['message'] = "Login berhasil";
        
        while($fetchdata = mysqli_fetch_array($result))
        {
            $response['id_user'] = $fetchdata['id_user'];
        }
        echo json_encode($response);
    }
    
}

?>