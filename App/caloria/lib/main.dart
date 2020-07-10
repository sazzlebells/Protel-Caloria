import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//dart files
import 'signup.dart';
import 'homepage.dart';
import 'addfood.dart';
import 'package:caloria/profile.dart';
import 'package:caloria/info.dart';
import 'package:caloria/vars.dart';

void main() => runApp(MyApp());

var id_user;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Caloria',
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => SignupPage(id: id_user),
        '/home': (BuildContext context) => HomePage(id: id_user),
        '/addfood': (BuildContext context) => AddfoodPage(id: id_user),
        '/main': (BuildContext context) => MyHomePage(),
        '/profile': (BuildContext context) => ProfilePage(id: id_user),
        '/info': (BuildContext context) => InfoPage(id: id_user),
      },
      home: new MyHomePage(),
      theme: ThemeData(
        fontFamily: 'Calibri',
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(999, 17, 75, 95),
        ),
      ),
    );
  }
}






class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

enum LoginStatus{
  offline,
  online
}

class _MyHomePageState extends State<MyHomePage> {
  final _key = new GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // TextEditingController email = new TextEditingController();
  // TextEditingController password = new TextEditingController();

  @override
  void initState() {
    setState(() {
      loading = true;
      //homepage.dart, flexiable class
      cal=0;
      carb=0;
      pro=0;
      fat=0;
      chol=0;
      sgr=0;
      calPercent = 0;
      carbPercent=0;
      proPercent=0;
      fatPercent=0;
      //profile.dart, flexiable class
      name = 'no name';
      gender = '';
      actLevel = '';
      goal = '';
      height = '';
      weight = '';
      birthdate = '';
      bmr = 0;
      bmi = 0;
      bmiStatus=0;
      // DateTime now = DateTime.now();
      tglSkrg = '';
      ages = '';
      age = 0;
      tgl = 0;
      bln = 0;
      thn = 0;
      tglLahir = 0;
      blnLahir = 0;
      thnLahir = 0;
      totalCal=0; 
      totalCarb=0; totalPro=0; totalFat=0;
    });
    super.initState();
  }

  String email, password;
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      // print("$email, $password"); //pakai ini klo blm pake login()
      print('mencoba login');
      login();
    }
  }

  check2() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      // print("$email, $password"); //pakai ini klo blm pake login()
      signup();
    }
  }

  login() async {
    final response = await http.post(link+'api/login.php', body: {
      "email": email,
      "password": password
    });
    final data = jsonDecode(response.body);

    int value = data['value'];
    String msg = data['message'];
    String id = data['id_user'].toString();
    if(value==1){
      setState(() {
        Navigator.of(context).popAndPushNamed('/home');
        id_user = id;
      });
      Fluttertoast.showToast(msg: msg);
      print(msg);
      print(id);
    }
    else {Fluttertoast.showToast(msg: msg); print(msg);}
  }

  signup() async {
    final response = await http.post(link+"api/register.php", body: {
      "email" : email,
      "password" : password
    });
    final data = jsonDecode(response.body);
    
    int value = data['value'];
    String msg = data['message'];
    String id = data['id_user'].toString();

    if(value==1){
      setState(() {
        Navigator.of(context).pushNamed('/signup');
        id_user = id;
        print(id);
      });
      Fluttertoast.showToast(msg: msg);
      print(msg);
    }
    else {Fluttertoast.showToast(msg: msg); print(msg);}
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Caloria',
                    style: TextStyle(
                        fontSize: 55.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
          Text('Your Calories Counter',
                    style: TextStyle(fontSize: 17.5)),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
            child: Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          Fluttertoast.showToast(msg: "Insert a valid username");
                          return null;
                        }
                      },
                      onSaved: (e) => email = e,
                      // controller: email,
                      decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Calibri',
                              color: Colors.grey),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(999, 198, 218, 191)),
                              borderRadius: BorderRadius.circular(30)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(999, 17, 75, 95)),
                              borderRadius: BorderRadius.circular(30))),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      onSaved: (e) => password = e,
                      // controller: password,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Calibri',
                              color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility), 
                            onPressed: showHide),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(999, 198, 218, 191)),
                              borderRadius: BorderRadius.circular(30)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(999, 17, 75, 95)),
                              borderRadius: BorderRadius.circular(30))),
                      obscureText: _secureText,
                    ),
                    SizedBox(height: 30.0),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(999, 17, 75, 95),
                      child: MaterialButton(
                        onPressed: () {
                          check();
                        },
                        minWidth: 150.0,
                        textColor: Color.fromARGB(999, 243, 233, 210),
                        child: Text('LOG IN',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(999, 17, 75, 95),
                      child: MaterialButton(
                        onPressed: () {
                          check2();
                        },
                        minWidth: 150.0,
                        textColor: Color.fromARGB(999, 243, 233, 210),
                        child: Text('SIGN UP',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ],
      ),
      ),
    );
  }
}


