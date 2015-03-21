import java.util.Map;
import megamu.shapetween.*;
import java.util.*;
import processing.serial.*;
import cc.arduino.*;

// state management
public Stack<State> stateStack;

// serial management
Arduino ard;
int servoPin = 8;
int buzzerPin = 13;

// twitter management
Twitter twitter;
HashMap<String, String> recentTweets;

// asset management
HashMap<String, PImage> images;
HashMap<String, PFont> fonts;

// question management
QuestionManager questions;

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
  recentTweets = new HashMap<String, String>();

  images = new HashMap<String, PImage>();
  images.put("background", loadImage("bg.png"));
  images.put("logo", loadImage("logo.png"));

  fonts = new HashMap<String, PFont>();
  fonts.put("neoteric", createFont("neoteric.ttf", 60));
  fonts.put("roboto", createFont("roboto-thin.ttf", 60));
  fonts.put("lobster", createFont("lobster.otf", 60));

  stateStack = new Stack<State>();
  pushStack(new stateSplash());
  
  questions = new QuestionManager();
  questions.loadQuestions();

  frameRate(120);
}

void draw()
{
  background(102);
  drawImage("background", 0, 0);

  if (!stateStack.empty())
  {
    stateStack.peek().onUpdate();      
    stateStack.peek().onDraw();
  }
}

void drawImage(String image, float x, float y)
{
  image(images.get(image), x, y);
}

void drawText(String font, String text, int size, float x, float y, int alignX, int alignY, boolean shadow)
{
  textFont(fonts.get(font), size);
  textAlign(alignX, alignY);
  
  if (shadow)
    {
    fill(0, 0, 0, 130);
    text(text, x, y + 3);
  }
  
  fill(255);
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
  while (millis () - time <= delay);
}

void pushStack(State state)
{
  if (!stateStack.empty())
    stateStack.peek().onEnd();
  stateStack.push(state); 
  stateStack.peek().onSetup(this);
}

void popStack() // really, this should return something, but the functionality isn't really needed.
{
  stateStack.peek().onEnd();
   stateStack.pop();
     stateStack.peek().onSetup(this);
}

