// tool for generating random math excercises
math math = new math();
utils U = new utils();
errors errors = new errors();
boolean latex = true; // writes latex tags
Table T = new Table();

void setup() {
  T = new Table();
  T.addColumn("complexity");
  T.addColumn("stem");
  T.addColumn("answer");  
  T.addColumn("distractor1"); 
  T.addColumn("distractor2"); 
  T.addColumn("distractor3"); 
  // this is to faciloitate deleting previous column names
  TableRow newRow = T.addRow();
  newRow.setString("complexity", "difficulty");
  newRow.setString("stem", "stem");
  newRow.setString("answer", "choice");
  newRow.setString("distractor1", "choice");
  newRow.setString("distractor2", "choice");
  newRow.setString("distractor3", "choice");

  monomial m1 = U.generateMonomial(-1);
  monomial m2 = U.generateMonomial(-2);
  monomial m3 = U.generateNonSimilar(m1, 1);
  String _m1 = m1.stringify();
  String _m2 = m2.stringify();
  String _m3 = m3.stringify();

  U.generateItem("x^2-y^2", 0.5).printme();
  U.generateItem("(x+y)(x-y)",0.5).printme();
  U.generateItem("x^2+y^2+2xy",0.5).printme();
  U.generateItem("(x+y)^2",0.5).printme();

  /*
  println(U.generateItem("x^2-y^2", 0.5).csv_line());
   println(U.generateItem("(x+y)(x-y)",0.5).csv_line());
   println(U.generateItem("x^2+y^2+2xy",0.5).csv_line());
   println(U.generateItem("(x+y)^2",0.5).csv_line());
   */

  U.generateCsv(T, "(x+y)(x-y)", 0.5, 10, "sum_difference");
}