// Container(
//               child: Stack(
//             children: <Widget>[
//               Container(
//                 padding: EdgeInsets.fromLTRB(79.0, 120.0, 79.0, 0.0),
//                 child: Text('Caloria',
//                     style: TextStyle(
//                         fontSize: 55.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green)),
//               ),
//               Container(
//                 padding: EdgeInsets.fromLTRB(83.0, 190.0, 80.0, 40.0),
//                 child: Text('Your Calories Counter',
//                     style: TextStyle(fontSize: 17.5)),
//               )
//             ],
//           )),
//           Container(
//               padding: EdgeInsets.only(left: 80.0, top: 0.0, right: 80.0),
//               child: Form(
//                 key: _key,
//                 child: Column(
//                   children: <Widget>[
//                     TextFormField(
//                       validator: (e) {
//                         if (e.isEmpty) {
//                           Fluttertoast.showToast(msg: "Insert a valid username");
//                           return null;
//                         }
//                       },
//                       onSaved: (e) => email = e,
//                       // controller: email,
//                       decoration: InputDecoration(
//                           hintText: 'Username',
//                           hintStyle: TextStyle(
//                               fontSize: 14.0,
//                               fontFamily: 'Calibri',
//                               color: Colors.grey),
//                           contentPadding:
//                               EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
//                           enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Color.fromARGB(999, 198, 218, 191)),
//                               borderRadius: BorderRadius.circular(30)),
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Color.fromARGB(999, 17, 75, 95)),
//                               borderRadius: BorderRadius.circular(30))),
//                     ),
//                     SizedBox(height: 10.0),
//                     TextFormField(
//                       onSaved: (e) => password = e,
//                       // controller: password,
//                       decoration: InputDecoration(
//                           hintText: 'Password',
//                           hintStyle: TextStyle(
//                               fontSize: 14.0,
//                               fontFamily: 'Calibri',
//                               color: Colors.grey),
//                           suffixIcon: IconButton(
//                             icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility), 
//                             onPressed: showHide),
//                           contentPadding:
//                               EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
//                           enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Color.fromARGB(999, 198, 218, 191)),
//                               borderRadius: BorderRadius.circular(30)),
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Color.fromARGB(999, 17, 75, 95)),
//                               borderRadius: BorderRadius.circular(30))),
//                       obscureText: _secureText,
//                     ),
//                     SizedBox(height: 30.0),
//                     Material(
//                       elevation: 5.0,
//                       borderRadius: BorderRadius.circular(25),
//                       color: Color.fromARGB(999, 17, 75, 95),
//                       child: MaterialButton(
//                         onPressed: () {
//                           check();
//                         },
//                         minWidth: 200.0,
//                         textColor: Color.fromARGB(999, 243, 233, 210),
//                         child: Text('LOG IN',
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//                     SizedBox(height: 10.0),
//                     Material(
//                       elevation: 5.0,
//                       borderRadius: BorderRadius.circular(25),
//                       color: Color.fromARGB(999, 17, 75, 95),
//                       child: MaterialButton(
//                         onPressed: () {
//                           check2();
//                         },
//                         minWidth: 200.0,
//                         textColor: Color.fromARGB(999, 243, 233, 210),
//                         child: Text('SIGN UP',
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ))