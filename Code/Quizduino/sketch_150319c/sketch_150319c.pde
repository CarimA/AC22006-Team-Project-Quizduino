import java.util.Map;
import megamu.shapetween.*;
import java.util.*;
import processing.serial.*;
import cc.arduino.*;
import ddf.minim.*;
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

// audio management
AudioPlayer ap;
Minim minim;

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
  images.put("logo-s", loadImage("logo_small.png"));
  
  images.put("label", loadImage("question_label.png"));
  images.put("label-correct", loadImage("question_correct.png"));
  images.put("label-wrong", loadImage("question_wrong.png"));

  fonts = new HashMap<String, PFont>();
  fonts.put("neoteric", createFont("neoteric.ttf", 60));
  fonts.put("roboto", createFont("roboto-thin.ttf", 60));
  fonts.put("lobster", createFont("lobster.otf", 60));

  stateStack = new Stack<State>();
  pushStack(new stateSplash());
  
  questions = new QuestionManager();
  questions.loadQuestions();
  
  minim = new Minim(this);
  ap = minim.loadFile("song.mp3", 2048);
  ap.play();
  ap.loop();

  frameRate(120);      
}

void stop() 
{
  ap.close();
  minim.stop();
  super.stop();
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
  
  //if (shadow)
  //  {
    fill(0, 0, 0, 130);
    text(text, x, y + 3);
  //}
  
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
  //stateStack.peek().onEnd();
   stateStack.pop();
     //stateStack.peek().onSetup(this);
}

void getTweets()
{
  tickServo(20000);
  
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
      println("@" + status.getUser().getScreenName() + ":" + status.getText() + " [created at " + status.getCreatedAt() + "]");
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
     case 0: return "Zero";
     case 1: return "One";
     case 2: return "Two";
     case 3: return "Three";
     case 4: return "Four";
     case 5: return "Five";
     case 6: return "Six";
     case 7: return "Seven";
     case 8: return "Eight";
     case 9: return "Nine";
     case 10: return "Ten";
     case 11: return "Eleven";
     case 12: return "Twelve";
     case 13: return "Thirteen";
     case 14: return "Fourteen";
     case 15: return "Fifteen";
     case 16: return "Sixteen";
     case 17: return "Seventeen";
     case 18: return "Eighteen";
     case 19: return "Nineteen";
     case 20: return "Twenty";
     case 21: return "Twenty One";
     case 22: return "Twenty Two";
     case 23: return "Twenty Three";
     case 24: return "Twenty Four";
     case 25: return "Twenty Five";
     case 26: return "Twenty Six";
     case 27: return "Twenty Seven";
     case 28: return "Twenty Eight";
     case 29: return "Twenty Nine";
     case 30: return "Thirty";
     case 31: return "Thirty One";
     case 32: return "Thirty Two";
     case 33: return "Thirty Three";
     case 34: return "Thirty Four";
     case 35: return "Thirty Five";
     case 36: return "Thirty Six";
     case 37: return "Thirty Seven";
     case 38: return "Thirty Eight";
     case 39: return "Thirty Nine";
     case 40: return "Forty";
     case 41: return "Forty One";
     case 42: return "Forty Two";
     case 43: return "Forty Three";
     case 44: return "Forty Four";
     case 45: return "Forty Five";
     case 46: return "Forty Six";
     case 47: return "Forty Seven";
     case 48: return "Forty Eight";
     case 49: return "Forty Nine";
     case 50: return "Fifty";
     case 51: return "Fifty One";
     case 52: return "Fifty Two";
     case 53: return "Fifty Three";
     case 54: return "Fifty Four";
     case 55: return "Fifty Five";
     case 56: return "Fifty Six";
     case 57: return "Fifty Seven";
     case 58: return "Fifty Eight";
     case 59: return "Fifty Nine";
     case 60: return "Sixty";
     case 61: return "Sixty One";
     case 62: return "Sixty Two";
     case 63: return "Sixty Three";
     case 64: return "Sixty Four";
     case 65: return "Sixty Five";
     case 66: return "Sixty Six";
     case 67: return "Sixty Seven";
     case 68: return "Sixty Eight";
     case 69: return "Sixty Nine";
     case 70: return "Seventy";
     case 71: return "Seventy One";
     case 72: return "Seventy Two";
     case 73: return "Seventy Three";
     case 74: return "Seventy Four";
     case 75: return "Seventy Five";
     case 76: return "Seventy Six";
     case 77: return "Seventy Seven";
     case 78: return "Seventy Eight";
     case 79: return "Seventy Nine";
     case 80: return "Eighty";
     
     
   }
   return "";
}

