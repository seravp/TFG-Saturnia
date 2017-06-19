import processing.serial.*; //Importamos la librería Serial
import gifAnimation.*;
import controlP5.*;
ControlP5 cp5;
Serial puerto;

/*Definicion de todas la variables*/


int[] PC_Time = new int [3]; 
int[] Fecha = new int [3]; 
int grados=24;

PFont font12, font22, font44, font36;  //Fuentes

String fecha_act, hora_act;

boolean encimaAbrirGeneral=false;        //Si hemos pulsado encima del boton abrir general
boolean encimaCerrarGeneral=false;       //Si hemos pulsado encima del boton cerrar general
boolean encimaAbrirAgua=false;        //Si hemos pulsado encima del boton abrir agua
boolean encimaCerrarAgua=false;       //Si hemos pulsado encima del boton cerrar agua
boolean encimaAbrirAire=false;        //Si hemos pulsado encima del boton abrir aire
boolean encimaCerrarAire=false;       //Si hemos pulsado encima del boton cerrar aire
boolean bloqueado=true;               //Si el sistema esta bloqueado, es decir apagado
boolean encimaOn=false;               //Si estamos encima de la palanca de encendido
boolean valAbierAire=false;           //Si esta abierta la valvula del aire
boolean valAbierAgua=false;           //Si esta abierta la valvula del agua
boolean valAbierGeneral=false;        //Si esta abierta la valvula del agua
boolean aireAuto=false;               //Si esta activado el llenado de aire automatico
boolean aireManual=true;              //Si esta activado el llenado de aire manual
boolean encimaAire=false;             //Si hemos pulsado encima del boton del aire
boolean aguaAuto=false;               //Si esta activado el llenado de agua automatico
boolean aguaManual=true;              //Si esta activado el llenado de agua manual
boolean encimaAgua=false;             //Si hemos pulsado encima del boton del agua
boolean generalAuto=false;               //Si esta activado el llenado de aire automatico
boolean generalManual=true;              //Si esta activado el llenado de aire manual
boolean encimaGeneral=false;             //Si hemos pulsado encima del boton del aire
boolean encimaLanzar=false;
boolean encimaCambioAgua=false;
boolean encimaCambioGeneral=false;
boolean encimaCambioAire=false;
boolean lanzado=false;
boolean listoAire=false;
boolean listoAgua=false;
boolean error=false;
boolean encimaEvacuar=false;
boolean encimaContinuar=false;

PrintWriter output;

//definicion de imagenes

PImage icono;            //Imagen de cohete
PImage AireOff;          //Aire apagado
PImage AireAu;           //Aire automatico
PImage AireMa;           //Aire manual
PImage AguaOff;          //Agua apagado
PImage AguaAu;           //Agua automatico 
PImage AguaMa;           //Agua manual 
PImage GeneralOff;       //General apagado -> Evacuacion
PImage GeneralAu;        //General automatico -> Evacuacion
PImage GeneralMa;        //General Manual -> Evacuacion
PImage botonAaire;       //Boton abrir aire 
PImage botonCaire;       //Boton cerrar aire 
PImage botonAagua;       //Boton abrir agua
PImage botonCagua;       //Boton cerrar agua
PImage botonAgeneral;    //Boton abrir Evacuacion
PImage botonCgeneral;    //Boton cerrar Evacuacion
PImage MedidorFluido;    //Medidor de agua
PImage Fluido;           //Relleno azul de agua
PImage marco;            
PImage apagado;          //Interruptoe apagado
PImage encendido;        //Interruptor encendido
PImage barometro;        //Medidor de aire
PImage rotulo;           //Nombre del sistema
PImage lanzar;           //Boton de lanzamiento
PImage listoOnAgua;      //Luz verde de agua
PImage listoOffAgua;     //Luz apagada de agua
PImage listoOnAire;      //Luz verde aire
PImage listoOffAire;     //Luz apagada aire
PImage botonesError;     //Boton de error
PImage peligroError;     //icono de peligro


