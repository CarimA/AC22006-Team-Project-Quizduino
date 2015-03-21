import java.util.Map;
import megamu.shapetween.*;
import java.util.*;
import processing.serial.*;
import cc.arduino.*;

Arduino ard;
int servoPin = 8;
int buzzerPin = 13;

Twitter twitter;
    
HashMap<String, PImage> images;
HashMap<String, PFont> fonts;
int state;
int ticks;

final int STATE_INTRO = 0;
final int STATE_AMOUNT = 1;
final int STATE_QUESTION = 2;
final int STATE_FINISHED = 3;
final int STATE_POINTS = 4;
final int STATE_DATA = 5;

int randomCode;

void setup() {
  size(1920, 1080);
  
  ard = new Arduino(this, Arduino.list()[0], 57600);
  ard.pinMode(servoPin, 4);
  ard.pinMode(buzzerPin, Arduino.OUTPUT);
  
  Random r = new Random();
  randomCode = r.nextInt(8999) + 1000;
  
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
  fonts.put("neoteric", createFont("neoteric.ttf", 120));
  fonts.put("roboto", createFont("roboto-thin.ttf", 60));

  state = STATE_INTRO;

  // initialise any tweens.
  logoY = new Tween(this, 0.5, Tween.SECONDS, Shaper.BEZIER);
  logoY.pause();
  tempLogoY = 60;
  tempLogoYTimer = millis();
  amountY = new Tween(this, 0.5, Tween.SECONDS, Shaper.BEZIER);
  amountY.pause();
  tempTextY = -400;
  
  QuestionManager q = new QuestionManager();
  q.load();
}

void draw() {
  background(102);
  drawImage("background", 0, 0);
  switch(state)
  {
  case STATE_INTRO: 
    drawStateIntro(); 
    break;
  case STATE_AMOUNT: 
    drawStateAmount(); 
    break;
  }


  //drawText("neoteric32", "testing", 32, 50, 50, LEFT, TOP);
}

// #### STATE MANAGEMENT - INTRO
Tween logoY;
float tempLogoY;
float tempLogoYTimer;
void drawStateIntro()
{
  tempLogoY = lerp(tempLogoY, 1200, logoY.position());
  drawImage("logo", 337, tempLogoY);

  if (millis() > tempLogoYTimer + 5000)   
    logoY.resume();

  if (tempLogoY >= 1200)
  {
    logoY.end();
    state = STATE_AMOUNT;
    amountY.resume();
  }
}

// ### STATE MANAGEMENT - AMOUNT
Tween amountY;
float tempTextY;
void drawStateAmount()
{
  tempTextY = lerp(tempTextY, 1080 / 2, amountY.position());
  drawText("neoteric", "HOW MANY QUESTIONS DO\r\nYOU WANT TO PLAY?", 120, 1920 / 2, tempTextY - 150, CENTER, CENTER);
  drawText("roboto", "Respond with #g1q_" + randomCode + " <number of questions>", 60, 1920 / 2, tempTextY + 150, CENTER, CENTER);

  drawText("roboto", "You have 30 seconds to enter how many questons you\r\nwant to play. The responses will be averaged to generate a quiz!", 30, 1920 / 2, tempTextY + 250, CENTER, CENTER);

  if (tempTextY >= 1080 / 2)
  {
    logoY = null;
    amountY = null;
    
    tickServo(30000);
    
    delay(20000);
    // time to get the Twitter responses! 
  Query query = new Query("#g1q_" + randomCode);
  query.setCount(50);
  int total = 0; int count = 0;
  try
  {
    QueryResult result = twitter.search(query);
    for (Status status : result.getTweets())
    {
      try 
      {
        String temp = status.getText();
        temp = temp.toLowerCase();
        temp = temp.replace("#g1q_" + randomCode, "");
        temp = temp.replace("@quizduino", "");
        temp = temp.trim();
        total += Integer.parseInt(temp);
        count++;
      }
      catch (Exception ex)
      {
        //println("error" + ex);
      }
      //println("@" + status.getUser().getScreenName() + ":" + status.getText() + " [created at " + status.getCreatedAt() + "]");
    }  
  }
  catch (TwitterException tex)
  {
    //println("twitter error" + tex);
  }
  
  boolean hadResponse = true;
  
  if (total == 0 && count == 0) hadResponse = false;
  
  if (total == 0) total = 20;
  if (count == 0) count = 1;
  
  int questionNo = total / count; 

println(questionNo);
delay(500000);
  }
}

// #### HELPER METHODS
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

class QuestionManager
{
  ArrayList<Question> questions;
  Queue<Question> gameQuestions; 

  public void load()
  {
    //JSONObject json = loadJSONObject("questions.json");
    //println(json);
    
  }

  public void startGame()
  {
    // randomise the questions and stick it into a queue.
  }

  public Question getQuestion()
  {
    // get the question on the top of the queue.
    return new Question();
  }
}

class Question
{
  private String question;
  private String correctAnswer;
  private String[] wrongAnswers;
}

