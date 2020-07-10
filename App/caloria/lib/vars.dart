
bool loading = true;

//String link = "http://192.168.42.64/protel/"; //USB tethering winnona
//String link = "http://192.168.43.46/protel/"; //localhost wifi winnona laptop hp
//String link = "https://b401telematics.com/Deep/"; //hosting b401
// String link = "http://komputer-its.com/Winyon/"; //hosting tekkom
String link = "http://192.168.43.185/caloria/"; //localhost robby
// String link = "http://192.168.43.223/caloria/"; //localhost wifi winnona asus

//homepage.dart
List meal = ["Breakfast", "Lunch", "Dinner", "Snack"];
DateTime tanggals = DateTime.now();

//drawer
bool warn = false;
String warning = "";

//homepage.dart, flexiable class
double cal=0, carb=0, pro=0, fat=0, chol=0, sgr=0;
double calPercent = 0, carbPercent=0, proPercent=0, fatPercent=0;

//profile.dart, flexiable class
  String name = 'no name';
  String gender = '';
  String actLevel = '';
  String goal = '';
  String height = '';
  String weight = '';
  String birthdate = '';
  double bmr = 0;
  double bmi = 0;
  int bmiStatus=0;
  // DateTime now = DateTime.now();
  String tglSkrg = '';
  String ages = '';
  int age = 0,
      tgl = 0,
      bln = 0,
      thn = 0,
      tglLahir = 0,
      blnLahir = 0,
      thnLahir = 0;

double totalCal=0, totalCarb=0, totalPro=0, totalFat=0;
