math math = new math();
utils utils = new utils();
errors errors = new errors();
items items = new items();
boolean latex = false; // writes latex tags
Table T = new Table();

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
    print("complexity ("+c[0]+","+c[1]+","+c[2]+"): ");
    println(_m1);
    //    c = utils.smoothStep(c);
    //    c = utils.step(c, floor(random(0, 3)), floor(random(0,2)));
  }
  //String _m2 = m2.stringify();
  //String _m3 = m3.stringify();

  //utils.generateItem("x^2-y^2", c).printme();
  //utils.generateItem("(x+y)(x-y)", c).printme();
  utils.generateItem("x^2+y^2+2xy", c).printme();
  //utils.generateItem("(x+y)^2", c).printme();

  //utils.generateCsv(T, "(x+y)^2", 0.5, 10, "binomial_square_compact");
}

void draw() {
  background(0);
  //  keyPressed();
}

void keyPressed() {
  if (keyCode == 'A') {
    text("A", 100, 100);
  } else {
    text("hello", 100, 100);
  }
}
