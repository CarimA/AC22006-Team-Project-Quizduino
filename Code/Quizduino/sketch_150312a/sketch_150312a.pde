import java.util.Map;
import megamu.shapetween.*;
import java.util.*;

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

void setup() {
  size(1920, 1080);

  images = new HashMap<String, PImage>();
  images.put("background", loadImage("bg.png"));
  images.put("logo", loadImage("logo.png"));

  fonts = new HashMap<String, PFont>();
  fonts.put("neoteric_large", createFont("neoteric.ttf", 120));
  fonts.put("roboto_thin_normal", createFont("roboto-thin.ttf", 60));
  fonts.put("roboto_thin_small", createFont("roboto-thin.ttf", 30));

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
  drawText("neoteric_large", "HOW MANY QUESTIONS DO\r\nYOU WANT TO PLAY?", 120, 1920 / 2, tempTextY - 150, CENTER, CENTER);
  drawText("roboto_thin_normal", "Respond with #g1q", 60, 1920 / 2, tempTextY + 150, CENTER, CENTER);

  drawText("roboto_thin_small", "You have 20 seconds to enter how many questons you\r\nwant to play. The responses will be averaged to generate a quiz!", 30, 1920 / 2, tempTextY + 250, CENTER, CENTER);
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

class QuestionManager
{
  ArrayList<Question> questions;
  Queue<Question> gameQuestions; 

  public void load()
  {
    JSONObject json = loadJSONObject("questions.json");
    println(json);
    
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
