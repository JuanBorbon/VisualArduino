

import processing.serial.*;

Serial myPort;
final int linefeed = 10;

//maximum number of sensors to display
final int maxSensors = 6;

//raw analog input values from controller
int raw[];
int rawMin[];
int rawMax[];
int max = 15; // max size of each dot
int row;
int column;

//values scaled to fit screen
float scaledVal[];
float scaledMin[];
float scaledMax[];
float prevScaledVal[];

//min/max values of analog input from controller
final int minAnalogVal = 0;
final int maxAnalogVal = 1024;

//colors used to draw sensor graphs
color colors[];

int xCursor = 0;

//length of each line segment in graph, 1=1 pixel
final int plotLineLength = 1;

PFont myFont;
final int fontSize = 12;

final int drawDelay = 10;

boolean madeContact = false;


void setup() {
  //println( Serial.list() );
  
  myPort = new Serial(this, Serial.list()[0], 9600);  
  myPort.bufferUntil(linefeed);
  
  //initialize raw vars
  raw = new int[maxSensors];
  rawMin = new int[maxSensors];
  for (int i = 0; i<rawMin.length; i++) {
    rawMin[i] = 2147483647;
  }
  rawMax = new int[maxSensors];

  //initialize scaled vars
  scaledVal = new float[maxSensors];
  scaledMin = new float[maxSensors];
  for (int i = 0; i<scaledMin.length; i++) {
    scaledMin[i] = 2147483647 ;
  }
  scaledMax = new float[maxSensors];

  prevScaledVal = new float[maxSensors];

  //set colors used for each sensor display
  colors = new color[maxSensors];
  colors[0] = color(255, 0, 0); //red
  colors[1] = color(0, 255, 0); //green
  colors[2] = color(0, 0, 255); //blue
  colors[3] = color(255, 255, 0); //yellow
  colors[4] = color(0, 255, 255); //teal
  colors[5] = color(255, 0, 255); //purple
      
  size(displayWidth , displayHeight);       
  background(255);
}

void draw() {

  background(255);

  if(madeContact==false) {
    //start handshake w/controller
    myPort.write('\r');
  } else {
    
    for (int i = 0; i < scaledVal.length; i++) {
      
      fill(colors[i]);     // make each circle a different color 
      if (i < 3){          // places each circle
        row = 1;
        column = i+1;
      }
      else{
        row = 2;
        column = i-2;
      }
        
      //Draws each circle
      ellipse(column*displayWidth/4, row*displayHeight/3, max*abs(scaledVal[i]), max*abs(scaledVal[i]));   
      prevScaledVal[i] = scaledVal[i];
    }
    

    
    delay(drawDelay);
  }
}


void serialEvent(Serial myPort) {
 
  madeContact = true;

  String rawInput = myPort.readStringUntil(linefeed);

  if (rawInput != null) {
    rawInput = trim(rawInput);
    
    int sensors[] = int(split(rawInput, ','));
    
    //print("raw: ");
    //read in raw sensor values
    for (int i=0; i<sensors.length; i++) {
        raw[i] = sensors[i];
        rawMin[i] = min(rawMin[i], raw[i]);
        rawMax[i] = max(rawMax[i], raw[i]);
    }
    println();
    
    for (int i=0; i<sensors.length; i++) {      
      scaledVal[i] = max * (raw[i] - minAnalogVal) / maxAnalogVal;
      scaledMin[i] = max * (rawMin[i] - minAnalogVal) / maxAnalogVal;
      scaledMax[i] = max * (rawMax[i] - minAnalogVal) / maxAnalogVal;
    }

  }

  //request more data from controller 
  myPort.write('\r'); 
}
