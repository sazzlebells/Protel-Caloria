<?php
    define('HOST', 'localhost');
    define('USER', 'u639542248_deep');
    define('PASS', '12345');
    define('DB','u639542248_note_deep');
    
    $con = mysqli_connect(HOST, USER, PASS, DB) or die("Tidak bisa melakukan koneksi");
    //echo 'connected to database';
    //echo ' ';

?>