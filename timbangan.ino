#include <SoftwareSerial.h>
#include "HX711.h"
#define DOUT  A1
#define CLK  A0

HX711 scale;

float calibration_factor = 930;
float GRAM;
const int buttonPin = A5;
int buttonState = 0;
String convert;
int step=0;
int beratrata=0;

bool ambilBerat = false;
char command = 0;

SoftwareSerial module_bluetooth(10, 11); // pin RX | TX


void setup() 
{
    Serial.begin(9600); //menggunakan komunikasi serial softawre IDE pada 9600 bps
    Serial.println("Input command AT:");
    module_bluetooth.begin(9600); //Baudrateb module bluetooth
    scale.begin( DOUT, CLK);
    scale.set_scale();
    scale.tare();
    pinMode(buttonPin,INPUT);
}
void loop() {
    scale.set_scale(calibration_factor);
    buttonState = analogRead(buttonPin);
    if(buttonState >1000)
     {
          scale.tare();
     }
    //Membaca terhubungnya koneksi HC05 dengan arduino pada serial Monitor
    if (module_bluetooth.available())
    {
      command = module_bluetooth.read();
      Serial.write(command); 
    }
      
    if(command=='1')
    { 
      ambilBerat = true;
      Serial.println("masuk mode ambil berat");
      command = 0;
    }
    if(ambilBerat)
    {
      Serial.println("sampling data");
      GRAM = scale.get_units(), 4;
          if (GRAM <= 0){
             GRAM = 0;
          }
         beratrata+=GRAM;
          
            if(step==20){
              beratrata = beratrata/step;
              convert = String(beratrata);
              convert = " "+convert;
              
              
              Serial.println(beratrata);
              module_bluetooth.println(convert);
              step=-1;
              beratrata=0;
              ambilBerat=false;
            }
      step++;
   }
   delay(50);
}