//------------------------------------------------------------------------------------------
/*Variables de pruebas*/

float cantidad =0;  
float aire=0;
int topeaire=10;
int topeagua=10;
int tamx=500;
int tamy=600;
float topeCritico=200000;
String mensaje = null;
String msg="holaaaaa";
String msg2="holaaaaa";



//------------------------------------------------------------------------------------------

//Cargamos todas la imagenes iniciales del panel de control

void setup(){
  size(1600,1000);
  font12 = loadFont("MicrosoftYaHei-12.vlw");
  font22 = loadFont("MicrosoftYaHei-22.vlw");
  font44 = loadFont("FranklinGothic-Demi-32.vlw");
  font36 = loadFont("Calibri-Bold-36.vlw");
  botonAagua =loadImage("botonAbrir.PNG");
  botonCagua =loadImage("botonCerrar.PNG");
  botonAaire =loadImage("botonAbrir.PNG");
  botonCaire =loadImage("botonCerrar.PNG");
  botonAgeneral =loadImage("botonAbrir.PNG");
  botonCgeneral =loadImage("botonCerrar.PNG");
  Fluido= loadImage("fluido.PNG");
  marco= loadImage("marco.PNG");
  botonesError= loadImage("Error.PNG");
  peligroError= loadImage("w00.jpg");
  MedidorFluido=loadImage("medidorFluido.PNG");
  //puerto = new Serial(this, Serial.list()[0], 115200);
  puerto = new Serial(this, Serial.list()[1], 115200); //bluetooth
  

  apagado=loadImage("bloqueo off.PNG");
  encendido=loadImage("bloqueo on.PNG");
  barometro=loadImage("barometro.PNG");
  AireOff=loadImage("MaAuOffAire.PNG");
  AireAu=loadImage("AutomaticoAire.PNG");
  AireMa=loadImage("ManualAire.PNG");
  AguaOff=loadImage("MaAuOff.png");
  AguaAu=loadImage("Automatico.png");
  AguaMa=loadImage("Manual.png");
  GeneralOff=loadImage("MaAuOffGene.png");
  GeneralAu=loadImage("AutomaticoGene.png");
  GeneralMa=loadImage("ManualGene.png");
  icono=loadImage("85173.gif");
  rotulo=loadImage("saturnia.png");
  lanzar=loadImage("lanzar.PNG");
  listoOnAgua=loadImage("ListoOn.PNG");
  listoOffAgua=loadImage("ListoOff.PNG");
  listoOnAire=loadImage("ListoOn.PNG");
  listoOffAire=loadImage("ListoOff.PNG");
 //println(Serial.list());
  cp5 = new ControlP5(this);
  
  //Funcion para crear los campos de texto de entrada de valores.
  
  cp5.addTextfield("Presion")
     .setPosition(1250,650)
     .setSize(100,40)
     .setFont(font22)
     .setColorBackground(206)
     .setFocus(true)
     .setAutoClear(false)
     .setColor(color(206,206,206));
     
     cp5.addTextfield("Agua")
     .setPosition(1120,325)
     .setSize(100,40)
     .setFont(font22)
     .setColorBackground(206)
     .setFocus(true)
     .setAutoClear(false)
     .setColor(color(206,206,206));
       
}

//Funcion principal del programa

