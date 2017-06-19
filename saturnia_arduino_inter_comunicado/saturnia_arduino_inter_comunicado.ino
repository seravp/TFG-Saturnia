#include <TimerOne.h>
#include <Wire.h>
#include <SoftwareSerial.h>   // Incluimos la librería  SoftwareSerial 
SoftwareSerial BT(10,11);    // Definimos los pines RX y TX del Arduino conectados al Bluetooth

int presionPin=0;
int relayPin=13;
int relayPin2=12;
int relayPin3=8;
float lecturaPresion;

int hallsensor = 2;
String mensaje;
int vueltas=0;
float lit;

void rpm ()      //Esta es la funcion que llama a la interrupcion
{ 
 vueltas++; 
} 

void litros(int medida){    //funcion que pasa el numero de vueltas a litros
  lit=(medida*500.0)/1530.0; 
  lit=lit/1000; 
}

void setup() {
  BT.begin(115200);       // Inicializamos el puerto serie BT que hemos creado
  pinMode(hallsensor, INPUT);   //Sensor de flujo de agua a entrada
  pinMode(relayPin, OUTPUT);    //pin del rele1 a salida
  pinMode(relayPin2, OUTPUT);   //pin del rele2 a salida
  pinMode(relayPin3, OUTPUT);   //pin del rele3 a salida
  digitalWrite(relayPin, HIGH); //Inicializamos a alta el rele 1
  digitalWrite(relayPin2, HIGH); //Inicializamos a alta el rele 2
  digitalWrite(relayPin3, HIGH); //Inicializamos a alta el rele 3
  attachInterrupt(0, rpm, RISING);  //Interrupcion para sensor de flujo 
  Timer1.initialize(250000);
  Timer1.attachInterrupt(comunicar);  //llamada a interrupcion de comunicacion
  Wire.begin();   //Abrir el puerto de comunicacion i2c

  
}

void comunicar(){   //Escribimos en el puerto bluetooth
  BT.println(mensaje);
}

void loop() {
  unsigned char blue=0;
  lecturaPresion=(analogRead(presionPin));    //Leemos del sensor de presion
  String p=String(lecturaPresion); 
  litros(vueltas);
  String l=String(lit);
 
 
  
  if( (BT.available())){    //Si hay algo en el puerto leemos
    blue=BT.read();
    
    if(blue=='a'){    //Si lo que hemos leido es a
      Wire.beginTransmission(1);      
      Wire.write('a');    //Mandamos por i2c a la otra placa arduino
      Wire.endTransmission();
    }else if(blue=='z'){    //Si lo que hemos leido es z
      Wire.beginTransmission(1);
      Wire.write('z');        //Mandamos por i2c a la otra placa arduino
      Wire.endTransmission();   
    }else if(blue=='p') digitalWrite(relayPin, HIGH);
    else if(blue=='o') digitalWrite(relayPin, LOW);
    else if(blue=='n') digitalWrite(relayPin2, HIGH);
    else if(blue=='m') digitalWrite(relayPin2, LOW);
    else if(blue=='k') digitalWrite(relayPin3, HIGH);
    else if(blue=='l') digitalWrite(relayPin3, LOW); 
    
  }
  
   interrupts();   
   mensaje= String(l+","+p);  
}
