import oscP5.*;
import netP5.*;
import controlP5.*;

int R = 40;
int G = 200;
int B = 200;
float diskSize = 200;
float mass = 5;
float rotSpeed = 4.5;
float temp = 1000;
float dist = 0;

OscP5 oscP5;
NetAddress myRemoteLocation;

ControlP5 myController;

void setup() {
  frameRate(60);
  size(450, 360);
  
  myController = new ControlP5(this);
  
  myController.addSlider("DISTANCE", 2.4, 1, 2, 40, 40, 300, 40);
  myController.addSlider("DISK SIZE", 80, 500, 200, 40, 100, 300, 40);
  myController.addSlider("MASS", 1, 20, 5, 40, 160, 300, 40);
  myController.addSlider("ROTATION SPEED", 0, 10, 4.5, 40, 220, 300, 40);
  myController.addSlider("TEMPERATURE", 1000, 10000, 1000, 40, 280, 300, 40);
  
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 57120); 
}

void draw() {
  background(51);
  fill(255, 204);

  dist = myController.getController("DISTANCE").getValue();
  diskSize = myController.getController("DISK SIZE").getValue();
  mass = myController.getController("MASS").getValue();
  rotSpeed = myController.getController("ROTATION SPEED").getValue();
  temp = myController.getController("TEMPERATURE").getValue();
  
  println("distance: " + dist);
  println("disk size: " + diskSize);
  println("blackhole mass: " + mass);
  println("disk rotation speed: " + rotSpeed);
  println("disk temperature: " + temp);
  
  OscMessage myMessage = new OscMessage("/BlackHoleParams");
  myMessage.add(dist);
  myMessage.add(diskSize);
  myMessage.add(mass);
  myMessage.add(rotSpeed);
  myMessage.add(temp);
  oscP5.send(myMessage, myRemoteLocation);
  println(myMessage);
}
