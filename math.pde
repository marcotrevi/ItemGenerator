class math {
  // all math utilities
  int[] primes =  {1, 2, 3, 5, 7, 11, 13, 17, 19, 23, 
    29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 
    71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 
    113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 
    173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 
    229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 
    281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 
    349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 
    409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 
    463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 
    541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 
    601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 
    659, 661, 673, 677, 683, 691, 701, 709, 719, 727, 
    733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 
    809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 
    863, 877, 881, 883, 887, 907, 911, 919, 929, 937, 
    941, 947, 953, 967, 971, 977, 983, 991, 997};

  int[] easyInts = {1, 2, 3, 4, 5};

  int[] mediumInts = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 15, 16, 20, 24, 25, 13, 14, 17, 18, 19, 21, 22, 23, 
    26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 
    55, 60, 64, 80, 81, 100};

  int[] difficultInts = {
    51, 52, 53, 54, 56, 57, 58, 59, 61, 62, 63, 65, 66, 67, 68, 69, 70, 
    71, 72, 73, 74, 75, 76, 77, 78, 79, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99      
  };

  math() {
  }

  IntList primeDecomposition(int n) {
    // returns an IntList of exponents
    // decomposition[i] is the exponent of the i-th prime number in the factorization of n
    int N = n;
    IntList decomposition = new IntList();
    decomposition.append(1); // 1 is always factor
    for (int i=1; i<primes.length; i++ ) {
      if (n==1 || n==0) {
        i = primes.length; // exits
      } else {
        decomposition.append(0);
        int s = 0;
        while (N % primes[i] == 0) {
          s++;
          decomposition.set(i, s);
          N = N/primes[i];
        }
        if (N == 1) {
          i = primes.length;
        }
      }
    }
    return decomposition;
  }

  int lcm(int a, int b) {
    int lcm = 1;
    IntList dec_a = primeDecomposition(a);
    IntList dec_b = primeDecomposition(b);
    int la = dec_a.size();
    int lb = dec_b.size();
    int delta = abs(lb-la);
    if (la < lb) {
      // a has fewer factors than b
      for (int i=0; i<delta; i++) {
        dec_a.append(0);
      }
    } 
    if (la > lb) {
      // b has fewer factors than a
      for (int i=0; i<delta; i++) {
        dec_b.append(0);
      }
    }
    for (int k=0; k<dec_a.size(); k++) {
      lcm = lcm*int(pow(primes[k], max(dec_a.get(k), dec_b.get(k))));
    }
    return lcm;
  }

  int gcd(int a, int b) {
    int gcd = 1;
    IntList dec_a = primeDecomposition(a);
    IntList dec_b = primeDecomposition(b);
/*
    print("decomposition of "+a+": ");
    for (int i=0; i<dec_a.size(); i++) {
      print(dec_a.get(i)+",");
    }
    println();
*/
    int l = min(dec_a.size(), dec_b.size());
    for (int i=0; i<l; i++) {
      if (dec_a.get(i)*dec_b.get(i) != 0) {
        // found a common divisor
        gcd = gcd*int(pow(primes[i], min(dec_a.get(i), dec_b.get(i))));
      }
    }
    return gcd;
  }

  fraction fractionSum(fraction f1, fraction f2) {
    // returns the fraction f1 + f2
    int lcm = lcm(f1.D, f2.D);
    fraction f = new fraction(lcm/f1.D*f1.N + lcm/f2.D*f2.N, lcm);
    return f;
  }

  fraction fractionMult(fraction a, fraction b) {
    // returns the fraction a*b 
    fraction F = new fraction(a.N*b.N, a.D*b.D);
    return F;
  }

  fraction fractionPow(fraction f, int n) {
    // returns the fraction a^n 
    fraction F = new fraction(int(pow(f.N, n)), int(pow(f.D, n)));
    return F;
  }

  fraction setCoefficient() {
    fraction c = new fraction(1, 1);
    return c;
  }

  int setSign() {
    int s = 1;
    if (random(0, 1)<0.5) {
      s = -1;
    }
    return s;
  }
}
