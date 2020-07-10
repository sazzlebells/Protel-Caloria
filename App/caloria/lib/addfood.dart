import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // For using PlatformException
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// For performing some operations asynchronously
import 'dart:async';
import 'dart:typed_data';
//dart files
import 'package:caloria/vars.dart';

class AddfoodPage extends StatefulWidget {
  // AddfoodPage({Key key}) : super(key: key);

  AddfoodPage({this.id});
  final String id;

  @override
  _AddfoodPageState createState() => _AddfoodPageState();
}

class _AddfoodPageState extends State<AddfoodPage> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;

  int _deviceState;
  String sensorValue = "N/A";
  bool isDisconnecting = false;

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green[700],
    'offTextColor': Colors.red[700],
    'neutralTextColor': Colors.blue,
  };

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
        print(_bluetoothState);
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
      print(_devicesList);
    });
  }

  //================================ADD FOOD VARIABLES==================================
  final _key = new GlobalKey<FormState>();
  File _image;
  String dropdownValue = 'Choose a category';
  String foodName = '';
  String foodCategory = '';
  double foodWeight = 0;
  double foodCal, foodCarb, foodProtein, foodFat, foodChol, foodSugar;
  String status = '';
  String base64img = '';
  String fileName = '';
  String processStatus = '0';
  DateTime sekarang;
  double calorie = 0,
      carbs = 0,
      protein = 0,
      fat = 0,
      cholesterol = 0,
      sugar = 0;
  bool muncul = false;

  //========================================ASUMSI UDAH BISA DETEKSI
  String foodID = '4';

  //================================================================

  List data = [];

  Future<void> bluetoothPopUp() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //user must tap a button!
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.fromLTRB(30, 150, 30, 150),
            color: Colors.white,
            child: btapp(context),
          );
        });
  }

  void fetchData() async {
    final response =
        await http.post(link + 'api/data100.php', body: {"id_makanan": foodID});

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
        print(data);

        foodName = data[0]['nama_makanan'];
        foodCal = double.parse(data[0]['kalori']) / 100 * foodWeight;
        foodCarb =
            double.parse(data[0]['karbohidrat (gram)']) / 100 * foodWeight;
        foodProtein =
            double.parse(data[0]['protein (gram)']) / 100 * foodWeight;
        foodFat = double.parse(data[0]['lemak (gram)']) / 100 * foodWeight;
        foodChol =
            double.parse(data[0]['kolesterol (miligram)']) / 100 * foodWeight;
        foodSugar = double.parse(data[0]['gula (gram)']) / 100 * foodWeight;
      });
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      // print("$email, $password"); //pakai ini klo blm pake login()
      print("ID user : " + widget.id);
      addFood();
    }
  }

  void openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera)
        .then((File recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        setState(() {
          //saving...
        });
        GallerySaver.saveImage(recordedImage.path).then((path) {
          setState(() {
            _image = recordedImage;
            base64img = base64Encode(_image.readAsBytesSync());
            _sendOnMessageToBluetooth();
            startUpload();
            Fluttertoast.showToast(msg: "Photo Saved to Gallery!");
            // return _image;
          });
        });
      }
    });
  }

  void openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      base64img = base64Encode(_image.readAsBytesSync());
      _sendOnMessageToBluetooth();
      startUpload();
    });
  }

  void startUpload() {
    if (_image == null) {
      Fluttertoast.showToast(msg: "Error uploading!");
    }
    setState(() {
      muncul = true;
      // fileName = _image.path.split('/').last;
      sekarang = DateTime.now();
      fileName = 'foto_' + sekarang.toString() + '.jpg';
    });
    upload(fileName);
  }

  upload(String fileName) {
    http.post(link + 'img/uploadimg.php',
        body: {"image": base64img, "name": fileName}).then((result) {
      if (result.statusCode == 200) {
        fetchData();
        setState(() {
          muncul = false;
        });
        Fluttertoast.showToast(msg: result.body);
      } else {
        Fluttertoast.showToast(msg: "Error uploading!");
      }
      // Fluttertoast.showToast(msg: result.statusCode == 200 ? result.body : "Error uploading!");
    }).catchError((error) {
      Fluttertoast.showToast(msg: error);
    });
  }

  addFood() async {
    final response = await http.post(link + 'api/simpanMakanan.php', body: {
      "id_user": widget.id,
      // "url_foto": link + 'img/' + fileName, //+'.jpg',
      "tipe_makan": foodCategory,
      // "nama_makanan": foodName,
      // "berat_makanan": foodWeight.toString(),
      // "kalori": foodCal.toString(),
      // "karbohidrat": foodCarb.toString(),
      // "protein": foodProtein.toString(),
      // "lemak": foodFat.toString(),
      // "kolesterol": foodChol.toString(),
      // "gula": foodSugar.toString(),
      // "waktu": ((sekarang.toString()).split(' ')[0]),
      // "sudah_diproses": processStatus,
      "url_foto": '/opt/lampp/htdocs/protel/img/'+fileName, 
      "nama_makanan": "Please reload",
      "berat_makanan": foodWeight.toString(),
      "kalori": "0",
      "karbohidrat": "0",
      "protein": "0",
      "lemak": "0",
      "kolesterol": "0",
      "gula": "0",
      "waktu": ((sekarang.toString()).split(' ')[0]),
      "sudah_diproses": processStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Food',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36.0,
                  color: Color.fromARGB(999, 243, 233, 210))),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.settings_bluetooth,
                  color: Color.fromARGB(999, 243, 233, 210),
                ),
                onPressed: () {
                  bluetoothPopUp();
                }),
          ],
        ),
        body: Form(
          key: _key,
          child: ListView(padding: EdgeInsets.all(30.0), children: <Widget>[
            Container(
              height: 200.0,
              child: _image == null
                  ? Text(
                      "No image selected",
                      textAlign: TextAlign.center,
                    )
                  : Image.file(_image),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  color: Color.fromARGB(999, 17, 75, 95),
                  onPressed: () {
                    if (_connected) {
                      openCamera();
                    } else {
                      Fluttertoast.showToast(msg: "Turn on bluetooth first!");
                      bluetoothPopUp();
                    }
                  },
                ),
                Visibility(
                    visible: muncul,
                    child: CircularProgressIndicator(
                        backgroundColor: Color.fromARGB(999, 17, 75, 95))),
                IconButton(
                  icon: Icon(Icons.photo_library),
                  color: Color.fromARGB(999, 17, 75, 95),
                  onPressed: () {
                    if (_connected) {
                      openGallery();
                    } else {
                      Fluttertoast.showToast(msg: "Turn on bluetooth first!");
                      bluetoothPopUp();
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Text('FOOD CATEGORY',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Color.fromARGB(999, 96, 91, 86))),
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                  color: Color.fromARGB(999, 96, 91, 86),),
              underline: Divider(
                thickness: 0.6,
                color: Color.fromARGB(999, 96, 91, 86),
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  switch (newValue) {
                    case "Breakfast":
                      foodCategory = "1";
                      break;
                    case "Lunch":
                      foodCategory = "2";
                      break;
                    case "Dinner":
                      foodCategory = "3";
                      break;
                    case "Snack":
                      foodCategory = "4";
                      break;
                    default:
                      foodCategory = "0";
                      break;
                  }
                });
              },
              items: <String>[
                'Choose a category',
                'Breakfast',
                'Lunch',
                'Dinner',
                'Snack'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 10.0),
            // TextFormField(
            //   onSaved: (e) => foodName = e,
            //   // initialValue: foodName,
            //   decoration: InputDecoration(
            //       labelText: 'FOOD NAME',
            //       labelStyle: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           color: Color.fromARGB(999, 96, 91, 86)),
            //       focusedBorder: UnderlineInputBorder(
            //           borderSide: BorderSide(
            //               color: Color.fromARGB(999, 198, 218, 191)))),
            // ),
            // SizedBox(height: 10),
            // Text("FOOD NAME : ", style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     color: Color.fromARGB(999, 96, 91, 86)),),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Text(foodName=="" ? "null" : foodName, style: TextStyle(color: Color.fromARGB(999, 96, 91, 86))),
            //     FlatButton.icon(
            //       icon: Icon(Icons.language, color: Color.fromARGB(999, 243, 233, 210),),
            //       label: Text("GET", style: TextStyle(color: Color.fromARGB(999, 243, 233, 210)),),
            //       color: Color.fromARGB(999, 17, 75, 95),
            //       onPressed: (){},
            //     ),
            //   ],
            // ),
            // SizedBox(height: 10.0),
            Text(
              "FOOD WEIGHT : ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(999, 96, 91, 86)),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(foodWeight.toString(),
                    style: TextStyle(color: Color.fromARGB(999, 96, 91, 86))),
                // FlatButton.icon(
                //   icon: Icon(Icons.bluetooth_searching, color: Color.fromARGB(999, 243, 233, 210),),
                //   label: Text("GET", style: TextStyle(color: Color.fromARGB(999, 243, 233, 210)),),
                //   color: Color.fromARGB(999, 17, 75, 95),
                //   onPressed: (){
                //     if(_connected){
                //       _sendOnMessageToBluetooth();
                //     }
                //     else{
                //       Fluttertoast.showToast(msg: "Turn on bluetooth first!");
                //       bluetoothPopUp();
                //     }
                //   },
                // ),
              ],
            ),
            SizedBox(height: 30.0),
            FlatButton(
              color: Color.fromARGB(999, 17, 75, 95),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Text("ADD FOOD",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(999, 243, 233, 210))),
              onPressed: () {
                if (muncul == true) {
                  Fluttertoast.showToast(msg: "Foto sedang proses upload!");
                } else {
                  if (foodWeight == 0) {
                    Fluttertoast.showToast(msg: "Ambil data berat makanan!");
                  } else {
                    check();
                    Navigator.of(context).popAndPushNamed('/home');
                    Fluttertoast.showToast(msg: "Food added!");
                  }
                }
              },
            ),
          ]),
        ));
  }

  Widget btapp(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            // automaticallyImplyLeading: false,
            title: Text("Bluetooth"),
            backgroundColor: Color.fromARGB(999, 17, 75, 95),
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                label: Text(
                  "Refresh",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                splashColor: Colors.deepPurple,
                // onPressed: null,
                onPressed: () async {
                  // So, that when new devices are paired
                  // while the app is running, user can refresh
                  // the paired devices list.
                  await getPairedDevices().then((_) {
                    show('Device list refreshed');
                  });
                },
              ),
            ]),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: Text("Enable Bluetooth")),
                          Switch(
                            value: _bluetoothState.isEnabled,
                            onChanged: (bool value) {
                              future() async {
                                if (value) {
                                  await FlutterBluetoothSerial.instance
                                      .requestEnable();
                                } else {
                                  await FlutterBluetoothSerial.instance
                                      .requestDisable();
                                }
                                await getPairedDevices();
                                _isButtonUnavailable = false;

                                if (_connected) {
                                  _disconnect();
                                }
                              }

                              future().then((_) {
                                setState(() {
                                  Navigator.pop(context);
                                  bluetoothPopUp();
                                });
                              });

                              Navigator.pop(context);
                              bluetoothPopUp();
                            },
                          )
                        ],
                      ),
                      Text(
                        "List of paired devices:",
                        textAlign: TextAlign.start,
                      ),
                      DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (value) => setState(() => _device = value),
                        value: _devicesList.isNotEmpty ? _device : null,
                      ),
                      RaisedButton(
                        onPressed: _isButtonUnavailable
                            ? null
                            : _connected ? _disconnect : _connect,
                        child: Text(_connected ? 'Disconnect' : 'Connect'),
                      ),
                      RaisedButton(
                          child: Text("Back"),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                ])),
          ],
        ),
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      show('Wait until connected...');
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection.input.listen((Uint8List data) {
            print('Data incoming: ${ascii.decode(data)}');
            setState(() {
              sensorValue = '${ascii.decode(data)}';
              foodWeight = double.parse(sensorValue);
            });
          }).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection.close();
    show('Device disconnected');
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  // Method to send message,
  // for turning the Bluetooth device on
  void _sendOnMessageToBluetooth() async {
    connection.output.add(utf8.encode("1"));
    await connection.output.allSent;
    show('Device Turned On');
    setState(() {
      _deviceState = 1; // device on
    });
  }

  // Method to send message,
  // for turning the Bluetooth device off
  // void _sendOffMessageToBluetooth() async {
  //   connection.output.add(utf8.encode("0"));
  //   await connection.output.allSent;
  //   show('Device Turned Off');
  //   setState(() {
  //     _deviceState = -1; // device off
  //   });
  // }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