private void ShuffleArray(int[] array)
{
    int index;
    int temp;
    Random random = new Random();
    for (int i = array.length - 1; i > 0; i--)
    {
        index = random.nextInt(i + 1);
        temp = array[index];
        array[index] = array[i];
        array[i] = temp;
    }
}

private void ShuffleArray(String[] array)
{
    int index;
    String temp;
    Random random = new Random();
    for (int i = array.length - 1; i > 0; i--)
    {
        index = random.nextInt(i + 1);
        temp = array[index];
        array[index] = array[i];
        array[i] = temp;
    }
}
      
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
  
  int timer = 30000;

  void onSetup(PApplet window)
  {
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
    drawText("roboto", "Respond with #g1q_" + randomCode + " <number of questions>\r\nOne question takes roughly one minute.", 60, 1920 / 2, textY + 150, CENTER, CENTER, false);

    drawText("roboto", "You have " + timer / 1000 + " seconds to enter how many questons you\r\nwant to play. The responses will be averaged to generate a quiz!\r\nResponses greater than 30 will be ignored.", 30, 1920 / 2, textY + 350, CENTER, CENTER, false);
  }

  void onEnd()
  {
    textTween = null;
  }
}

public class stateQuestion extends State
{
  boolean firstFrame;
  int timer = 20000;
   Question q;
   int qNo; 
   
   int[] index = { 0, 1, 2, 3 };
   int correctAnswer;
   String[] wrongAnswer;
   boolean delayFrame;
   
  void onSetup(PApplet window)
  {
    recentTweets = new HashMap<String, String>();
    randomCode = String.format("%04d", random.nextInt(9999));
    firstFrame = false;
    q = questions.getNextQuestion();
    qNo = questions.getQuestionNo();
    ShuffleArray(index);
    correctAnswer = index[0];
    wrongAnswer = q.wrongAnswers.split("\r\n");
    ShuffleArray(wrongAnswer);
    delayFrame = false;
  }

  void onUpdate()
  {    
    if (!recentTweets.isEmpty() && delayFrame)
    {
        tickServo(5000);
      // now, check if the questions are right, and display them.
      
      if (!questions.isLastQuestion())
      {
        pushStack(new stateQuestion());
      }
      else
      {
         // game's up!
         pushStack(new stateQuestion());
      }
    }

    if (firstFrame && !delayFrame)
    {
      tickServo(timer);
      pushStack(new stateLoading());    
    }
  }

