void setup()
{
  //size(500, 500);
  size(1920, 1080);
  background(255);  


}

void draw()
{
  
  // Load text file as a string
  String[] answersList = loadStrings("answers.txt");
  String[] questionsList = loadStrings("questions.txt");
  // Convert string into an array of strings using ',' as a delimiter
  String[] answers = (split(answersList[0],','));
  String[] questions = (split(questionsList[0],','));
  
  //String[] questions= {"What's good for your eyes?", "Question 2:...."};
  //String[] answers={"Apples", "Carrots", "Cucumbers", "Strawberries"};
  
  int xPos=560; //where the rectangles are located
  int yPos=400;
  
  int xSide=250; //size of rectangle sides
  int ySide=80;
  
  
  /*
  if (mousePressed && (mouseButton == LEFT)) 
  {
    //fill(0);
  } 
  else if (mousePressed && (mouseButton == RIGHT))
  {
    //fill(255);
  } 
  else 
  {
    //fill(126);
  }
  */
  textSize(25);
  
  //fill(255);
  //rect(xPos, yPos, xSide, ySide);
  fill(204, 102, 0);
  text(questions[0], xPos, yPos-250);
  
  
  fill(255);
  rect(xPos, yPos, xSide, ySide);
  fill(204, 102, 0);
  text(answers[0], xPos+20, yPos+50);
  
  fill(255);
  rect(xPos, yPos+150, xSide, ySide);
  fill(204, 102, 0);
  text(answers[1], xPos+20, yPos+200);
  
  fill(255);
  rect(xPos+350, yPos, xSide, ySide);
  fill(204, 102, 0);
  text(answers[2], xPos+370, yPos+50);
  
  fill(255);
  rect(xPos+350, yPos+150, xSide, ySide);
  fill(204, 102, 0);
  text(answers[3], xPos+370, yPos+200);
  
}


void loop()
{
  //
  
}
