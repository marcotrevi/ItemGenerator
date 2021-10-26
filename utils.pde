class utils {
  String[] varNames = {"a", "b", "c", "x", "y", "z"};

  utils() {
  }

  //###################################################################### methods which return a monomial 

  monomial generateMonomial(int[] complexity) {
    // monomial complexity is a discrete 3D vector: (coefficient, number of variables, max degree)
    int num = 1;
    int den = 1;
    int nVariables = 1;
    fraction coefficient;
    int sign = 1;
    switch(complexity[1]) {
      /*
      n. variables complexity:
       0 - 0 or 1 variable
       1 - 2 variables
       2 - 3 variables
       */
    case 0:
      nVariables = floor(random(0, 2));
      break;
    case 1:
      nVariables = 2;
      break;
    case 2:
      nVariables = 3;
      break;
    default:
      nVariables = floor(random(3, 5));
      break;
    }


    switch(complexity[0]) {
      /*
   coefficient complexity:
       0 - coefficient is 1
       1 - coefficient is an integer
       2 - coefficient is a fraction
       */
    case 0:
      if (nVariables == 1) {
        num = 1;
        den = 1;
      } else {
        num = math.easyInts[floor(random(math.easyInts.length))];
        den = 1;
      }
      break;
    case 1:
      num = math.easyInts[floor(random(math.easyInts.length))];
      den = 1;
      break;
    case 2:
      num = math.easyInts[floor(random(math.easyInts.length))];
      den = math.easyInts[floor(random(math.easyInts.length))];    
      break;
    default:
      num = math.primes[floor(random(math.primes.length))];
      den = math.primes[floor(random(math.primes.length))];    
      break;
    }
    coefficient = new fraction(num, den);
    coefficient.simplify();

    if (complexity[0] == 0) {
      sign = 1;
    } else {
      if (random(0, 1) < 0.66) { // slight preference to positive coefficients
        sign = 1;
      } else {
        sign = -1;
      }
    }
    monomial m = new monomial(nVariables);
    m.coefficient = coefficient;
    m.sign = sign;
    int[] p = permutation(varNames.length);
    for (int i=0; i<m.nVariables; i++) {
      m.variables[i] = p[i];
    }
    switch(complexity[2]) {
      /*
    degree complexity:
       0 - max degree is 1
       1 - max degree is 2 
       2 - max degree is 3
       */
    case 0:
      for (int i=0; i<nVariables; i++) {
        m.degrees[i] = 1;
      }
      break;
    case 1:
      for (int i=0; i<nVariables; i++) {
        m.degrees[i] = floor(random(1, 3));
      }
      break;
    case 2:
      for (int i=0; i<nVariables; i++) {
        m.degrees[i] = floor(random(1, 4));
      }
      break;
    default:
      for (int i=0; i<nVariables; i++) {
        m.degrees[i] = floor(random(1, 10));
      }
      break;
    }
    m.setDegree();
    return m;
  }

  monomial generateSimilar(monomial M) {
    monomial S = new monomial(M.nVariables);
    S.variables = M.variables;
    S.degrees = M.degrees;
    S.sign = math.setSign();
    S.coefficient = new fraction(1, 1);
    return S;
  }

  monomial generateNonSimilar(monomial M, int[] complexity) {
    int i = 0;
    boolean OK = false;
    monomial NS = generateMonomial(complexity);
    while (!OK && i<500) {
      i++;
      NS = generateMonomial(complexity);
      if (!areSimilar(M, NS)) {
        OK = true;
      }
    }
    return NS;
  }

  monomial scalarProduct(monomial M, int[] k) {
    monomial P = new monomial(M.nVariables);
    P.sign = M.sign;
    P.variables = M.variables;
    P.coefficient.N = M.coefficient.N*k[0];
    P.coefficient.D = M.coefficient.D*k[1];
    P.coefficient.simplify();

    for (int i=0; i<P.nVariables; i++) {
      P.degrees[i] = M.degrees[i];
    }
    P.setDegree();
    return P;
  }

  monomial productMonomial(monomial M1, monomial M2) {
    IntList variables = new IntList();
    IntList degrees = new IntList();
    // check common variables
    for (int i=0; i<M1.nVariables; i++) {
      for (int j=0; j<M2.nVariables; j++) {
        if (M1.variables[i] == M2.variables[j]) {
          // found same variable in index i in M1 and j in M2
          variables.append(M1.variables[i]);
          degrees.append(M1.degrees[i]+M2.degrees[j]);
        }
      }
    }
    for (int i=0; i<M1.nVariables; i++) {
      if (!foundVariable(M1.variables[i], M2)) {
        variables.append(M1.variables[i]);
        degrees.append(M1.degrees[i]);
      }
    }
    for (int i=0; i<M2.nVariables; i++) {
      if (!foundVariable(M2.variables[i], M1)) {
        variables.append(M2.variables[i]);
        degrees.append(M2.degrees[i]);
      }
    }
    int nVariables = variables.size();
    monomial P = new monomial(nVariables);
    P.sign = M1.sign * M2.sign;
    P.coefficient = new fraction(M1.coefficient.N*M2.coefficient.N, M1.coefficient.D*M2.coefficient.D);
    P.coefficient.simplify();
    for (int i=0; i<nVariables; i++) {
      P.variables[i] = variables.get(i);
      P.degrees[i] = degrees.get(i);
    }
    P.setDegree();
    return P;
  }

  monomial squareMonomial(monomial M) {
    monomial S = new monomial(M.nVariables);
    S.sign = 1;
    S.variables = M.variables;
    S.coefficient.N = int(pow(M.coefficient.N, 2));
    S.coefficient.D = int(pow(M.coefficient.D, 2));
    for (int i=0; i<S.nVariables; i++) {
      S.degrees[i] = M.degrees[i]*2;
    }
    S.setDegree();
    return S;
  }

  monomial oppositeMonomial(monomial M) {
    monomial S = new monomial(M.nVariables);
    S.variables = M.variables;
    S.sign = -M.sign;
    S.coefficient.N = M.coefficient.N;
    S.coefficient.D = M.coefficient.D;
    for (int i=0; i<S.nVariables; i++) {
      S.degrees[i] = M.degrees[i];
    }
    S.setDegree();
    return S;
  }

  boolean areSimilar(monomial M1, monomial M2) {
    boolean check = true;
    boolean check_variables = true;
    for (int i=0; i<M1.nVariables; i++) {
      if (!foundVariable(M1.variables[i], M2)) {
        check_variables = false;
        i = M1.nVariables;
      }
    }
    for (int i=0; i<M2.nVariables; i++) {
      if (!foundVariable(M2.variables[i], M1)) {
        check_variables = false;
        i = M2.nVariables;
      }
    }
    if (check_variables) {
      for (int i=0; i<M1.nVariables; i++) {
        for (int j=0; j<M2.nVariables; j++) {
          if (M1.variables[i] == M2.variables[j]) {
            // found same variable, check if same degree
            if (M1.degrees[i] != M2.degrees[j]) {
              check = false;
            }
          }
        }
      }
    } else {
      check = false;
    }
    return check;
  }

  int[] permutation(int[] list) {
    // returns a random permutation of list elements
    int[] perm = new int[list.length];
    int[] indices = permutation(list.length);
    for (int i=0; i<list.length; i++) {
      perm[i] = list[indices[i]];
    }
    return perm;
  }
  
  int[] permutation(int n) {
    // returns a random permutation of integers 0...n-1
    IntList list = new IntList();
    int[] perm = new int[n];
    for (int i=0; i<n; i++) {
      list.append(i);
    }
    int index = -1;
    for (int i=0; i<n; i++) {
      index = floor(random(0, list.size()));
      perm[i] = list.get(index);
      list.remove(index);
    }
    return perm;
  }
  
  int[] step(int[] position, int direction, int stepSize) {
    int[] newPosition = position;
    newPosition[direction] = newPosition[direction] + stepSize;
    return newPosition;
  }
  
  int[] smoothStep(int[] position) {
    // updates position vector one step at a time increasing the smallest coordinate
    int[] newPosition = position;
    int minIndex = 0;
    int minCoord = position[0];
    for (int i=1; i<position.length; i++) {
      if (minCoord > position[i]) {
        minCoord = position[i];
        minIndex = i;
      }
    }
    newPosition[minIndex] = newPosition[minIndex] + 1;
    return newPosition;
  } 

  String multiply(String a, String b, int perm) {
    String ans = "";
    switch(perm) {
    case 0:
      if (latex) {
        ans = "\\left("+a+"\\right)\\left("+b+"\\right)";
      } else {
        ans = "("+a+")("+b+")";
      }
      break;
    case 1:
      if (latex) {
        ans = "\\left("+b+"\\right)\\left("+a+"\\right)";
      } else {
        ans = "("+b+")("+a+")";
      }
      break;
    }
    return ans;
  }

  IntList removeInt(IntList list, int n) {
    IntList L = new IntList();
    int index = -1;
    for (int i=0; i<list.size(); i++) {
      L.append(list.get(i));
      if (list.get(i) == n) {
        // found integer
        index = i;
      }
    }
    if (index >= 0) {
      L.remove(index);
    }
    return L;
  }

  float[] simplexSampling(int n) {
    // returns a random sample from the n-1 standard simplex
    // algorithm by Allan R Willms
    float[] sample = new float[n];
    float sum = 0;
    float phi = 0;
    for (int i=1; i<n; i++) {
      phi = random(0, 1);
      sample[i-1] = (1-sum)*(1-pow(phi, 1/(float(n-i)+1)));
      sum = sum+sample[i-1];
    }
    sample[n-1] = 1-sum;
    return sample;
  }

  float[] levelSampling(int n, float c) { 
    // returns a random sample
    // from the intersection of the unit n-cube max(x1, x2, ... xn) = 1
    // and the level c n-simplex (x1+x2+...+xn = c)
    float[] sample = new float[n];

    return sample;
  }

  float[] averageSample(int n, float c) {
    // returns a random sample 
    float[] sample = new float[n];
    return sample;
  }

  boolean foundVariable(int k, monomial M) {
    boolean check = false;
    for (int i=0; i<M.nVariables; i++) {
      if (M.variables[i] == k) {
        check = true;
      }
    }
    return check;
  }

  String removePlus(String s) {
    String r = "";
    if (s.substring(0, 1).equals("+")) {
      r = s.substring(1, s.length());
    } else {
      r = s;
    }
    return r;
  }
  //################################################################## methods which return a polynomial

  polynomial sum(monomial M1, monomial M2, int perm) {
    polynomial S = new polynomial();
    if (perm == 0) {
      S.terms.add(M1);
      S.terms.add(M2);
    } else {
      S.terms.add(M2);
      S.terms.add(M1);
    }
    return S;
  }

  polynomial multiSum(monomial[] M, int[] perm) {
    polynomial S = new polynomial();
    for (int i=0; i<M.length; i++) {
      S.terms.add(M[perm[i]]);
    }
    return S;
  }

  polynomial diff(monomial M1, monomial M2, int perm) {
    polynomial P = new polynomial();
    P = sum(M1, oppositeMonomial(M2), perm);
    return P;
  }

  String sumDiff(monomial M1, monomial M2, int perm) {
    String ans = "";
    ans = multiply(sum(M1, M2, 0).stringify(), diff(M1, M2, 0).stringify(), 0);
    return ans;
  }

  //################################################################ ITEM GENERATOR

  item generateItem(String type, int[] complexity) {
    monomial X, Y;
    X = generateMonomial(complexity);
    Y = generateNonSimilar(X, complexity);
    item I = new item();
    // each item type has its own constructor
    switch(type) {
    case "x^2-y^2":
      I = items.differenceOfSquares(X, Y, complexity);
      break;
    case "(x+y)(x-y)":
      I = items.sumDifference(X, Y, complexity);
      break;
    case "x^2+y^2+2xy":
      I = items.binomialSquareExpanded(X, Y, complexity);
      break;
    case "(x+y)^2":
      I = items.binomialSquareCompact(X, Y, complexity);
      break;
    }
    return I;
  }

  //################################################################################### csv table utilities

  void addCsvRow(Table table, float complexity, String stem, String answer, String distractor1, String distractor2, String distractor3) {
    TableRow newRow = table.addRow();
    newRow.setFloat("complexity", complexity);
    newRow.setString("stem", stem);
    newRow.setString("answer", answer);
    newRow.setString("distractor1", distractor1);
    newRow.setString("distractor2", distractor2);
    newRow.setString("distractor3", distractor3);
  }

  void initTable() {
    T.addColumn("complexity");
    T.addColumn("stem");
    T.addColumn("answer");  
    T.addColumn("distractor1"); 
    T.addColumn("distractor2"); 
    T.addColumn("distractor3"); 
    // this is to facilitate deleting previous column names
    TableRow newRow = T.addRow();
    newRow.setString("complexity", "difficulty");
    newRow.setString("stem", "stem");
    newRow.setString("answer", "choice");
    newRow.setString("distractor1", "choice");
    newRow.setString("distractor2", "choice");
    newRow.setString("distractor3", "choice");
  }

  void generateCsv(Table table, String itemType, int[] complexity, int nItems, String name) {
    for (int i=0; i<nItems; i++) {
      item I = generateItem(itemType, complexity);
      addCsvRow(table, I.difficulty, I.stem, I.answer, I.distractors[0], I.distractors[1], I.distractors[2]);
    }
    saveTable(table, "data/"+ name +".csv");
  }

  void init() {
    T.addColumn("complexity");
    T.addColumn("stem");
    T.addColumn("answer");  
    T.addColumn("distractor1"); 
    T.addColumn("distractor2"); 
    T.addColumn("distractor3"); 
    // this is to facilitate deleting previous column names
    TableRow newRow = T.addRow();
    newRow.setString("complexity", "difficulty");
    newRow.setString("stem", "choice");
    newRow.setString("answer", "choice");
    newRow.setString("distractor1", "choice");
    newRow.setString("distractor2", "choice");
    newRow.setString("distractor3", "choice");
  } 
}
