class node {
  ArrayList<node> children = new ArrayList<node>();
  IntList name = new IntList();

  node() {
  }

  void printme() {
    println(name);
    for (int i=0; i<children.size(); i++) {
      children.get(i).printme();
    }
  }
}
