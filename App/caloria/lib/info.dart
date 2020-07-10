import 'package:caloria/drawer.dart';
import 'package:flutter/material.dart';
//dart files
import 'package:caloria/vars.dart';
import 'drawer.dart';

class InfoPage extends StatefulWidget {
  InfoPage({this.id});
  final String id;

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String info1 =
      "     Caloria adalah aplikasi Android yang berfungsi untuk membantu pencatatan konsumsi kalori, makronutrien, dan gula harian agar lebih akurat. Dibuat oleh RAWR Studio pada tahun 2020.";
  String info2 =
      "Anggota :\n- Robby Aldriyanto Raffly - 07211740000011\n- Rama Yusuf Mahendra  - 07211740000013\n- Winnona Sarah T. R. G.  - 07211740000016";
  String info3 =
      "     Perhitungan konsumsi kalori maksimum harian dihitung berdasarkan Rumus Mifflin-St. Jeor, dengan variabel tambahan berupa kadar aktivitas harian dan juga target diet.";
  String rumusMale = "BMR = (10W + 6.25H + 5A + 5)*AL +/- G";
  String rumusFemale = "BMR = (10W + 6.25H + 5A - 161)*AL +/- G";
  String ket =
      "W: Weight(kg), H: Height(cm), A: Age, AL: Activity Level, G: Goal";
  String info4 =
      "     Perhitungan konsumsi karbohidrat, protein, dan lemak harian adalah berdasarkan Kementrian Kesehatan Indonesia. Sedangkan perhitungan konsumsi kolesterol harian adalah berdasarkan American Heart Association (AHA). Dengan perhitungan seperti berikut:";
  String rumusMax =
      "- Carbs       : 65%*totalCalories/4\n- Protein    : 15%*totalCalories/4\n- Lemak     : 20%*totalCalories/9\n- Kolestrol : 6%*totalCalories";
  String info5 =
      "     Status BMI menggunakan rekomendasi Asia-Pacific Task Force dengan ketentuan sebagai berikut: \n- Underweight      <18.5\n- Normal            18.5-22.9\n- Overweight      23-24.9\n- Obese I             25-29.9\n- Obese II              >=30";
  String info7 =
      "     Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacus massa, rhoncus et sem ac, sagittis venenatis diam. Nam et sapien at est imperdiet ornare a a est. Vivamus massa ipsum, vestibulum in consequat vel, rutrum non nulla. Donec ut eros scelerisque, hendrerit massa in, viverra nisl. Integer sit amet ex blandit, tristique nisl ac, tincidunt dui. Morbi vel libero pretium, bibendum dolor et, hendrerit tortor. Sed vitae elit nec mauris ornare bibendum. Pellentesque urna metus, iaculis ut placerat a, viverra ac urna. Ut eget semper libero.";
  String info8 =
      "     Integer nec laoreet nulla. Fusce consectetur ut sem ut condimentum. Sed id accumsan odio. Proin ut condimentum velit. Sed a turpis nec turpis fringilla ultricies. Nam rutrum mauris in euismod sodales. Interdum et malesuada fames ac ante ipsum primis in faucibus. Phasellus interdum egestas ullamcorper. Sed tincidunt nulla a diam faucibus, quis efficitur sapien vestibulum. Etiam egestas ipsum eu tellus maximus, eget egestas dui pharetra. Curabitur ac commodo diam. Ut blandit sagittis tortor nec auctor.";
  String info6 =
      "\n\n     Quisque aliquam feugiat leo, eget feugiat purus porta eget. Nulla dolor leo, pretium sed luctus at, tempus vel ante. Ut hendrerit sem lacus, ut eleifend magna volutpat et. Nam blandit est vitae neque semper placerat. Nam dapibus ipsum nisi, a viverra tortor ullamcorper sit amet.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Information",
              style: TextStyle(
                  color: Color.fromARGB(999, 243, 233, 210),
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold)),
        ),
        body: ListView(
          padding: EdgeInsets.all(35),
          children: [
            Text(info1, textAlign: TextAlign.justify),
            SizedBox(height: 10),
            Text(info2, textAlign: TextAlign.justify),
            SizedBox(height: 10),
            Text(info3, textAlign: TextAlign.justify),
            SizedBox(height: 10),
            Text("  Male"),
            Card(
              color: Color.fromARGB(999, 243, 233, 210),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(rumusMale, textAlign: TextAlign.center),
              ),
            ),
            Text("  Female"),
            Card(
              color: Color.fromARGB(999, 243, 233, 210),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(rumusFemale, textAlign: TextAlign.center),
              ),
            ),
            Text(ket, style: TextStyle(fontSize: 11)),
            SizedBox(height: 10),
            Text(info4, textAlign: TextAlign.justify),
            SizedBox(height: 10),
            Text(rumusMax, textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(info5, textAlign: TextAlign.left),
          ],
        ),
        drawer: Drawer(
          child: DrawerFill(id: widget.id),
        ));
  }
}

/*
menghitung total cal pakai Rumus Mifflin-St Jeor

max daily dose
-carb       : 65%*totalCa/4 //
-protein    : 15%*totalCal/4 //
-fat        : 20%*totalCal/9  //based on Kementrian Kesehatan Indonesia
-cholesterole: 6%*totalCal  //based on American Heart Association (AHA)

bmi (kg/m2) as recommended by the Asia-Pacific Task Force
underweight <18.5
normal 18.5-22.9
overweight 23-24.9
obese i 25.0-29.9
obese ii >=30

*/