void draw(){
  
  background(206,206,206);        //color de fondo de la aplicacion
  grados=calculaGrados(aire);    //tansformacion del numero de aire a grados que gira la aguja
  update();
  text(cp5.get(Textfield.class,"Presion").getText(), 360,130);    //campo de lectura
   
      
  fill(28,19,170);
  hora_act= PC_Time();      //guarda la hora
  fecha_act = PC_Date();    //guarda la fecha
  
  cargarImagenes();      //funcion que carga todas las imagenes
    
  if(bloqueado){            //Funcionamiento del sistema
    if(keyPressed){
      if(key=='b' || key=='B'){
          bloqueado=false;
          puerto.write('b');
          delay(100);
      }
    }
  }else{
    if(keyPressed){
      accionTecla();
    }
    
    if(puerto.available()>0){         //Si se encuentra algo en el puerto
       mensaje=puerto.readStringUntil('\n');    //leer del puerto
    }
   
    if(mensaje!=null){
      String[] values = new String[2];      //Creacion de array
      values[0]="0";    //Se ha inicializado a un valor para salvar el error de vacio.                
      values[1]="0";    //Se ha inicializado a un valor para salvar el error de vacio. 
      values = split(mensaje,',');    //Se guardan los valores leidos del puerto en values
      cantidad=0;
      aire =0;
      msg= values[0];       //Se copia el valor a otra variable auxiliar         
      msg2= values[1];      //Se copia el valor a otra variable auxiliar 
      cantidad= float(msg);        //Conversion a float
      aire= float(msg2);           //Conversion a float
      aire =aire -157.0;            //calibracion del valor de presión
    }  
    println("Agua= "+cantidad+"     Presion: "+aire);    //imprimir en terminal para revision
    
    if((valAbierAire==true)){
      if(aire < 10){
        if(aire>=topeaire && aire <(topeaire+0.2) ){
          listoAire=true;
          valAbierAire=false; 
          puerto.write('p');
        }//else                    //aumento sin lectura
           //aire+=0.01;
      }else{
        valAbierAire=false;
      }
    }
    
    if((valAbierAgua==true)){
      if(cantidad < 10){
        if(cantidad>=topeagua && cantidad <(topeagua+0.2)){
          listoAgua=true;
          valAbierAgua=false;
          puerto.write('n');
        }//else           //aumento sin lectura
         // cantidad+=0.01;
      }else{
        valAbierAgua=false;
      }
    }
    
    if(cantidad>topeCritico || aire>topeCritico){
      Error();       
    }if(cantidad>8)
      tamx=0;
      tamy=0;
    } 
}


void Error(){
  fill(206,206,206);    //color de fondo
  rect(500,200,tamx,tamx);  //tamaño de ventana
  puerto.write('n');        //cierre de valvula de agua
  valAbierAgua=false;       //se cierra valvula agua
  puerto.write('p');        //cierre de valvula de aire    
  valAbierAire=false;       //se cierra valvula aire
  //puerto.write('k');        
  //valAbierGeneral=false;
  error=true;               // se ha generado el error
  image(botonesError,530,520,450,110);    //carga de botones
  image(peligroError,530,230,170,170);    //carga imagen de alerta
  fill(24,4,118);        
  textFont(font36);        //fuente para escribir
  text("Los niveles de agua o presión",530,430);     
  text("han alcandado valores", 530, 460);
  text("peligrosos.", 530, 490);
  fill(255,255,255);
  
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
    if(theEvent.getName() == "Agua")
      topeagua=int (theEvent.getStringValue());
    else
      topeaire=int (theEvent.getStringValue());
  }
}

//Carga la imagen del fluido contenido en el medidor

void dibujarFluido(){
  
  float unidad=14.4;
  float movi=13.8;
  float posY=539.8;
  float tamY;
  posY=posY-(movi*cantidad);
  tamY=(unidad*cantidad);
  image(Fluido,968,posY,70,tamY); 
}

//Funcion que detemina la tecla pulsada y que accion realiza

