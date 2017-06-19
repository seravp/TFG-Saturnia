#include <Servo.h>
#include <Wire.h>

Servo miServo;

int estado=-1;
int pos=0;
int angulo=2;

void setup()
{
  Wire.begin(1);  //Inicializa bus i2c
  Wire.onReceive(receiveEvent); // Registramos el evento al recibir datos
  miServo.attach(9);
}

// Función que se ejecuta siempre que se reciben datos del master
// siempre que en el master se ejecute la sentencia endTransmission
// recibirá toda la información que hayamos pasado a través de la sentencia Wire.write
void receiveEvent(int howMany) {
  char opcion;
  
  // Si hay una dato que leer
  if (Wire.available() == 1)
  {
  // Leemos el bus
  opcion = Wire.read();
  if(opcion=='a'){
    angulo+=90; 
  }else if(opcion=='z'){
    angulo-=90;
  }
    angulo=constrain(angulo,0,180);
    miServo.write(angulo);
  }
}

void loop(){
  delay(300);
}
