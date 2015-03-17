#include <Servo.h> 

const int servoPin = 8;

Servo myservo;  // create servo object to control a servo

void setup()
{
  myservo.attach(servoPin);  // attaches the servo on pin 8 to the servo object  
  Serial.begin(9600);
}

void loop()
{

    // go from 0-180 degrees
  for(int i=0; i < 180; i++)   
  { 
    myservo.write(i);                // tell servo to move to new position 
    delay(118);                      // wait (20 seconds/180?)
  }
  
}