void accionTecla(){
      
  if(key=='v' || key=='V'){      //Tecla v pone a 0 la cantidad de agua
    cantidad=0;
    listoAgua=false;
    delay(100);
  }
   
  if(key=='b' || key=='B'){      //Tecla b enciende y apaga el sistema
    bloqueado=true;
    puerto.write('b');
    puerto.write('p');
    puerto.write('n');
    delay(100);
  }
  
  if(key=='t' || key=='T'){      //Tecla t aumenta manualmente el valor del aire
    if(grados < 344){
      aire+=0.1;
      delay(100);
    }
  }
    
  if(key=='y' || key=='Y'){      //Tecla y pone a 0 la presion
    if(grados >24){
      aire=0;
      listoAire=false;
      delay(100);
    }
  }
    
  if((key=='p' || key=='P') && aireManual){      //Tecla p cierra valvula aire
    puerto.write('p'); 
    valAbierAire=false;
    delay(100);
  }
    
  if((key=='o' || key=='O')){      //Tecla o abre valvula aire
    puerto.write('o'); 
    valAbierAire=true;
    delay(100);
  }    
   
  if((key=='q' || key=='Q')){     //Tecla q cambia de modo manual a automatico el aire
    if(!aireAuto){
      puerto.write('q'); 
      aireAuto=true;
      aireManual=false;
      delay(100);
    }else{
      puerto.write('q'); 
      aireAuto=false;
      aireManual=true;
      delay(100);
    } 
  }
  
  if(key=='m' || key=='M'){      //Tecla m abre valvula agua
    //cantidad=cantidad+0.1;
    puerto.write('m');
    valAbierAgua=true;
    delay(100);
  }
  
  if((key=='n' || key=='N') && aguaManual){      //Tecla m cierra valvula agua
    puerto.write('n');
    valAbierAgua=false;
    delay(100);
  }
  
  if((key=='w' || key=='W')){     //Tecla w cambia de modo manual a automatico el agua
    if(!aguaAuto){
      puerto.write('w'); 
      aguaAuto=true;
      aguaManual=false;
      delay(100);
    }else{
      puerto.write('w'); 
      aguaAuto=false;
      aguaManual=true;
      delay(100);
    } 
  }
  
  if((key=='g' || key=='g')){     //Tecla g cambia de modo manual a automatico la valvula general
    if(!generalAuto){
      puerto.write('g'); 
      generalAuto=true;
      generalManual=false;
      delay(100);
    }else{
      puerto.write('g'); 
      generalAuto=false;
      generalManual=true;
      delay(100);
    } 
  }
  
  if(key=='h' || key=='h'){      //Tecla h abre valvula general
    //cantidad=cantidad+0.1;
    valAbierGeneral=true;
    delay(100);
  }
  
  if((key=='j' || key=='j') && generalManual){    //Tecla j abre valvula general
    //puerto.write('p'); 
    valAbierGeneral=false;
    delay(100);
  }
}

//Carga todas la imagenes necesarias para el control de mandos en las posiciones establecidas

