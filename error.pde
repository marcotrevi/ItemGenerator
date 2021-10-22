class error {
  int id = -1;
  String errorName = "";
  IntList errorType = new IntList();
  String description = "";
  String exceptions = "";
  fraction scalarValue = new fraction(0,0);
  monomial monomialValue = new monomial(0);

  error() {
  }

  void printme() {
    println("error "+ id +": "+description);
    println(exceptions);
  }
}
