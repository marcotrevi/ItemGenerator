class fraction {
  int N = 1;
  int D = 1;
  int sign = 1; // positive sign by default

  fraction(int N, int D) {
    this.N = N;
    this.D = D;
  }

  void printme() {
    println(N+"/"+D);
  }

  boolean isInt() {
    boolean check = false;
    fraction f = new fraction(N, D);
    f.simplify();
    if (f.D == 1) {
      check = true;
    }
    return check;
  }

  String stringify() {
    String s = "";
    if (D == 0) {
      s = "indeterminato";
    } else {
      if (sign==-1 && N!=0) {
        s = "-";
      }
      if (D == 1) {
        s = s+str(N);
      } else {
        s = s+str(N)+"/"+str(D);
      }
    }
    if (N == 0 ) {
      s = "0";
    }
    return s;
  }

  void simplify() {
    int gcd = math.gcd(N, D);
    N = N/gcd;
    D = D/gcd;
  }
}