void cargarImagenes(){
  strokeWeight(4);
  fill(131,121,121);
  rect(360,310,900,310); //cuadro agua
  rect(360,635,1040,330); //cuadro aire
  rect(900,15,690,280); //cuadro general
  rect(360,90,510,170); //cuadro logo
  rect(1280,310,310,310); //cuadro lanzar
  
  image(marco,420,530,400,70); //marco de los botones agua
  image(botonAagua,455,540,130,50);
  image(botonCagua,655,540,130,50);
  
  image(marco,420,850,400,70); //marco de los botones aire
  image(botonAaire,455,860,130,50);
  image(botonCaire,655,860,130,50);
  
  image(marco,1030,210,400,70); //marco de los botones general
  image(botonAgeneral,1065,220,130,50);
  image(botonCgeneral,1265,220,130,50);
  
  image(marco,910,355,170,230); //marco del medidor de fluido
  image(MedidorFluido,940,385,110,170);
  
  image(barometro,910,650,300,300);      //imagen del barometro
  if(bloqueado){                          //Carga interrupto encendido o apagado
    image(apagado,70,175,250,200);    
  }else{
    image(encendido,70,175,250,200);
  }
  
  //Carga las imagenes de manual y automatico de agua aire y general
  
  if(bloqueado){
    image(AguaOff,380,330,490,170);
  }else{
    if(aguaManual)
      image(AguaMa,380,330,490,170);    
    else if (aguaAuto)
      image(AguaAu,380,330,490,170);     
  }
  
  if(bloqueado){
    image(AireOff,380,650,490,170);
  }else{
    if(aireManual)
      image(AireMa,380,650,490,170);    
    else if (aireAuto)
      image(AireAu,380,650,490,170);     
  }
  
  if(bloqueado){
    image(GeneralOff,990,30,490,170);
  }else{
    if(generalManual)
      image(GeneralMa,990,30,490,170);    
    else if (generalAuto)
      image(GeneralAu,990,30,490,170);     
  }
  
  //Dibuja el relleno del indicador de agua
    
  dibujarFluido();
  fill(24,4,118);
  rect(75,45,220,100);
  
  fill(250);
  textFont(font44);
  text(hora_act,90,80);
  text(fecha_act, 90, 120);
  
  fill(234,93,21);
  textFont(font12);
  text("Realizado por Sera Velez", 1300, 990);
  
  fill(5,8,77);
  textFont(font36);
  text("ON/OFF", 130, 230);
  
  strokeWeight(1);
  fill(234,93,21);
  aguja(grados);          //Aguja y centro barometro
  ellipse(1058,798,30,30);
  
  image(icono,35,415,300,400);        //ponemos imagen cohete
  image(rotulo,380,110,470,130);      //ponemos imagen SATURNIA
  image(lanzar,1310,340,250,250);     // boton de lanzar
  
  if(listoAgua)                    //Led verde de listo agua
    image(listoOnAgua,1120,400);
  else
    image(listoOffAgua,1120,400);
    
  if(listoAire)                     //Led verde de listo aire
    image(listoOnAire,1250,720);
  else
    image(listoOffAire,1250,720);
    
  fill(206,206,206);
  rect(1120,500,100,40);    //rectangulo contador agua
  rect(1240,830,120,40);    //rectangulo contador aire
  textFont(font22);
  
  fill(24,4,118);
  text(cantidad, 1125, 530);  //Contador digital agua
  text("L", 1200, 530);
  text(aire, 1245, 860);      //Contador difital aire
  text("bar", 1320, 860);    
  
}

//Funcion que calcula si el raton se encuentra dentro de un area establecida

boolean overRect(int x, int y, int width, int height){
  if(mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height){
    return true;
  }else{
    return false;
  }
}

//Nos cambia el valor de las variables dependiendo de la posicion del raton

void update(){
    
  if(overRect(455,540,130,50)){
    encimaAbrirAgua=true;
  }else{
    encimaAbrirAgua=false;
  }
  
  if(overRect(655,540,130,50)){
    encimaCerrarAgua=true;
  }else{
    encimaCerrarAgua=false;
  }
  
  if(overRect(95,240,50,85)){
    encimaOn=true;
  } else{
    encimaOn=false;
  } 
  
  if(overRect(455,860,130,50)){
    encimaAbrirAire=true;
  }else{
    encimaAbrirAire=false;
  }
  
  if(overRect(655,860,130,50)){
    encimaCerrarAire=true;
  }else{
    encimaCerrarAire=false;
  }
  
  if(overRect(1065,220,130,50)){
    encimaAbrirGeneral=true;
  }else{
    encimaAbrirGeneral=false;
  }
  
  if(overRect(1265,220,130,50)){
    encimaCerrarGeneral=true;
  }else{
    encimaCerrarGeneral=false;
  }
  
  if(overRect(1350,400,140,140)){
    encimaLanzar=true;
  }else{
    encimaLanzar=false;
  }
  
  if(overRect(585,742,85,40)){
    encimaCambioAire=true;
  }else{
    encimaCambioAire=false;
  }
  
  if(overRect(585,425,85,40)){
    encimaCambioAgua=true;
  }else{
    encimaCambioAgua=false;
  }
  
  if(overRect(1195,125,85,40)){
    encimaCambioGeneral=true;
  }else{
    encimaCambioGeneral=false;
  }
  
  if(overRect(785,554,138,50)){
    encimaEvacuar=true;
  }else{
    encimaEvacuar=false;
  }
  
  if(overRect(583,554,138,50)){
    encimaContinuar=true;
  }else{
    encimaContinuar=false;
  }  
}

