// tool for generating random math excercises
math math = new math();
utils U = new utils();
errors errors = new errors();

void setup() {

  monomial m1 = U.generateMonomial(-1);
  monomial m2 = U.generateMonomial(-2);
  monomial m3 = U.generateNonSimilar(m1, 1);
  String _m1 = m1.stringify();
  String _m2 = m2.stringify();
  String _m3 = m3.stringify();
  
  //U.generateItem("x^2-y^2", 0.5).printme();
  //U.generateItem("(x+y)(x-y)",0.5).printme();
  U.generateItem("x^2+y^2+2xy",0.5).printme();
  //U.generateItem("(x+y)^2",0.5).printme();

}
