class polynomial {
  ArrayList<monomial> terms = new ArrayList<monomial>();
  FloatList zeros = new FloatList();

  polynomial() {
  }

  String stringify() {
    String P = "";
    for (int i=0; i<terms.size(); i++) {
      P = P + terms.get(i).stringify();
    }
    P = utils.removePlus(P);
    return P;
  }
  
}
