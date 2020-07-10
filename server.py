import pprint as pp
import numpy as np
import cv2
from darkflow.net.build import TFNet
import matplotlib.pyplot as plt
import mysql.connector

#variabel global
hasil_deteksi = ""
kalori = 0.0
karbohidrat = 0.0
protein = 0.0
lemak = 0.0
kolesterol = 0.0
gula = 0.0

def deteksi_makanan():
    #Deteksi foto jenis makanan
    options = {"model": "yolo-voc-makanan.cfg",
            #"load": -1,
            "gpu": 1.0,
            "threshold":0.01,
            "pbLoad":"yolo-voc-makanan.pb" ,
            "metaLoad":"yolo-voc-makanan.meta"
            }

    tfnet2 = TFNet(options)
    #tfnet2.load_from_ckpt()

    original_img = cv2.imread(url_foto)
    original_img = cv2.cvtColor(original_img, cv2.COLOR_BGR2RGB)
    results = tfnet2.return_predict(original_img)
    print(results)

    newImage = np.copy(original_img)
    for result in results:
        confidence = result['confidence']
        terbesar = np.argmax(confidence)

    
    print(terbesar)
    confidence_terbesar = results[terbesar]['confidence']   
    print(confidence_terbesar)

    global hasil_deteksi
    hasil_deteksi = results[terbesar]['label']
    label = results[terbesar]['label'] + " " + str(round(confidence_terbesar, 3))
    top_x = results[terbesar]['topleft']['x']
    top_y = results[terbesar]['topleft']['y']

    btm_x = results[terbesar]['bottomright']['x']
    btm_y = results[terbesar]['bottomright']['y']
    newImage = cv2.rectangle(newImage, (top_x, top_y), (btm_x, btm_y), (255,0,0), 3)
    newImage = cv2.putText(newImage, label, (top_x, top_y-5), cv2.FONT_HERSHEY_COMPLEX_SMALL , 0.8, (0, 230, 0), 1, cv2.LINE_AA)

    #fig, ax = plt.subplots(figsize=(20, 10))
    #ax.imshow(boxing(original_img, results))
    BGR_img = cv2.cvtColor(newImage, cv2.COLOR_RGB2BGR)
    #cv2.imshow("Hasil", BGR_img) 
    #cv2.waitKey(0)
    #cv2.destroyAllWindows()

    print(hasil_deteksi)

    

def kalkulasi_makronutrien():
    #Kalkulasi kalori dan makronutrien
    global kalori
    global karbohidrat
    global protein
    global lemak
    global kolesterol
    global gula
    mycursor = mydb.cursor()
    sql = "SELECT * FROM data_kalori_100gram WHERE nama_makanan = %s"
    val = (hasil_deteksi,)

    mycursor.execute(sql,val)
    data_kalori = mycursor.fetchall()
    for x in data_kalori:
        kalori = x[2] * berat / 100 
        karbohidrat = x[3] * berat / 100
        protein = x[4] * berat / 100
        lemak = x[5] * berat / 100
        kolesterol = x[6] * berat / 100
        gula = x[7] * berat / 100
    print(kalori)
    print(karbohidrat)
    print(protein)
    print(lemak)
    print(kolesterol)
    print(gula)

def simpan_catatan_makanan():    
    #Simpan data kalori ke database catatan makanan
    mycursor = mydb.cursor()
    sql = "UPDATE catatan_makanan SET nama_makanan = %s, kalori = %s, karbohidrat = %s, protein = %s, lemak = %s, kolesterol = %s, gula = %s, sudah_diproses = %s WHERE id_catatan = %s"
    val = (hasil_deteksi, kalori, karbohidrat, protein, lemak, kolesterol, gula, 1, id_catatan)
    mycursor.execute(sql,val)
    mydb.commit()



while(1):
    #Hubungkan ke Mysql
    mydb = mysql.connector.connect(
        host="localhost",
        user="root",
        passwd="",
        database="protel"
    )

    #Cek apakah ada request utk proses deteksi
    mycursor = mydb.cursor()
    mycursor.execute("SELECT * FROM catatan_makanan WHERE sudah_diproses='0'")
    akan_diproses = mycursor.fetchall()
    for x in akan_diproses:
        id_catatan = x[0]
        url_foto = x[2]
        berat = x[5]
        deteksi_makanan()
        kalkulasi_makronutrien()
        simpan_catatan_makanan()





