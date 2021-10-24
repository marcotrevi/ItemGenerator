// tool for generating random math excercises
math math = new math();
utils utils = new utils();
errors errors = new errors();
items items = new items();
boolean latex = false; // writes latex tags
Table T = new Table();

void setup() {

//  utils.init();// creates csv table

  monomial m1 = utils.generateMonomial(-1);
  monomial m2 = utils.generateMonomial(-2);
  monomial m3 = utils.generateNonSimilar(m1, 1);
  String _m1 = m1.stringify();
  String _m2 = m2.stringify();
  String _m3 = m3.stringify();

  //items.generateItem("x^2-y^2", 0.5).printme();
  items.generateItem("(x+y)(x-y)",0.5).printme(); 
  //items.generateItem("x^2+y^2+2xy",0.5).printme();
  //items.generateItem("(x+y)^2",0.5).printme();

  /*
  println(items.generateItem("x^2-y^2", 0.5).csv_line());
   println(items.generateItem("(x+y)(x-y)",0.5).csv_line());
   println(items.generateItem("x^2+y^2+2xy",0.5).csv_line());
   println(U.generateItem("(x+y)^2",0.5).csv_line());
   */

  //  U.generateCsv(T, "(x+y)(x-y)", 0.5, 10, "sum_difference");
}
