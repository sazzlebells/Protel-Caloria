import 'package:flutter/material.dart';
//dart files
import 'drawer.dart';
import 'package:caloria/vars.dart';

class FoodDetailPage extends StatefulWidget {
  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Detail', 
          style: TextStyle(
            color: Color.fromARGB(999, 243, 233, 210),
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
          )),
      ),
      drawer: DrawerFill(),
      body: ListView(padding: EdgeInsets.all(55.0), children: <Widget>[

      ],
    ));
  }
}