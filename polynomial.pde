class polynomial {
  ArrayList<monomial> terms = new ArrayList<monomial>();

  polynomial() {
  }

  String stringify() {
    String P = "";
    for (int i=0; i<terms.size(); i++) {
      P = P + terms.get(i).stringify();
    }
    P = U.removePlus(P);
    return P;
  }
}
