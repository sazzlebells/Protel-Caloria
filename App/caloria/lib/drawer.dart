import 'package:flutter/material.dart';
//dart files
import 'package:caloria/vars.dart';

class DrawerFill extends StatefulWidget {
  DrawerFill({this.id});
  final String id;
  @override
  _DrawerFillState createState() => _DrawerFillState();
}

class _DrawerFillState extends State<DrawerFill> {
  List data = [];

  Map<int, Color> bmiColors = {
    0: Color.fromARGB(999, 17, 75, 95),
    1: Color.fromARGB(999, 128, 206, 225),
    2: Color.fromARGB(999, 119, 221, 119),
    3: Color.fromARGB(999, 253, 253, 150),
    4: Color.fromARGB(999, 255, 179, 71),
    5: Color.fromARGB(999, 235, 76, 48),
  };

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You will be logged out from this account.'),
                // Text('Choose anything, nothing will happen.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/main");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          child: Column(
            children: <Widget>[
              Text(
                'BMI: ' + bmi.toStringAsFixed(1),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(thickness: 2),
              CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Color.fromARGB(400, 17, 75, 95),
                  child: Text(
                    name.substring(0, 1),
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  )),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    weight + ' kg',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: bmiColors[bmiStatus],
            // color: Colors.white
          ),
        ),
        ListTile(
            leading: Icon(Icons.book, color: Color.fromARGB(999, 17, 75, 95)),
            title: Text("Food Diary",
                style: TextStyle(
                    color: Color.fromARGB(999, 17, 75, 95),
                    fontWeight: FontWeight.bold)),
            onTap: () {
              // Navigator.pop(context);
              Navigator.of(context).popAndPushNamed('/home');
            }),
        Divider(thickness: 1.0),
        ListTile(
            leading: Icon(Icons.person, color: Color.fromARGB(999, 17, 75, 95)),
            title: Text("Profile",
                style: TextStyle(
                    color: Color.fromARGB(999, 17, 75, 95),
                    fontWeight: FontWeight.bold)),
            onTap: () {
              //update app state
              //...
              //then close the drawer
              Navigator.of(context).popAndPushNamed('/profile');
            }),
        Divider(thickness: 1.0),
        ListTile(
            leading: Icon(Icons.info, color: Color.fromARGB(999, 17, 75, 95)),
            title: Text("About",
                style: TextStyle(
                    color: Color.fromARGB(999, 17, 75, 95),
                    fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.of(context).popAndPushNamed('/info');
            }),
        Divider(thickness: 1.0),
        ListTile(
            leading: Icon(Icons.exit_to_app, color: Color.fromARGB(999, 17, 75, 95)),
            title: Text("Log Out",
                style: TextStyle(
                    color: Color.fromARGB(999, 17, 75, 95),
                    fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              _neverSatisfied();
            }),
        Divider(thickness: 1.0),
        ListTile(
          leading: warn
              ? Icon(Icons.warning, color: Colors.yellow)
              : Icon(Icons.check_box_outline_blank, color: Colors.transparent),
          title: Visibility(
            visible: warn,
            child: warn
                ? Text(warning, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))
                : Divider(thickness: 0),
          ),
        ),
      ]),
    );
  }
}
