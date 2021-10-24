class fraction {
  int N = 1;
  int D = 1;

  fraction(int N, int D) {
    this.N = N;
    this.D = D;
  }

  void printme() {
    println(N+"/"+D);
  }

  void simplify() {
    int gcd = math.gcd(N, D);
    N = N/gcd;
    D = D/gcd;
  }
}
