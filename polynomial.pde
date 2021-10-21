class polynomial {
  ArrayList<monomial> terms = new ArrayList<monomial>();

  polynomial() {
  }

  String stringify() {
    String P = "";
    for (int i=0; i<terms.size(); i++) {
      P = P + terms.get(i).stringify();
    }
    if (terms.get(0).sign == 1) {
      P = U.removePlus(P);
    }
    return P;
  }
}
