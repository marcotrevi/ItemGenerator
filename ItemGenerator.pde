math math = new math();
utils utils = new utils();
errors errors = new errors();
items items = new items();
boolean latex = false; // writes latex tags
Table T = new Table();
float time, timeOld, resetTime, timePauseStart, timePauseStop, pauseTime, elapsedTime = 0;
float maxTime = 5*1000;
item I;
String[] choices = new String[4];
int W = 1000; 
int H = 600;
float h = 50;
color c1, c2, c3, c4;
int[] perms = new int[4];
int indexPressed = -1;
int indexAnswer = -1;
boolean getNewItem = true;
boolean answered = false;
boolean start = false;
boolean pause = false;
IntList[] history = new IntList[3];
int[] c = {0, 0, 0};
boolean correct = false;

void setup() {
  size(1000, 600);
  utils.initTable();
  c1 = color(50, 50, 50);
  c2 = color(50, 50, 50);
  c3 = color(50, 50, 50);
  c4 = color(50, 50, 50);

  history[0] = new IntList();
  history[1] = new IntList();
  history[2] = new IntList();

  for (int i=0; i<1; i++) {
    monomial m1 = utils.generateMonomial(c);
    //  monomial m2 = utils.generateMonomial(-2);
    //monomial m3 = utils.generateNonSimilar(m1, 1);
    String _m1 = m1.stringify();
    //    println("complexity ("+c[0]+","+c[1]+","+c[2]+"): "+_m1);
    //    c = utils.smoothStep(c);
    //    c = utils.step(c, floor(random(0, 3)), floor(random(0,2)));
  }
  //String _m2 = m2.stringify();
  //String _m3 = m3.stringify();

  //utils.generateItem("x^2-y^2", c).printme();
  //utils.generateItem("(x+y)(x-y)", c).printme();
  getNewItem(c);
  /*
  I = utils.generateItem("x^2+y^2+2xy", c);
   choices = shuffleChoices(I);
   getAnswer();
   startTimer();
   */
  //utils.generateItem("(x+y)^2", c).printme();

  //utils.generateCsv(T, "(x+y)^2", 0.5, 10, "binomial_square_compact");
}

void draw() {
  // start timer
  if (!pause) {
    time = (millis() - pauseTime - resetTime) % maxTime;
  }

  elapsedTime = time-timeOld;
  background(0);
  buttons();  
  displayItem();
  progressBar();
  displayHistory();

  if (elapsedTime < 0) {
    // cycle is complete
    timeIsUp();
    getNewItem = true;
    answered = false;
  }
  timeOld = time;
}

void displayHistory() {
  noStroke();
  for (int i=0; i<history[0].size(); i++) {
    fill(255, 50, 50);
    ellipse(10+i*5, H-5*history[0].get(i)-10, 5, 5);
    fill(50, 255, 50);
    ellipse(10+i*5, H-5*history[1].get(i)-10, 4, 4);
    fill(100, 100, 255);
    ellipse(10+i*5, H-5*history[2].get(i)-10, 3, 3);
  }
}

void startTimer() {
  start = true;
}

void resetTimer() {
  resetTime = millis();
  pauseTime = 0;
}

void togglePause() {
  pause = !pause;
  if (pause) {
    timePauseStart = millis();
  } else {
    timePauseStop = millis();
    pauseTime = pauseTime + (timePauseStop - timePauseStart);
  }
}

String[] shuffleChoices(item I) {
  String[] choices = new String[4];
  choices[0] = I.answer+" (*)";
  choices[1] = I.distractors[0];
  choices[2] = I.distractors[1];
  choices[3] = I.distractors[2];
  perms = utils.permutation(4);
  String[] shuffle = new String[4];
  shuffle[0] = choices[perms[0]];
  shuffle[1] = choices[perms[1]];
  shuffle[2] = choices[perms[2]];
  shuffle[3] = choices[perms[3]];
  return shuffle;
}

void getAnswer() {
  indexAnswer = -1;
  for (int i=0; i<4; i++) {
    if (perms[i] == 0) {
      indexAnswer = i;
    }
  }
}

void getNewItem(int[] complexity) {
  correct = false;
  I = utils.generateItem("x^2+y^2+2xy", complexity);
  choices = shuffleChoices(I);
  getAnswer();
  history[0].append(complexity[0]);
  history[1].append(complexity[1]);
  history[2].append(complexity[2]);
}

void timeIsUp() {
  getNewItem(c);
  c1 = color(50);
  c2 = color(50);
  c3 = color(50);
  c4 = color(50);
}

void mousePressed() {
  if (120 < mouseY && mouseY < 120+h) {
    indexPressed = 0;
    if (indexPressed == indexAnswer) {
      c1 = color(0, 100, 0);
      correct = true;
    }  
    answered = true;
  } else if (120+h < mouseY && mouseY < 120+2*h) {
    indexPressed = 1;
    if (indexPressed == indexAnswer) {
      c2 = color(0, 100, 0);
      correct = true;
    }  
    answered = true;
  } else if (120+2*h < mouseY && mouseY < 120+3*h) {
    indexPressed = 2;
    if (indexPressed == indexAnswer) {
      c3 = color(0, 100, 0);
      correct = true;
    }  
    answered = true;
  } else if (120+3*h < mouseY && mouseY < 120+4*h) {
    indexPressed = 3;
    if (indexPressed == indexAnswer) {
      c4 = color(0, 100, 0);
      correct = true;
    }  
    answered = true;
  } else if (120+4*h < mouseY && mouseY < 120+5*h) {
    togglePause();
  }
  if (answered) {
    manageComplexity();
    resetTimer();
  }
}

void manageComplexity() {
  if (correct) {
    c = utils.smoothStep(c);
  }
}

void displayItem() {
  fill(255);
  textSize(24);
  text(I.stem, 100, 80);
  displayChoices(choices);
}

void progressBar() {
  noStroke();
  fill(255, 0, 0);
  rect(0, 0, time/maxTime*float(W), 20);
}

void buttons() {
  // buttons
  stroke(0);
  fill(c1);
  rect(0, 120, W, 50);
  fill(c2);
  rect(0, 120+h, W, 50);
  fill(c3);
  rect(0, 120+2*h, W, 50);
  fill(c4);
  rect(0, 120+3*h, W, 50);
  if (pause) {
    fill(150);
  } else {
    fill(100);
  }
  rect(0, 120+4*h, W, 50);
}

void displayChoices(String[] choices) {
  text(choices[0], 100, 150);
  text(choices[1], 100, 200);
  text(choices[2], 100, 250);
  text(choices[3], 100, 300);
  text("pausa", 100, 350);
}
