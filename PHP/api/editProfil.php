<?php
   require "../config/koneksi.php";
   if($_SERVER['REQUEST_METHOD'] == "POST"){

   $response      = array();
   $id_user       = $_POST['id_user'];
   $nama_user     = $_POST['nama_user'];
   $tanggal_lahir = $_POST['tanggal_lahir'];
   $jenis_kelamin = $_POST['jenis_kelamin'];
   $tinggi_badan  = $_POST['tinggi_badan'];
   $berat_badan   = $_POST['berat_badan'];
   $target        = $_POST['target'];
   $aktivitas     = $_POST['aktivitas'];

   $query         ="UPDATE `data_user` SET  `nama_user`='$nama_user',`tanggal_lahir`='$tanggal_lahir',
                    `jenis_kelamin`='$jenis_kelamin',`tinggi_badan`='$tinggi_badan', `berat_badan`='$berat_badan',
                    `target`='$target',`aktivitas`='$aktivitas'
                    WHERE `id_user`='$id_user'";
   $hasil         = mysqli_query($con, $query);
   
   #if(!(mysqli_query($con, $query))) {
   #   printf("Error: %s\n", mysqli_error($con));
   #   exit();
   #}
   
      if(!$hasil){
         $response['value']   = '0';
         $response['message'] = 'Gagal memperbarui profil';
         echo json_encode($response);
      } else{
         $response['value']   = '1';
         $response['message'] = 'Profil berhasil diperbarui';
         echo json_encode($response);
      }
   }
?>