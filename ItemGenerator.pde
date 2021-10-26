math math = new math();
utils utils = new utils();
errors errors = new errors();
items items = new items();
boolean latex = false; // writes latex tags
Table T = new Table();
int startTime = 0;
int stopTime = 0;
int elapsedTime = 0;
item I;
String[] choices = new String[4];
int W = 400; 
int H = 400;
void setup() {
  size(400, 400);
  utils.initTable();
  int[] c = new int[3];
  c[0] = 1;
  c[1] = 0;
  c[2] = 0;

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

  //I = utils.generateItem("x^2+y^2+2xy", c);
  //choices = shuffleChoices(I);
  //utils.generateItem("(x+y)^2", c).printme();

  //utils.generateCsv(T, "(x+y)^2", 0.5, 10, "binomial_square_compact");
}

void draw() {
  background(0);
  textSize(24);
  //text(I.stem, 100, 100);
  text("----------------------", 50, 120);
  //displayChoices(choices);
}

String[] shuffleChoices(item I) {
  String[] choices = new String[4];
  choices[0] = I.answer+" (*)";
  choices[1] = I.distractors[0];
  choices[2] = I.distractors[1];
  choices[3] = I.distractors[2];
  int[] perms = utils.permutation(4);
  String[] shuffle = new String[4];
  shuffle[0] = choices[perms[0]];
  shuffle[1] = choices[perms[1]];
  shuffle[2] = choices[perms[2]];
  shuffle[3] = choices[perms[3]];
  return shuffle;
}

void displayChoices(String[] choices) {
  text(choices[0], 100, 150);
  text(choices[1], 100, 200);
  text(choices[2], 100, 250);
  text(choices[3], 100, 300);
}

void getNewItem(int[] complexity) {
  I = utils.generateItem("x^2+y^2+2xy", complexity);
  choices = shuffleChoices(I);
}

void keyPressed() {
  switch(keyCode) {
  case 'A': 
    text("START", 100, 100);
    startTime = millis();
    break;
  case 'Z':
    text("STOP", 100, 100);
    stopTime = millis();
    elapsedTime = stopTime - startTime;
    println(elapsedTime);
    break;
  case 'N': // new item
    int[] c = {1, 0, 0}; 
    print("generating....");
    //    getNewItem(c);
    print("done.");
    println();
    break;
  }
}
