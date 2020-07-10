import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//dart files
import 'drawer.dart';
import 'package:caloria/vars.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.id});
  final String id;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // String name = '';
  // String gender = '';
  // String actLevel = '';
  // String goal = '';
  // String height = '';
  // String weight = '';
  // String birthdate = '';
  // double bmr = 0;
  DateTime now = DateTime.now();
  // String tglSkrg = '';
  // String ages = '';
  // int age = 0,
  //     tgl = 0,
  //     bln = 0,
  //     thn = 0,
  //     tglLahir = 0,
  //     blnLahir = 0,
  //     thnLahir = 0;

  List data = [];
  final List<String> itemsProfil = [
    "NAME",
    "BIRTHDATE",
    "AGE",
    "GENDER",
    "ACTIVITY LEVEL",
    "GOAL",
    "HEIGHT",
    "WEIGHT"
  ];

  final List<String> isiProfil = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];

  @override
  void initState() {
    isiProfil[0] = name;
    isiProfil[1] = birthdate;
    isiProfil[2] = ages;
    isiProfil[3] = gender;
    isiProfil[4] = actLevel;
    isiProfil[5] = goal;
    isiProfil[6] = height;
    isiProfil[7] = weight;
    print(isiProfil);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile',
            style: TextStyle(
              color: Color.fromARGB(999, 243, 233, 210),
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
            )),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              color: Color.fromARGB(999, 243, 233, 210),
              onPressed: () {
                Navigator.of(context).pushNamed('/signup');
              })
        ],
      ),
      drawer: Drawer(
        child: DrawerFill(id: widget.id),
      ),
      body: Visibility(
        visible: isiProfil.isNotEmpty ? true : false,
        child: ListView(
          padding: EdgeInsets.all(35),
          children: [
            isiData(itemsProfil[0], isiProfil[0]),
            isiData(itemsProfil[1], isiProfil[1]),
            isiData(itemsProfil[2], isiProfil[2]),
            isiData(itemsProfil[3], isiProfil[3]),
            isiData(itemsProfil[4], isiProfil[4]),
            isiData(itemsProfil[5], isiProfil[5]),
            isiData(itemsProfil[6], isiProfil[6] + ' cm'),
            isiData(itemsProfil[7], isiProfil[7] + ' kg'),
            Card(
                color: Color.fromARGB(999, 198, 218, 191),
                child: AnimatedContainer(
                    duration: Duration(seconds: 2),
                    margin: EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[
                      Text("Rekomendasi Kalori Harian",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(999, 17, 75, 95),
                              fontSize: 18)),
                      Text(
                        totalCal.toStringAsFixed(2) + " kalori",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ])))
          ],
        ),
      ),
    );
  }

  Widget isiData(String title, String subtitle) {
    return Card(
      color: Color.fromARGB(999, 243, 233, 210),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}

// Card(
//               margin: EdgeInsets.all(35),
//               color: Color.fromARGB(999, 243, 233, 210),
//               child: ListView.builder(
//                 itemCount: items.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return isiData(items[index], isi[index]);
//                 },
//               ),
//             ),

// ListView(padding: EdgeInsets.all(55.0), children: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Material(
//               child:
//                   Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             Material(child: Text(name)),
//           ],
//         ),
//         SizedBox(height: 20.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Material(
//               child: Text('Birthdate',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             Material(child: Text(birthdate)),
//           ],
//         ),
//         SizedBox(height: 20.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Material(
//               child: Text('Age', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             Material(child: Text(ages)),
//           ],
//         ),
//         SizedBox(height: 20.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Material(
//               child:
//                   Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             Material(child: Text(gender)),
//           ],
//         ),
//         SizedBox(height: 20.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Material(
//               child: Text('Activity Level',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             Material(child: Text(actLevel)),
//           ],
//         ),
//         SizedBox(height: 20.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Material(
//               child:
//                   Text('Goal', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             Material(child: Text(goal)),
//           ],
//         ),
//         SizedBox(height: 20.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Material(
//               child:
//                   Text('Height', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             Material(child: Text(height + ' cm')),
//           ],
//         ),
//         SizedBox(height: 20.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Material(
//               child:
//                   Text('Weight', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             Material(child: Text(weight + ' kg')),
//           ],
//         ),
//         SizedBox(height: 20.0),
//         Card(
//             color: Color.fromARGB(999, 198, 218, 191),
//             child: AnimatedContainer(
//                 duration: Duration(seconds: 2),
//                 margin: EdgeInsets.all(10.0),
//                 child: Column(children: <Widget>[
//                   Text("Rekomendasi Kalori Harian",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color.fromARGB(999, 17, 75, 95),
//                           fontSize: 18)),
//                   Divider(
//                     thickness: 2.0,
//                     color: Colors.white,
//                   ),
//                   Text(
//                     totalCal.toStringAsFixed(2) + " kalori",
//                     textAlign: TextAlign.center,
//                   ),
//                 ])))
//       ]),
