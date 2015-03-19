import java.util.Map;
import megamu.shapetween.*;
import java.util.*;
import processing.serial.*;
import cc.arduino.*;

// state management
public Stack<State> stateStack;
boolean displayLoading;

// serial management
Arduino ard;
int servoPin = 8;
int buzzerPin = 13;

// twitter management
Twitter twitter;

// asset management
HashMap<String, PImage> images;
HashMap<String, PFont> fonts;

// misc.
Random random = new Random();
String randomCode;

void setup()
{
  size(1920, 1080);
  
  ard = new Arduino(this, Arduino.list()[2], 57600);
  ard.pinMode(servoPin, 4);
  ard.pinMode(buzzerPin, Arduino.OUTPUT);
  
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("BkXp9P3M8KqpmQBpwtH4xaStG");
  cb.setOAuthConsumerSecret("3E5LMKw2ADPNPxqQMzd1JqtCoKJ6rNOVY91IEQetlJmwdiP4QB");
  cb.setOAuthAccessToken("3084147658-CXecwGKgNf6ReCxjQw0KHCYNQVEceoEFf5sNfhN");
  cb.setOAuthAccessTokenSecret("A5Odm9azVa9MurworwwPYMN3VjlcXtiypMD9SIpgQLv0P");
  twitter = new TwitterFactory(cb.build()).getInstance();
  
  images = new HashMap<String, PImage>();
  images.put("background", loadImage("bg.png"));
  images.put("logo", loadImage("logo.png"));

  fonts = new HashMap<String, PFont>();
  fonts.put("neoteric", createFont("neoteric.ttf", 60));
  fonts.put("roboto", createFont("roboto-thin.ttf", 60));
  fonts.put("lobster", createFont("lobster.otf", 60));

  stateStack = new Stack<State>();
  displayLoading = false;
  pushStack(new stateSplash());
  
  frameRate(120);
}

void draw()
{
  background(102);
  drawImage("background", 0, 0);
  
  if (!stateStack.empty())
    stateStack.peek().onDraw();
    
  if (displayLoading)
  {
    fill(0, 0, 0, 200);
    rect(0, 0, 1920, 1080);
    fill(255);
    drawText("neoteric", "Time's up!" , 120, 1920 / 2, 1080 / 2 - 100, CENTER, CENTER);
    drawText("roboto", "Quizduino is now collecting responses, \r\nany tweet sent after this time may not be collected!", 60, 1920 / 2, 1080 / 2 + 100, CENTER, CENTER);
  }
}

void drawImage(String image, float x, float y)
{
  image(images.get(image), x, y);
}

void drawText(String font, String text, int size, float x, float y, int alignX, int alignY)
{
  textFont(fonts.get(font), size);
  textAlign(alignX, alignY);
  text(text, x, y);
}

void tickServo(int time)
{
  int delayTime = time / 180;
  for (int i = 0; i < 180; i++)
  {
    ard.servoWrite(servoPin, i);
    delay(delayTime);
  }
}

void delay(int delay)
{
  int time = millis();
  while(millis() - time <= delay);
}

void pushStack(State state)
{
   if (!stateStack.empty())
     stateStack.peek().onEnd();
   stateStack.push(state); 
   stateStack.peek().onSetup(this);
}

public class stateSplash extends State 
{
   Tween logoTween;
   float logoY; 
   int logoTimer;
   int target;
   boolean switched;
   
   void onSetup(PApplet window)
   {
     logoTween = new Tween(window, 1, Tween.SECONDS, Shaper.BEZIER);
     logoY = -1200;
     logoTimer = millis();
     target = 60;
     switched = false;
   }
   
   void onDraw()
   {
     logoY = lerp(logoY, target, logoTween.position());
     drawImage("logo", 337, logoY);
     
     if (!switched)
     {
       if (millis() > logoTimer + 6000)
       {
         target = -1200;
        logoTween.end();
        logoTween.start();
        switched = true;
       } 
     }
     else
     {
        if (logoY <= -1200)
       {
          pushStack(new stateQuery());
       } 
     }

   }
   
   void onEnd()
   {
     logoTween = null;
   }
}

public class stateQuery extends State 
{
   Tween textTween;
   float textY;
   
   void onSetup(PApplet window)
   {
     textTween = new Tween(window, 1, Tween.SECONDS, Shaper.BEZIER);
     textY = 1200;
     randomCode = String.format("%04d", random.nextInt(9999));
   }
   
   void onDraw()
   {
     textY = lerp(textY, 540, textTween.position());
     
     drawText("neoteric", "HOW MANY QUESTIONS DO\r\nYOU WANT TO PLAY?", 120, 1920 / 2, textY - 150, CENTER, CENTER);
      drawText("roboto", "Respond with #g1q_" + randomCode + " <number of questions>", 60, 1920 / 2, textY + 150, CENTER, CENTER);

      drawText("roboto", "You have 30 seconds to enter how many questons you\r\nwant to play. The responses will be averaged to generate a quiz!", 30, 1920 / 2, textY + 250, CENTER, CENTER);

    if (textY <= 540)
    {
      tickServo(10000);
      displayLoading = true;
    }
   }
   
   void onEnd()
   {
     textTween = null;
   }
}

public abstract class State 
{
  abstract void onSetup(PApplet window);
  abstract void onDraw();
  abstract void onEnd();
}
