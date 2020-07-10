import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
//dart files
import 'drawer.dart';
import 'package:caloria/vars.dart';

class HomePage extends StatefulWidget {
  HomePage({this.id});
  final String id;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [];
  DateTime now = DateTime.now();

  List _makanan(int index, String x) {
    List<Widget> listItems = List();

    for (int i = 0; i < index; i++) {
      if (data[i]['tipe_makan'] == x) {
        listItems.add(
          new Card(
              color: Color.fromARGB(225, 255, 255, 255),
              margin: EdgeInsets.only(left: 25, right: 25),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${data[i]["nama_makanan"]}',
                      style: TextStyle(color: Color.fromARGB(999, 96, 91, 86)),
                    ),
                    Text('${data[i]["kalori"]}',
                        style:
                            TextStyle(color: Color.fromARGB(999, 96, 91, 86)))
                  ],
                ),
              )),
        );
      } else {
        // listItems.add(new Text("tipe bukan "+x.toString()));
      }
    }
    if (listItems.length == 0) {
      listItems.add(
        new Card(
            color: Color.fromARGB(225, 255, 255, 255),
            margin: EdgeInsets.only(left: 25, right: 25),
            child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  "No data",
                  style: TextStyle(color: Color.fromARGB(999, 96, 91, 86)),
                ))),
      );
    }
    return listItems;
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    final response = await http
        .post(link + 'api/tampilProfil.php', body: {"id_user": widget.id});

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

        //==========================ERRORS
        
        warn = false;
        if(data[0]['nama_user']==" " || data[0]['nama_user']=="" || data[0]['nama_user'].isEmpty){
          warning = "Please update your profile";
          name='no name';
          warn=true;
        }
        if (data[0]['jenis_kelamin'] == "0") {
          warning = "Please update your profile";
          data[0]['jenis_kelamin'] = "1";
          warn = true;
        }
        print(warn);


        //==========================HITUNG TOTAL KALORI HARIAN
        //Rumus Mifflin-St Jeor
        bmi = double.parse(weight) /
            (((double.parse(height) / 100)) * ((double.parse(height) / 100)));
        print(bmi);
        if (bmi < 18.5) {
          bmiStatus = 1;
        } //Underweight
        else if (bmi >= 18.5 && bmi <= 22.9) {
          bmiStatus = 2;
        } //Normal
        else if (bmi >= 23.0 && bmi <= 24.9) {
          bmiStatus = 3;
        } //Overweight
        else if (bmi >= 25.0 && bmi <= 29.9) {
          bmiStatus = 4;
        } //Obese I
        else if (bmi >= 30.0) {
          bmiStatus = 5;
        } //Obese II
        else {
          bmiStatus = 0;
        }
        print(bmiStatus);

        data[0]['jenis_kelamin'] == "1"
            ? bmr = (10 * (double.parse(weight))) +
                (6.25 * (double.parse(height))) -
                (5 * age) +
                5 //male
            : bmr = (10 * (double.parse(weight))) +
                (6.25 * (double.parse(height))) -
                (5 * age) -
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

        ambilData();
      });
    }
  }

  void ambilData() async {
    final response1 = await http.post(link + 'api/tampilCatatan.php', body: {
      "id_user": widget.id,
      "waktu": DateTime.now().toString().split(" ")[0]
      // "waktu": "2020-04-09",
      // "tipe_makan": tipe[0]
    });
    if (response1.statusCode == 200) {
      setState(() {
        data = json.decode(response1.body);
        print("Data masuk: " + data.length.toString());
        cal = 0;
        carb = 0;
        pro = 0;
        fat = 0;
        chol = 0;
        sgr = 0;
        calPercent = 0;
        carbPercent = 0;
        proPercent = 0;
        fatPercent = 0;
      });
      hitung();
    }
  }

  void hitung() async {
    setState(() {
      loading = false;
    });
    for (var i = 0; i < data.length; i++) {
      setState(() {
        cal = cal + double.parse(data[i]["kalori"]);
        carb = carb + double.parse(data[i]["karbohidrat"]);
        pro = pro + double.parse(data[i]["protein"]);
        fat = fat + double.parse(data[i]["lemak"]);
        chol = chol + double.parse(data[i]["kolesterol"]);
        sgr = sgr + double.parse(data[i]["gula"]);

        calPercent = cal / totalCal;
        carbPercent = carb / totalCarb;
        proPercent = pro / totalPro;
        fatPercent = fat / totalFat;
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

  //===============================================START=========================================
  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            color: Colors.white,
            child: Center(child: CircularProgressIndicator()))
        : Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: upBar(),
                  pinned: true,
                  expandedHeight: 200.0,
                  backgroundColor:
                      Color.fromARGB(999, 198, 218, 191), //ini bg warna appbar
                  flexibleSpace: FlexibleSpaceBar(
                    background: MyFlexiableAppBar(),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                    child: Text(
                      meal[0],
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(999, 17, 75, 95),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Color.fromARGB(999, 198, 218, 191),
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                ])),
                SliverList(
                  delegate: new SliverChildListDelegate(
                      _makanan(data.length >= 5 ? 5 : data.length, "1")),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                    child: Text(
                      meal[1],
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(999, 17, 75, 95),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Color.fromARGB(999, 198, 218, 191),
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                ])),
                SliverList(
                  delegate: new SliverChildListDelegate(
                      _makanan(data.length >= 5 ? 5 : data.length, "2")),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                    child: Text(
                      meal[2],
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(999, 17, 75, 95),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Color.fromARGB(999, 198, 218, 191),
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                ])),
                SliverList(
                  delegate: new SliverChildListDelegate(
                      _makanan(data.length >= 5 ? 5 : data.length, "3")),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                    child: Text(
                      meal[3],
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(999, 17, 75, 95),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Color.fromARGB(999, 198, 218, 191),
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                ])),
                SliverList(
                  delegate: new SliverChildListDelegate(
                      _makanan(data.length >= 5 ? 5 : data.length, "4")),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pushNamed('/addfood');
              },
              label: Text(
                "Add Food",
                style: TextStyle(color: Color.fromARGB(999, 243, 233, 210)),
              ),
              icon: Icon(Icons.add, color: Color.fromARGB(999, 243, 233, 210)),
              backgroundColor: Color.fromARGB(999, 17, 75, 95),
            ),
            drawer: Drawer(
              child: DrawerFill(id: widget.id),
            ),
          );
  }

  Widget upBar() {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "Today");
            },
            child: Text('Today   ',
                style: TextStyle(
                    color: Color.fromARGB(999, 17, 75, 95),
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold))),
        IconButton(
            icon: Icon(Icons.autorenew, color: Color.fromARGB(999, 17, 75, 95)),
            onPressed: () {
              fetchData();
              Fluttertoast.showToast(msg: "Reload");
            }),
      ],
    );
  }
}

