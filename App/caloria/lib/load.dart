import 'package:flutter/material.dart';
import 'package:caloria/vars.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoadPage extends StatefulWidget {
  LoadPage({this.id});
  final String id;

  @override
  _LoadPageState createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  // String link = "http://192.168.42.64/protel/"; //USB tethering
  // String link = "http://192.168.43.46/protel/"; //localhost wifi
  // String link = "https://b401telematics.com/Deep/api/"; //hosting
  String link = "http://komputer-its.com/Winyon/api/"; //hosting

  List data = [];
  DateTime now = DateTime.now();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    final response = await http
        .post(link + 'tampilProfil.php', body: {"id_user": widget.id});

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
        print(data);

        name = data[0]['nama_user'];
        gender = data[0]['jenis_kelamin'] == "1" ? "Male" : "Female";
        birthdate = data[0]['tanggal_lahir'].toString();
        height = data[0]['tinggi_badan'];
        weight = data[0]['berat_badan'];

        switch (data[0]['aktivitas']) {
          case "1":
            actLevel = "Sedentary";
            break;
          case "2":
            actLevel = "Low Active";
            break;
          case "3":
            actLevel = "Active";
            break;
          case "4":
            actLevel = "Very Active";
            break;
          case "5":
            actLevel = "Extra Active";
            break;
          default:
            actLevel = "0";
            break;
        }

        switch (data[0]['target']) {
          case "1":
            goal = "Lose Weight";
            break;
          case "2":
            goal = "Maintain Weight";
            break;
          case "3":
            goal = "Gain Weight";
            break;
          default:
            goal = "0";
            break;
        }

        //Hitung Umur
        tglSkrg = now.toString().split(" ")[0];
        tgl = int.parse(tglSkrg.split("-")[2]);
        bln = int.parse(tglSkrg.split("-")[1]);
        thn = int.parse(tglSkrg.split("-")[0]);
        tglLahir = int.parse(birthdate.split("-")[2]);
        blnLahir = int.parse(birthdate.split("-")[1]);
        thnLahir = int.parse(birthdate.split("-")[0]);
        //print(thnLahir);
        age = thn - thnLahir;
        if (blnLahir > bln) {
          age--;
        } else if (bln == blnLahir) {
          if (tglLahir > tgl) {
            age--;
          }
        }
        ages = age.toString();

        //==========================HITUNG TOTAL KALORI HARIAN
        //Rumus Mifflin-St Jeor
        data[0]['jenis_kelamin'] == "1"
            ? bmr = 10 * (double.parse(weight)) +
                6.2 * (double.parse(height)) -
                5 * age +
                5 //male
            : bmr = 10 * (double.parse(weight)) +
                6.2 * (double.parse(height)) -
                5 * age -
                161; //female

        switch (data[0]['aktivitas']) {
          case "1":
            totalCal = bmr * 1.2;
            break;
          case "2":
            totalCal = bmr * 1.375;
            break;
          case "3":
            totalCal = bmr * 1.55;
            break;
          case "4":
            totalCal = bmr * 1.725;
            break;
          case "5":
            totalCal = bmr * 1.9;
            break;
          default:
            totalCal = 0;
            break;
        }
        if (data[0]['target'] == "1") {
          totalCal = totalCal - 450;
        } else if (data[0]['target'] == "3") {
          totalCal = totalCal + 450;
        }
        print(totalCal);

        totalCarb = 0.65 * totalCal / 4;
        totalPro = 0.15 * totalCal / 4;
        totalFat = 0.2 * totalCal / 9;
      });

      ambilData();
    }
  }

  void ambilData() async {
    final response1 = await http.post(link + 'tampilCatatan.php', body: {
      "id_user": widget.id,
      "waktu" : DateTime.now().toString().split(" ")[0]
    });
    if (response1.statusCode == 200) {
      setState(() {
        data = json.decode(response1.body);
        print("Data masuk: " + data.length.toString());
        cal=0;
        carb=0;
        pro=0;
        fat=0;
        chol=0;
        sgr=0;
      });

      hitung();
    }
  }

  void hitung() async {
    for (var i = 0; i < data.length; i++) {
      setState(() {
          cal   = cal + double.parse(data[i]["kalori"]);
          carb  = carb + double.parse(data[i]["karbohidrat"]);
          pro   = pro + double.parse(data[i]["protein"]);
          fat   = fat + double.parse(data[i]["lemak"]);
          chol  = chol + double.parse(data[i]["kolesterol"]);
          sgr   = sgr + double.parse(data[i]["gula"]);

        calPercent = cal/totalCal;
        carbPercent = carb/totalCarb;
        proPercent = pro/totalPro;
        fatPercent = fat/totalFat;

        loading = false;
      });
    }
    print(cal);
    print(carb);
    print(pro);
    print(fat);
    print(chol);
    print(sgr);
    print(calPercent);
    print(carbPercent);
    print(proPercent);
    print(fatPercent);
  }


  @override
  Widget build(BuildContext context) {
    return loading 
      ? Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator()
          )
        ) 
      : Navigator.of(context).popAndPushNamed('/home');
  }
}