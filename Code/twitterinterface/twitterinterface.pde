PFont Neoteric, Roboto;

void setup()
{
  //size(500, 500);
  size(1920, 1080);
  background(255);  
  
  
  Neoteric = createFont("NEOTERIC-Regular.ttf", 25);
  Roboto = createFont("Roboto-Regular.ttf", 25);
  


}

void draw()
{
  
  background(255);  //reset
  int i=0; //get i from .ino file?
  
  // Load text file as a string
  String[] answersList = loadStrings("answers.txt");
  String[] questionsList = loadStrings("questions.txt");
  // Convert string into an array of strings using ',' as a delimiter
  String[] answers = (split(answersList[0],','));
  String[] questions = (split(questionsList[0],','));
  
  
  int xPos=560; //where the rectangles are located
  int yPos=400;
  
  int xSide=250; //size of rectangle sides
  int ySide=80;

  textFont(Roboto, 25);
  fill(204, 102, 0);
  text(questions[i], xPos, yPos-250);
  
  
  textFont(Neoteric, 25);
  fill(255);
  rect(xPos, yPos, xSide, ySide);
  fill(204, 102, 0);
  text(answers[i*4], xPos+20, yPos+50);
  
  fill(255);
  rect(xPos, yPos+150, xSide, ySide);
  fill(204, 102, 0);
  text(answers[i*4+1], xPos+20, yPos+200);
  
  fill(255);
  rect(xPos+350, yPos, xSide, ySide);
  fill(204, 102, 0);
  text(answers[i*4+2], xPos+370, yPos+50);
  
  fill(255);
  rect(xPos+350, yPos+150, xSide, ySide);
  fill(204, 102, 0);
  text(answers[i*4+3], xPos+370, yPos+200);
  
}


void loop()
{
  //
  
}