class MyFlexiableAppBar extends StatelessWidget {
  final double appBarHeight = 66.0;

  @override
  Widget build(BuildContext context) {
    double screenw = MediaQuery.of(context).size.width - 40;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(
          top: statusBarHeight + 50.0, left: 20.0, right: 20.0),
      height: statusBarHeight + appBarHeight,
      child: new Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Container(
          //       child: Padding(
          //         padding: EdgeInsets.only(bottom: 5.0),
          //         child: new Text("Total Calories",
          //             style: const TextStyle(
          //                 color: Color.fromARGB(999, 96, 91, 86),
          //                 fontSize: 16.0)),
          //       ),
          //     ),
          //     Container(
          //       child: new LinearPercentIndicator(
          //         width: screenw-10,
          //         lineHeight: 15.0,
          //         progressColor: Color.fromARGB(999, 17, 75, 95),
          //         percent: calPercent > 1.00 ? 1.00 : calPercent,
          //         center: Text(
          //             (calPercent > 1.00 ? 100 : calPercent * 100)
          //                     .toStringAsFixed(1) +
          //                 "%",
          //             style: TextStyle(fontSize: 12.0, color: Colors.white)),
          //         animation: true,
          //       ),
          //     ),
          //   ],
          // ),
          Column(
            children: [
              Text("Total Calories",
                  style: const TextStyle(
                      color: Color.fromARGB(999, 96, 91, 86), fontSize: 16.0)),
              LinearPercentIndicator(
                width: screenw,
                lineHeight: 20.0,
                progressColor: Color.fromARGB(999, 17, 75, 95),
                percent: calPercent > 1.00 ? 1.00 : calPercent,
                center: Text(
                    cal.toStringAsFixed(1) +
                        " / " + totalCal.toStringAsFixed(1) + " cal",
                    style: TextStyle(fontSize: 12.0, color: Colors.white)),
                animation: true,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    Text("Carbs",
                        style: const TextStyle(
                            color: Color.fromARGB(999, 96, 91, 86),
                            fontSize: 16.0)),
                    LinearPercentIndicator(
                      width: (screenw - 15) / 3,
                      lineHeight: 20,
                      progressColor: Color.fromARGB(999, 17, 75, 95),
                      percent: carbPercent > 1.00 ? 1.00 : carbPercent,
                      center: Text(
                          (carbPercent > 1.00 ? 100 : carbPercent * 100)
                                  .toStringAsFixed(1) +
                              "%",
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.white)),
                      animation: true,
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Text("Protein",
                        style: const TextStyle(
                            color: Color.fromARGB(999, 96, 91, 86),
                            fontSize: 16.0)),
                    LinearPercentIndicator(
                      width: (screenw - 15) / 3,
                      lineHeight: 20,
                      progressColor: Color.fromARGB(999, 17, 75, 95),
                      percent: proPercent > 1.00 ? 1.00 : proPercent,
                      center: Text(
                          (proPercent > 1.00 ? 100 : proPercent * 100)
                                  .toStringAsFixed(1) +
                              "%",
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.white)),
                      animation: true,
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Text("Fat",
                        style: const TextStyle(
                            color: Color.fromARGB(999, 96, 91, 86),
                            fontSize: 16.0)),
                    LinearPercentIndicator(
                      width: (screenw - 15) / 3,
                      lineHeight: 20,
                      progressColor: Color.fromARGB(999, 17, 75, 95),
                      percent: fatPercent > 1.00 ? 1.00 : fatPercent,
                      center: Text(
                          (fatPercent > 1.00 ? 100 : fatPercent * 100)
                                  .toStringAsFixed(1) +
                              "%",
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.white)),
                      animation: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     Container(
          //       child: Padding(
          //         padding: const EdgeInsets.only(top: 14.0, bottom: 5.0),
          //         child: new Text(" Carbs       ",
          //             style: const TextStyle(
          //                 color: Color.fromARGB(999, 96, 91, 86),
          //                 fontSize: 16.0)),
          //       ),
          //     ),
          //     Container(
          //       child: Padding(
          //         padding: const EdgeInsets.only(top: 14.0, bottom: 5.0),
          //         child: new Text("Protein    ",
          //             style: const TextStyle(
          //                 color: Color.fromARGB(999, 96, 91, 86),
          //                 fontSize: 16.0)),
          //       ),
          //     ),
          //     Container(
          //       child: Padding(
          //         padding: const EdgeInsets.only(top: 14.0, bottom: 5.0),
          //         child: new Text("     Fat   ",
          //             style: const TextStyle(
          //                 color: Color.fromARGB(999, 96, 91, 86),
          //                 fontSize: 16.0)),
          //       ),
          //     ),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     LinearPercentIndicator(
          //       width: 100.0,
          //       lineHeight: 15.0,
          //       progressColor: Color.fromARGB(999, 17, 75, 95),
          //       percent: carbPercent > 1.00 ? 1.00 : carbPercent,
          //       center: Text(
          //           (carbPercent > 1.00 ? 100 : carbPercent * 100)
          //                   .toStringAsFixed(1) +
          //               "%",
          //           style: TextStyle(fontSize: 12.0, color: Colors.white)),
          //       animation: true,
          //     ),
          //     LinearPercentIndicator(
          //       width: 100.0,
          //       lineHeight: 15.0,
          //       progressColor: Color.fromARGB(999, 17, 75, 95),
          //       percent: proPercent > 1.00 ? 1.00 : proPercent,
          //       center: Text(
          //           (proPercent > 1.00 ? 100 : proPercent * 100)
          //                   .toStringAsFixed(1) +
          //               "%",
          //           style: TextStyle(fontSize: 12.0, color: Colors.white)),
          //       animation: true,
          //     ),
          //     LinearPercentIndicator(
          //       width: 100.0,
          //       lineHeight: 15.0,
          //       progressColor: Color.fromARGB(999, 17, 75, 95),
          //       percent: fatPercent > 1.00 ? 1.00 : fatPercent,
          //       center: Text(
          //           (fatPercent > 1.00 ? 100 : fatPercent * 100)
          //                   .toStringAsFixed(1) +
          //               "%",
          //           style: TextStyle(fontSize: 12.0, color: Colors.white)),
          //       animation: true,
          //     ),
          //   ],
          // ),
        ],
      )),
      decoration: new BoxDecoration(
        color: Color.fromARGB(999, 243, 233, 210),
      ),
    );
  }
}