//Acciones a realizar cuando se pulsa el raton

void mousePressed(){
  if(encimaContinuar  && !bloqueado && error){ //mensaje de error
    error=false;
  }
    
  if(encimaAbrirAgua  && !bloqueado && !error){ 
    puerto.write('m');
    valAbierAgua=true;
  }
  
  if(encimaCerrarAgua  && !bloqueado && aguaManual && !error) { 
    valAbierAgua=false;
    puerto.write('n');
  }
  
  if(encimaAbrirAire  && !bloqueado && !error){ 
    puerto.write('o'); 
    valAbierAire=true;
  }
  
  if(encimaCerrarAire  && !bloqueado && aireManual && !error) { 
    valAbierAire=false;
    puerto.write('p');
  }
  
  if(encimaLanzar && !bloqueado && !valAbierAire && !valAbierAgua && !valAbierGeneral && !error){
    if(!lanzado){
      puerto.write('a');  
      lanzado=true;
    }else{
      puerto.write('z'); 
      lanzado=false;  
    }
  }
  
  if(encimaAbrirGeneral  && !bloqueado && !error){ 
    puerto.write('l');
    valAbierGeneral=true;
  }
  
  if(encimaCerrarGeneral  && !bloqueado && generalManual && !error) { 
    valAbierGeneral=false;
    puerto.write('k');
  }
  
  if(encimaCambioAgua && !bloqueado && !error){
    if(aguaManual){
      aguaManual=false;
      aguaAuto=true;
    }else{
      aguaManual=true;
      aguaAuto=false;
    }    
  }
  
  if(encimaCambioAire && !bloqueado && !error){
    if(aireManual){
      aireManual=false;
      aireAuto=true;
    }else{
      aireManual=true;
      aireAuto=false;
    }    
  }
  
  if(encimaCambioGeneral && !bloqueado && !error){
    if(generalManual){
      generalManual=false;
      generalAuto=true;
    }else{
      generalManual=true;
      generalAuto=false;
    }    
  }
  
  if(encimaOn ) {
    if(bloqueado){
      bloqueado=false;
      //puerto.write('p');
      //puerto.write('n');
      valAbierAgua=false;
      valAbierAire=false;
      valAbierGeneral=false;
      cp5.get(Textfield.class,"Presion").clear();
    }else{
      bloqueado=true;
      if(valAbierAire)
        puerto.write('p');
      else if(valAbierAgua)
        puerto.write('n');
        
      valAbierAgua=false;
      valAbierAire=false;
      valAbierGeneral=false;
      cp5.get(Textfield.class,"Presion").clear();
    }
  }  
}

//Realiza las rotaciones y traslaciones necesarias para la aguja del barometro

void aguja(float giro){
  if (giro<180){
    pushMatrix();
    translate(1054,798);
    rotate(radians(giro));
    triangle(0, 0, 8, 0, 4, 75);
    popMatrix();
  }else{
    pushMatrix();
    translate(1060,798);
    rotate(radians(giro));
    triangle(0, 0, 8, 0, 4, 75);
    popMatrix();
  }
}


//Calcula la rotacion necesaria de la imagen dependiendo del valor recibido de la presión

int calculaGrados(float valor){
  int multiplicador=32;
  if(valor <=6 && valor >=5){
  grados=(int)(valor*multiplicador)+20;
  }else
  grados=(int)(valor*multiplicador)+24;
  return grados;
}

//Funcion que calcula hora actual

String PC_Time(){
  PC_Time[2] = second();
  PC_Time[1] = minute();
  PC_Time[0] = hour();
  return join(nf(PC_Time,2), " : ");
}

//Funcion que calcula fecha actual

String PC_Date(){
  Fecha[2] =year();
  Fecha[1] =month();
  Fecha[0] =day();
  return join(nf(Fecha,2), " -");
}