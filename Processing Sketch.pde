
 // Graphing sketch
 
 
 // This program takes ASCII-encoded strings
 // from the serial port at 9600 baud and graphs them. It expects values in the
 // range 0 to 1023, followed by a newline, or newline and carriage return
 
 // Created 20 Apr 2005
 // Updated 18 Jan 2008
 // by Tom Igoe
 // This example code is in the public domain.
 
 import processing.serial.*;
 
 Serial myPort;        // The serial port
 int xPos = 1;         // horizontal position of the graph
 
 void setup () {
 if (frame != null) {
 frame.setResizable(true);
 // set the window size:
 size(displayWidth , displayHeight);       
 frameRate(24); 
 }
 // List all the available serial ports
 println(Serial.list());
 // I know that the first port in the serial list on my mac
 // is always my  Arduino, so I open Serial.list()[0].
 // Open whatever port is the one you're using.
 myPort = new Serial(this, Serial.list()[0], 9600);
 // don't generate a serialEvent() unless you get a newline character:
 myPort.bufferUntil('\n');
 // set inital background:
 background(0);
 }
 void draw () {
 // everything happens in the serialEvent()

 }
 
// void serialEvent (Serial myPort) {
// // get the ASCII string:
// String inString = myPort.readStringUntil('\n');
// 
// if (inString != null) {
// // trim off any whitespace:
// inString = trim(inString);
// // convert to an int and map to the screen height:
// float inByte = float(inString);
// inByte = map(inByte, 0, 1023, 0, height);
// //background(255);
// // draw the line:
// background(255);
//
// fill(255,0,255);
// //line(xPos, height, xPos, height - inByte);
// ellipse(displayWidth/4,displayHeight/3,abs(inByte),abs(inByte));
// 
// // at the edge of the screen, go back to the beginning:
// 
// }
// }
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
        //print(i + ": " + raw[i] + "\t(" + rawMin[i] + "|" + rawMax[i] +")\t");
    }
    println();
    
    //print("scaled: ");
    //scale raw sensor values
    for (int i=0; i<sensors.length; i++) {      
      scaledVal[i] = height * (raw[i] - minAnalogVal) / maxAnalogVal;
      scaledMin[i] = height * (rawMin[i] - minAnalogVal) / maxAnalogVal;
      scaledMax[i] = height * (rawMax[i] - minAnalogVal) / maxAnalogVal;
      //print(i + ": " + scaledVal[i] + "\t(" + scaledMin[i] + "|" + scaledMax[i] +")\t");
    }
    //println();
  }

  //request more data from controller 
  myPort.write('\r'); 
}

