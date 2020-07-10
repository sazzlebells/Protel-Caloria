import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
//dart files
import 'package:caloria/vars.dart';

class SignupPage extends StatefulWidget {
  // final String email, password;
  SignupPage({this.id});
  final String id;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _key = new GlobalKey<FormState>();
  String nameNew = '';
  String genderNew = '';
  String actLevelNew = '';
  String goalNew = '';
  String heightNew = '';
  String weightNew = '';
  DateTime selectedDate = DateTime.now();
  String ddGender = 'Choose gender';
  String ddAct = 'Choose activity level';
  String ddGoal = 'Choose goal';

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(2025));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      // print("$email, $password"); //pakai ini klo blm pake login()
      print("ID user : " + widget.id);
      update();
    }
  }

  update() async {
    final response = await http.post(link + "api/editProfil.php", body: {
      "nama_user": nameNew,
      "tanggal_lahir": selectedDate.toString(),
      "jenis_kelamin": genderNew,
      "tinggi_badan": heightNew,
      "berat_badan": weightNew,
      "target": goalNew,
      "aktivitas": actLevelNew,
      "id_user": widget.id
    });
    final data = jsonDecode(response.body);

    if (data['value'] == "1") {
      Navigator.of(context).popAndPushNamed('/home');
      Fluttertoast.showToast(msg: "Data inserted");
      print("bisa");
    } else {
      Fluttertoast.showToast(msg: "Data not inserted");
      print("gak bisa");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Form(
      key: _key,
      child: ListView(padding: EdgeInsets.all(40.0), children: <Widget>[
        Text(
          'Profile',
          style: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(999, 17, 75, 95)),
        ),
        Text(
          'Set up your profile so we can give you the best recommendation',
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(999, 120, 155, 69)),
        ),
        SizedBox(height: 20.0),
        TextFormField(
          onSaved: (e) => nameNew = e,
          initialValue: name,
          decoration: InputDecoration(
              labelText: 'NAME',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(999, 96, 91, 86)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(999, 198, 218, 191)))),
        ),
        SizedBox(height: 10.0),
        Text('BIRTH DATE',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Color.fromARGB(999, 96, 91, 86))),
        FlatButton(
          onPressed: () => _selectDate(context),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text("${selectedDate.toLocal()}".split(' ')[0],
              style: TextStyle(
                  fontSize: 16.0, color: Color.fromARGB(999, 96, 91, 86))),
        ),
        Divider(
          thickness: 0.6,
          color: Color.fromARGB(999, 96, 91, 86),
        ),
        SizedBox(height: 10.0),
        // TextFormField(
        //   onSaved: (e) => birthdate = e,
        //   inputFormatters: [WhitelistingTextInputFormatter(RegExp("[1234567890-]"))],
        //   decoration: InputDecoration(
        //       labelText: 'BIRTH DATE',
        //       labelStyle: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Color.fromARGB(999, 96, 91, 86)),
        //       hintText: 'YYYY-MM-DD',
        //       hintStyle: TextStyle(
        //           fontSize: 11.0,
        //           color: Color.fromARGB(999, 96, 91, 86)),
        //       focusedBorder: UnderlineInputBorder(
        //           borderSide:
        //               BorderSide(color: Color.fromARGB(999, 198, 218, 191)))),
        // ),
        // SizedBox(height: 10.0),
        // TextFormField(
        //   onSaved: (e) => genderNew = (e),
        //   inputFormatters: [WhitelistingTextInputFormatter(RegExp("[12]"))],
        //   decoration: InputDecoration(
        //       labelText: 'GENDER',
        //       labelStyle: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Color.fromARGB(999, 96, 91, 86)),
        //       focusedBorder: UnderlineInputBorder(
        //           borderSide:
        //               BorderSide(color: Color.fromARGB(999, 198, 218, 191)))),
        // ),
        Text('GENDER',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Color.fromARGB(999, 96, 91, 86))),
        DropdownButton<String>(
          value: ddGender,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Color.fromARGB(999, 96, 91, 86)),
          underline: Divider(
            thickness: 0.6,
            color: Color.fromARGB(999, 96, 91, 86),
          ),
          onChanged: (String newValue) {
            setState(() {
              ddGender = newValue;
              switch (newValue) {
                case 'Male':
                  genderNew = "1";
                  break;
                case 'Female':
                  genderNew = "2";
                  break;
                default:
                  genderNew = "0";
                  break;
              }
              print(genderNew);
            });
          },
          items: <String>['Choose gender', 'Female', 'Male']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(height: 10.0),
        TextFormField(
          onSaved: (e) => heightNew = (e),
          initialValue: height,
          inputFormatters: [
            WhitelistingTextInputFormatter(RegExp("[1234567890.]"))
          ],
          decoration: InputDecoration(
              labelText: 'HEIGHT',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(999, 96, 91, 86)),
              hintText: '  cm',
              hintStyle: TextStyle(color: Color.fromARGB(999, 96, 91, 86)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(999, 198, 218, 191)))),
        ),
        SizedBox(height: 10.0),
        TextFormField(
          onSaved: (e) => weightNew = (e),
          initialValue: weight,
          inputFormatters: [
            WhitelistingTextInputFormatter(RegExp("[1234567890.]"))
          ],
          decoration: InputDecoration(
              labelText: 'WEIGHT',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(999, 96, 91, 86)),
              hintText: '  kg',
              hintStyle: TextStyle(color: Color.fromARGB(999, 96, 91, 86)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(999, 198, 218, 191)))),
        ),
        SizedBox(height: 10.0),
        Text('ACTIVITY LEVEL',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Color.fromARGB(999, 96, 91, 86))),
        DropdownButton<String>(
          value: ddAct,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Color.fromARGB(999, 96, 91, 86)),
          underline: Divider(
            thickness: 0.6,
            color: Color.fromARGB(999, 96, 91, 86),
          ),
          onChanged: (String newValue) {
            setState(() {
              ddAct = newValue;
              switch (newValue) {
                case "Sedentary":
                  actLevelNew = "1";
                  break;
                case "Low Active":
                  actLevelNew = "2";
                  break;
                case "Active":
                  actLevelNew = "3";
                  break;
                case "Very Active":
                  actLevelNew = "4";
                  break;
                default:
                  actLevelNew = "0";
                  break;
              }
              print(actLevelNew);
            });
          },
          items: <String>[
            'Choose activity level',
            'Sedentary',
            'Low Active',
            'Active',
            'Very Active'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        // TextFormField(
        //   onSaved: (e) => actLevelNew = (e),
        //   inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0123]"))],
        //   decoration: InputDecoration(
        //       labelText: 'ACTIVITY LEVEL',
        //       labelStyle: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Color.fromARGB(999, 96, 91, 86)),
        //       hintText: '0=Sedentary, 1=Low Active, 2=Active, 3=Very Active',
        //       hintStyle: TextStyle(
        //           fontSize: 11.0,
        //           color: Color.fromARGB(999, 96, 91, 86)),
        //       focusedBorder: UnderlineInputBorder(
        //           borderSide:
        //               BorderSide(color: Color.fromARGB(999, 198, 218, 191)))),
        // ),
        SizedBox(height: 10.0),
        Text('GOAL',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Color.fromARGB(999, 96, 91, 86))),
        DropdownButton<String>(
          value: ddGoal,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Color.fromARGB(999, 96, 91, 86)),
          underline: Divider(
            thickness: 0.6,
            color: Color.fromARGB(999, 96, 91, 86),
          ),
          onChanged: (String newValue) {
            setState(() {
              ddGoal = newValue;
              switch (newValue) {
                case "Lose Weight":
                  goalNew = "1";
                  break;
                case "Maintain Weight":
                  goalNew = "2";
                  break;
                case "Gain Weight":
                  goalNew = "3";
                  break;
                default:
                  goalNew = "0";
                  break;
              }
              print(goalNew);
            });
          },
          items: <String>[
            'Choose goal',
            'Lose Weight',
            'Maintain Weight',
            'Gain Weight'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        // TextFormField(
        //   onSaved: (e) => goalNew = (e),
        //   inputFormatters: [WhitelistingTextInputFormatter(RegExp("[012]"))],
        //   decoration: InputDecoration(
        //       labelText: 'GOAL',
        //       labelStyle: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Color.fromARGB(999, 96, 91, 86)),
        //       hintText: '0=Lose Weight, 1=Maintain Weight, 2=Gain Weight',
        //       hintStyle: TextStyle(
        //           fontSize: 11.0,
        //           color: Color.fromARGB(999, 96, 91, 86)),
        //       focusedBorder: UnderlineInputBorder(
        //           borderSide:
        //               BorderSide(color: Color.fromARGB(999, 198, 218, 191)))),
        // ),
        SizedBox(height: 50.0),
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          buttonHeight: 40.0,
          buttonMinWidth: 120.0,
          children: <Widget>[
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(25),
              color: Color.fromARGB(999, 17, 75, 95),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Color.fromARGB(999, 243, 233, 210),
                child:
                    Text('BACK', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(25),
              color: Color.fromARGB(999, 17, 75, 95),
              child: MaterialButton(
                onPressed: () {
                  if(ddAct=="Choose activity level" || ddGoal=="Choose goal" || ddGender=="Choose gender"){
                    Fluttertoast.showToast(msg: "Please check again!");
                  }
                  else{check();}
                },
                textColor: Color.fromARGB(999, 243, 233, 210),
                child:
                    Text('SAVE', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ]),
    ));
  }
}
