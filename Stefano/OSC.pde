import oscP5.*;
import netP5.*;
import controlP5.*;

int R = 40;
int G = 200;
int B = 200;
float alpha = 0.5 * (sqrt(2) - 1 + sqrt(2 * sqrt(2) - 1));
float beta = - 1 / pow((1 + alpha), 2);
float diskSize = 80;
float mass = 1;
float rotSpeed = 0;
float temp = 1000;
float dist = 1;
float force = 0;

OscP5 oscP5;
NetAddress myRemoteLocation;

ControlP5 myController;

void setup() {
  frameRate(60);
  size(450, 420);
  
  myController = new ControlP5(this);
  
  myController.addSlider("DISTANCE", 1, 0, 0.8, 40, 40, 300, 40);
  myController.addSlider("FORCE", 0, 1, 0.8, 40, 100, 300, 40);
  myController.addSlider("DISK SIZE", 80, 500, 80, 40, 160, 300, 40);
  myController.addSlider("MASS", 1, 20, 1, 40, 220, 300, 40);
  myController.addSlider("ROTATION SPEED", 0, 10, 0, 40, 280, 300, 40);
  myController.addSlider("TEMPERATURE", 1000, 10000, 1000, 40, 340, 300, 40);
  
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 57120); 
}

void draw() {
  background(51);
  fill(255, 204);

  dist = myController.getController("DISTANCE").getValue();
  force = beta + 1 / pow((dist + alpha), 2);
  myController.getController("FORCE").setValue(force);
  diskSize = myController.getController("DISK SIZE").getValue();
  mass = myController.getController("MASS").getValue();
  rotSpeed = myController.getController("ROTATION SPEED").getValue();
  temp = myController.getController("TEMPERATURE").getValue();
  
  println("distance: " + dist);
  println("force: " + force);
  println("disk size: " + diskSize);
  println("disk size: " + mass);
  println("disk size: " + rotSpeed);
  println("disk size: " + temp);
  
  OscMessage myMessage = new OscMessage("/OSCTest");
  myMessage.add(dist);
  myMessage.add(diskSize);
  myMessage.add(mass);
  myMessage.add(rotSpeed);
  myMessage.add(temp);
  oscP5.send(myMessage, myRemoteLocation);
  println(myMessage);
}
