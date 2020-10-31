// GIF Loop controlled by MIDI 
// Pilar Mera, from Daniel Shiffman Coding Train
// https://thecodingtrain.com/CodingChallenges/135-gif-loop.html
// https://youtu.be/nBKwCCtWlUg

import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; 

MidiBus myBus; // The MidiBus

int totalFrames = 120;
int bgColor = 0;
int strokeColor = 255;
int counter = 0;
int strokeWidth = 1;
int squareSize = 100; //square size
boolean record = false;

void setup() {
  size(400, 400);
  MidiBus.list();
  myBus = new MidiBus(this, 0, -1); // choose input device number from MidiBus.list(), mine is 0;
}

void draw() {
  float percent = 0;
  if (record) {
    percent = float(counter) / totalFrames;
  } else {
    percent = float(counter % totalFrames) / totalFrames;
  }
  render(percent);
  if (record) {
    saveFrame("output/gif-"+nf(counter, 3)+".png");
    if (counter == totalFrames-1) {
      exit();
    }
  }
  counter++;
}

void render(float percent) {
  float angle = map(percent, 0, 1, 0, TWO_PI);
  background(bgColor);
  translate(width/2, height/2);
  rotate(angle);
  stroke(strokeColor);
  strokeWeight(strokeWidth);
  noFill();
  rectMode(CENTER);
  square(0, 0, squareSize);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
  
  // change CC numbers accordingly to your controller
  switch(number){
    case 21: // speed up
      totalFrames = totalFrames + 10;
      break;
    case 22: // sepped down
      totalFrames = totalFrames - 10;
      break;
    case 7: // enlarge shape
      squareSize = int(map(value,0,127,10,300));
      break;
    case 32: // change bg color
      bgColor = int(map(value, 0, 127, 0, 255));
      break;
    case 33: // change stroke color
      strokeColor = int(map(value, 0, 127, 0, 255));
      break;
    case 34: // change stroke width
      strokeWidth = int(map(value, 0, 127, 1, 100));
      break;      
  }
}
