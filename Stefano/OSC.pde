import oscP5.*;
import netP5.*;
import controlP5.*;

int R = 40;
int G = 200;
int B = 200;
float alpha = 0.5 * (sqrt(2) - 1 + sqrt(2 * sqrt(2) - 1));
float beta = - 1 / pow((1 + alpha), 2);
float inNebula = 0;
float distance = 1;
float force = 0;

OscP5 oscP5;
NetAddress myRemoteLocation;

ControlP5 myController;

void setup() {
  frameRate(60);
  size(450, 250);
  
  myController = new ControlP5(this);
  
  myController.addSlider("DISTANCE SLIDER", 1, 0, 0.8, 40, 40, 300, 40);
  myController.addSlider("FORCE SLIDER", 0, 1, 0.8, 40, 100, 300, 40);
  myController.addToggle("NEBULA", false, 40, 160, 40, 40);
  
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 57120); 
}

void draw() {
  background(51);
  fill(255, 204);

  distance = myController.getController("DISTANCE SLIDER").getValue();
  
  force = beta + 1 / pow((distance + alpha), 2);
  myController.getController("FORCE SLIDER").setValue(force);
  
  inNebula = myController.getController("NEBULA").getValue();
  
  println("distance: " + distance);
  println("force: " + force);
  println("is in nebula: " + inNebula);
  
  OscMessage myMessage = new OscMessage("/OSCTest");
  myMessage.add(distance);
  myMessage.add(inNebula);
  oscP5.send(myMessage, myRemoteLocation);
  println(myMessage);
}
