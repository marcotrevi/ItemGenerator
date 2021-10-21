class algebricFraction {
  polynomial N = new polynomial();
  polynomial D = new polynomial();

  algebricFraction() {
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
}
