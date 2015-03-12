#include <SimpleTimer.h>

// the timer object
SimpleTimer timer;

// a function to be executed periodically
void repeatMe() 
{
    Serial.print("Question time is up!");  
    Serial.println("Uptime (s): ");
    Serial.println(millis() / 1000);
    
}

void setup()
{
    Serial.begin(9600);
    
    //if the user hasn't tweeted the answer
    {
      timer.setInterval(20000, repeatMe);
    }
}

void loop()
{
  //load next question
  //load interface with processing  
  timer.run(); //start timer
}

