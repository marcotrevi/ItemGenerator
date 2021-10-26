class algebraicFraction {
  polynomial N = new polynomial();
  polynomial D = new polynomial();

  algebraicFraction() {
  }

  String stringify() {
    String F = "";
    if (latex) {
      F = "\\frac{"+N.stringify()+"}{"+D.stringify()+"}";
    } else {
      F = N.stringify()+"/"+D.stringify();
    }
    return F;
  }

  void simplify() {
  }
  
}