void getTweets()
{
  delay(20000);
  
  recentTweets.put("ignore", "ignore");

  Query query = new Query("#g1q_" + randomCode);
  query.setCount(50);
  try
  {
    QueryResult result = twitter.search(query);
    for (Status status : result.getTweets ())
    {
      try 
      {
        String temp = status.getText();
        temp = temp.toLowerCase();
        temp = temp.replace("#g1q_" + randomCode, "");
        temp = temp.replace("@quizduino", "");
        temp = temp.trim();

        recentTweets.put(status.getUser().getName(), temp);
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
}

String getNumberAsWord(int input)
{
   switch (input)
   {
     case 0: return "zero";
     case 1: return "one";
     case 2: return "two";
     case 3: return "three";
     case 4: return "four";
     case 5; return "five";
     case 6; return "six";
     case 7; return "seven";
     case 8; return "eight";
     case 9; return "nine";
     case 10; return "ten";
     case 11; return "eleven";
     case 12; return "twelve";
     case 13; return "thirteen";
     case 14; return "fourteen";
     case 15; return "fifteen";
     case 16; return "sixteen";
     case 17; return "seventeen";
     case 18; return "eighteen";
     case 19; return "nineteen";
     case 20; return "tweenty";
     case 21; return "twenty one";
     case 22; return "twenty two";
     case 23; return "twenty three";
     case 24; return "twenty four";
     case 25; return "twenty five";
     case 26; return "twenty six";
     case 27; return "twenty seven";
     case 28; return "twenty eight";
     case 29; return "twenty nine";
     case 30; return "thirty";
     case 31; return "thirty one";
     case 32; return "thirty two";
     case 33; return "thirty three";
     case 34; return "thirty four";
     case 35; return "thirty five";
     case 36; return "thirty six";
     case 37; return "thirty seven";
     case 38; return "thirty eight";
     case 39; return "thirty nine";
     case 40; return "fourty";
      
public class stateLoading extends State
{
   boolean firstFrame;
   void onSetup(PApplet window)
  {
      recentTweets = new HashMap<String, String>();
      firstFrame = false;
  } 
  
  void onUpdate()
  {
    if (firstFrame)     
      getTweets();
    
    if (!recentTweets.isEmpty())
      popStack();
  }
  
  void onDraw()
  {
    fill(255);
    drawText("neoteric", "Time's up!", 120, 1920 / 2, 1080 / 2 - 100, CENTER, CENTER, true);
    drawText("roboto", "Quizduino is now collecting responses, \r\nany tweet sent after this time may not be collected!", 60, 1920 / 2, 1080 / 2 + 100, CENTER, CENTER, true);   
    firstFrame = true;
  }
  
  void onEnd()
  {
    
  }
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

  void onUpdate()
  {

    logoY = lerp(logoY, target, logoTween.position());


    if (!switched)
    {
      if (millis() > logoTimer + 6000)
      {
        target = -1200;
        logoTween.end();
        logoTween.start();
        switched = true;
      }
    } else
    {
      if (logoY <= -1200)
      {
        pushStack(new stateQuery());
      }
    }
  }

  void onDraw()
  {
    drawImage("logo", 337, logoY);
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
  
  int timer = 2000;

  void onSetup(PApplet window)
  {
    recentTweets = new HashMap<String, String>();

    textTween = new Tween(window, 1, Tween.SECONDS, Shaper.BEZIER);
    textY = 1200;
    randomCode = String.format("%04d", random.nextInt(9999));
  }

  void onUpdate()
  {
    textY = lerp(textY, 540, textTween.position());

    if (textY <= 540)
    {
      tickServo(timer);
      
      pushStack(new stateQuestionsToPlay());
      pushStack(new stateLoading());
    }
  }

  void onDraw()
  {

    drawText("neoteric", "HOW MANY QUESTIONS DO\r\nYOU WANT TO PLAY?", 120, 1920 / 2, textY - 150, CENTER, CENTER, false);
    drawText("roboto", "Respond with #g1q_" + randomCode + " <number of questions>", 60, 1920 / 2, textY + 150, CENTER, CENTER, false);

    drawText("roboto", "You have " + timer / 1000 + " seconds to enter how many questons you\r\nwant to play. The responses will be averaged to generate a quiz!", 30, 1920 / 2, textY + 250, CENTER, CENTER, false);
  }

  void onEnd()
  {
    textTween = null;
  }
}


public class stateQuestionsToPlay extends State 
{   
  int average;
  boolean hadResponse;
  
  void onSetup(PApplet window)
  {
    int count = 0;
    int total = 0;
    
    for (String value : recentTweets.values ())
    {
      println(value);
      try {
        int temp = Integer.parseInt(value);
        if (temp <= 0) throw new Exception();
        if (temp > 40) throw new Exception();
        
        total += temp;
        count++;
      }
      catch (Exception ex)
      {
      }
    }
     
    hadResponse = true;
    if (total == 0 && count == 0) hadResponse = false;
    
    if (total == 0) total = 20;
    if (count == 0) count = 1;
  
    average = total / count; 
    
    questions.newGame(average);
  }

  void onUpdate()
  {
    drawText("roboto", "We are playing", 60, 1920 / 2, 1080 / 2 - 330, CENTER, CENTER, false);
    drawText("lobster", average + "", 600, 1920 / 2, 1080 / 2, CENTER, CENTER, true);
    drawText("roboto", "questions", 60, 1920 / 2, 1080 / 2 + 270, CENTER, CENTER, false);
    
  }

  void onDraw()
  {
  }

  void onEnd()
  {
  }
}


public abstract class State 
{
  abstract void onSetup(PApplet window);
  abstract void onUpdate();
  abstract void onDraw();
  abstract void onEnd();
}

class QuestionManager
{
    QuestionList questions = new QuestionList();
    Queue<Question> game;
    
  public void loadQuestions()
  {
    String[] qs = loadStrings("questions.txt");
    
    StringBuilder builder = new StringBuilder();
    for(String s : qs) {
        builder.append(s);
    }
    String qss = builder.toString();
   
    Gson gson = new GsonBuilder().create();
    questions = gson.fromJson(qss, QuestionList.class);
  }
  
  public void newGame(int x)
  {
     Collections.shuffle(questions.questions);
    game = new LinkedList<Question>(questions.questions.subList(0, x));    
  }
}

class QuestionList
{
  List<Question> questions = new ArrayList<Question>();
}

class Question
{
  private String question;
  private String correctAnswer;
  private String wrongAnswers;

}