  void onDraw()
  {
    drawImage("logo-s", 1500, 30);
    
    if (!recentTweets.isEmpty())
    {
      switch (index[0])
      {
        case 0:
        drawImage("label-correct", 37, 537);
        drawImage("label-wrong", 967, 537);
        drawImage("label-wrong", 37, 707);
        drawImage("label-wrong", 967, 707);
        break;
        
        case 1:
        drawImage("label-wrong", 37, 537);
        drawImage("label-correct", 967, 537);
        drawImage("label-wrong", 37, 707);
        drawImage("label-wrong", 967, 707);
        break;
        
        case 2:
        drawImage("label-wrong", 37, 537);
        drawImage("label-wrong", 967, 537);
        drawImage("label-correct", 37, 707);
        drawImage("label-wrong", 967, 707);
        break;
        
        case 3:
        drawImage("label-wrong", 37, 537);
        drawImage("label-wrong", 967, 537);
        drawImage("label-wrong", 37, 707);
        drawImage("label-correct", 967, 707);
        break;
      }        
      delayFrame = true;
    }
    else
    {
      drawImage("label", 37, 537);
      drawImage("label", 967, 537);
      drawImage("label", 37, 707);
      drawImage("label", 967, 707);
      
      drawText("roboto", "Respond with #g1q_" + randomCode + " <letter>", 60, 1920 / 2, 900, CENTER, CENTER, false);
      drawText("roboto", "You have " + timer / 1000 + " seconds enter your answer!", 30, 1920 / 2, 1000, CENTER, CENTER, false);
    }
    
    
    drawText("roboto", "A", 120, 70, 545, LEFT, TOP, true);
    drawText("roboto", "B", 120, 990, 545, LEFT, TOP, true);
    drawText("roboto", "C", 120, 70, 715, LEFT, TOP, true);
    drawText("roboto", "D", 120, 990, 715, LEFT, TOP, true);
    
    
    switch (index[0])
    {
      case 0: 
        //drawText("roboto", q.correctAnswer, 60, 160, 545, LEFT, TOP, true);
        drawQuestion(q.correctAnswer, 0);
        drawQuestion(wrongAnswer[0], 1);
        drawQuestion(wrongAnswer[1], 2);
        drawQuestion(wrongAnswer[2], 3);
                
        break;
        
      case 1:
        drawQuestion(q.correctAnswer, 1);
        drawQuestion(wrongAnswer[0], 0);
        drawQuestion(wrongAnswer[1], 2);
        drawQuestion(wrongAnswer[2], 3);
        
        break;
      
      case 2:
        drawQuestion(q.correctAnswer, 2);
        drawQuestion(wrongAnswer[0], 0);
        drawQuestion(wrongAnswer[1], 1);
        drawQuestion(wrongAnswer[2], 3);
        
        break;
      
      case 3:
        drawQuestion(q.correctAnswer, 3);
        drawQuestion(wrongAnswer[0], 0);
        drawQuestion(wrongAnswer[1], 1);
        drawQuestion(wrongAnswer[2], 2);
        break;
    }
         
    drawText("neoteric", "QUESTION " + getNumberAsWord(qNo).toUpperCase(), 120, 1920 / 2, 100, CENTER, CENTER, false);
    drawText("roboto", q.question, 60, 1920 / 2, 350, CENTER, CENTER, false);

     firstFrame = true;
  }

  void onEnd()
  {
  }
}

void drawQuestion(String text, int index)
{
  int x = 0, y = 0;
  switch (index)
   {
     case 0: x = 160; y = 575; break;
     case 1: x = 1080; y = 575; break;
     case 2: x = 160; y = 745; break;
     case 3: x = 1080; y = 745; break; 
   }
   
    if (text.contains("\n"))
    {
      // smaller size + newline
      drawText("roboto", text, 30, x, y, LEFT, TOP, true);
    }
    else
    {
     // normal size. 
       drawText("roboto", text, 60, x, y, LEFT, TOP, true);
    }
     
}

public class stateQuestionsToPlay extends State 
{   
  int average;
    boolean firstFrame;
  
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
        if (temp > 30) throw new Exception();
        
        total += temp;
        count++;
      }
      catch (Exception ex) { }
    }
     
    if (total == 0) total = 10; 
    if (count == 0) count = 1;
  
    average = total / count; 
    
    firstFrame = false;
  }

  void onUpdate()
  {
    if (firstFrame)
    {
      questions.newGame(average);
        delay(5000);
       pushStack(new stateQuestion());      
    }
  }

  void onDraw()
  {    
    drawText("roboto", "We are playing", 60, 1920 / 2, 1080 / 2 - 330, CENTER, CENTER, false);
    drawText("lobster", average + "", 600, 1920 / 2, 1080 / 2, CENTER, CENTER, true);
    drawText("roboto", "questions", 60, 1920 / 2, 1080 / 2 + 270, CENTER, CENTER, false);
    firstFrame = true;
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
    int count = 0;
    
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
  
  public int getQuestionNo()
  {
   return count; 
  }
  
  public Question getNextQuestion()
  {   
     count++;
     return game.remove(); 
  }
  
  public boolean isLastQuestion()
  {
     return game.size() == 1; 
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


