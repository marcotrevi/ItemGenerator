class utils {
  String[] varNames = {"a", "b", "c", "x", "y", "z"};

  utils() {
  }

  //###################################################################### methods which return a monomial 

  monomial generateMonomial(float complexity) {
    float[] r = new float[3];
    r[0] = random(0, complexity);
    r[1] = random(0, complexity - r[0]);
    r[2] = random(0, complexity - r[0] - r[1]);
    int[] perm = permutation(3);
    float c_coefficient = random(0, complexity);
    float c_variables = random(0, complexity);
    float c_degree = random(0, complexity);

    int num, den;

    if (c_coefficient < 0.25) {
      // coefficient is an easy int
      num = math.easyInts[floor(random(math.easyInts.length))];
      den = 1;
    } else if (0.25 <= c_coefficient && c_coefficient < 0.5) {
      num = math.easyInts[floor(random(math.easyInts.length))];
      den = math.easyInts[floor(random(math.easyInts.length))];
    } else if (0.5<= c_coefficient && c_coefficient < 0.75) {
      num = math.mediumInts[floor(random(math.easyInts.length))];
      den = math.mediumInts[floor(random(math.easyInts.length))];
    } else {
      num = math.difficultInts[floor(random(math.easyInts.length))];
      den = math.difficultInts[floor(random(math.easyInts.length))];
    }
    int[] coefficient = math.fractionSimplify(num, den);

    int nVariables;

    if (c_variables < 0.33) {
      nVariables = 0;
    } else if (0.33<= c_variables && c_variables < 0.66) {
      nVariables = 1;
    } else {
      nVariables = floor(random(1, 3));
    }

    monomial m = new monomial(nVariables);
    if (random(0, 1) < 0.66) { // slight preference to positive coefficients
      m.sign = 1;
    } else {
      m.sign = -1;
    }

    m.coefficient = coefficient;

    int[] p = permutation(varNames.length);
    for (int i=0; i<m.nVariables; i++) {
      m.variables[i] = p[i];
    }
    if (c_degree < 0.5) {
      for (int i=0; i<nVariables; i++) {
        m.degrees[i] = 1;
      }
    } else {
      for (int i=0; i<nVariables; i++) {
        m.degrees[i] = floor(random(2, 4));
      }
    }

    if (complexity == -1) {
      // test monomial
      m = new monomial(1);
      m.sign = 1;
      m.coefficient[0] = 2;
      m.coefficient[1] = 1;

      m.variables[0] = 0;

      m.degrees[0] = 1;
    } else if (complexity == -2) {
      m = new monomial(2);
      m.sign = -1;
      m.coefficient[0] = 1;
      m.coefficient[1] = 1;

      m.variables[0] = 0;
      m.variables[1] = 1;

      m.degrees[0] = 1;
      m.degrees[1] = 2;
    }
    m.setDegree();
    return m;
  }

  monomial generateSimilar(monomial M) {
    monomial S = new monomial(M.nVariables);
    S.variables = M.variables;
    S.degrees = M.degrees;
    S.sign = math.setSign();
    S.coefficient = math.setCoefficient();
    return S;
  }

  monomial generateNonSimilar(monomial M, float complexity) {
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
    P.coefficient[0] = M.coefficient[0]*k[0];
    P.coefficient[1] = M.coefficient[1]*k[1];
    P.coefficient = math.fractionSimplify(P.coefficient[0], P.coefficient[1]);

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
    P.coefficient[0] = M1.coefficient[0]*M2.coefficient[0];
    P.coefficient[1] = M1.coefficient[1]*M2.coefficient[1];
    P.coefficient = math.fractionSimplify(P.coefficient[0], P.coefficient[1]);

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
    S.coefficient[0] = int(pow(M.coefficient[0], 2));
    S.coefficient[1] = int(pow(M.coefficient[1], 2));
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
    S.coefficient[0] = M.coefficient[0];
    S.coefficient[1] = M.coefficient[1];
    for (int i=0; i<S.nVariables; i++) {
      S.degrees[i] = M.degrees[i];
    }
    S.setDegree();
    return S;
  }

  //################################################################################################# methods which operate on monomials

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
    S.terms.add(M1);
    S.terms.add(M2);
    return S;
  }

  polynomial multiSum(monomial[] M, int[] perm) {
    polynomial S = new polynomial();
    for (int i=0; i<M.length; i++) {
      S.terms.add(M[i]);
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

  item generateItem(String type, float complexity) {
    monomial X, Y;
    item I = new item();
    // each item type has its own constructor
    switch(type) {
    case "x^2-y^2":
      X = U.generateMonomial(complexity);
      Y = U.generateNonSimilar(X, complexity);
      I = differenceOfSquares(X, Y);
      break;
    case "(x+y)(x-y)":
      X = U.generateMonomial(complexity);
      Y = U.generateNonSimilar(X, complexity);
      I = sumDifference(X, Y);
      break;
    case "x^2+y^2+2xy":
      X = U.generateMonomial(complexity);
      Y = U.generateNonSimilar(X, complexity);
      I = binomialSquareExpanded(X, Y);
      break;
    case "(x+y)^2":
      X = U.generateMonomial(complexity);
      Y = U.generateNonSimilar(X, complexity);
      I = binomialSquareCompact(X, Y);
      break;
    }
    return I;
  }

  //################################################################################### (X+Y)(X-Y)

  item sumDifference(monomial M1, monomial M2) {
    // stem: (M1+M2)(M1-M2) = 
    String stem = sumDiff(M1, M2, floor(random(0, 8)));
    //    String stem = sumDiff(M1, M2, floor(random(0, 8)));
    // answer
    String answer = diff(squareMonomial(M1), squareMonomial(M2), floor(random(0, 2))).stringify();
    // distractors
    String[] distractors = new String[3];
    String[] errs = new String[3];

    int[] perms = permutation(7); // selecting error location in distractors
    error E1 = errors.sumDiffError(M1, M2, perms[0]);
    error E2 = errors.sumDiffError(M1, M2, perms[1]);
    error E3 = errors.sumDiffError(M1, M2, perms[2]);

    distractors[0] = E1.errorName;
    distractors[1] = E2.errorName;
    distractors[2] = E3.errorName;

    errs[0] = E1.errorType.toString();
    errs[1] = E2.errorType.toString();
    errs[2] = E3.errorType.toString();

    item I = new item();
    I.type = "(x+y)(x-y)";
    I.complexity = 0.5;
    I.answer = answer;
    I.stem = stem;
    I.distractors = distractors;
    I.errors = errs;
    return I;
  }

  //################################################################################### X^2 - Y^2

  item differenceOfSquares(monomial M1, monomial M2) {
    // stem: M1^2 - M2^2 = 
    String stem = diff(squareMonomial(M1), squareMonomial(M2), floor(random(0, 2))).stringify();
    // answer
    String answer = "";
    if (latex) {
      answer = "\\left(" + sum(M1, M2, floor(random(0, 2))).stringify() + "\\right)\\left(" + diff(M1, M2, floor(random(0, 2))).stringify() + "\\right)";
    } else {
      answer = "(" + sum(M1, M2, floor(random(0, 2))).stringify() + ")(" + diff(M1, M2, floor(random(0, 2))).stringify() + ")";
    }
    // distractors
    String[] distractors = new String[3];
    String[] errs = new String[3];

    int[] perms = permutation(7); // selecting error location in distractors
    error E1 = errors.differenceOfSquaresError(M1, M2, perms[0]);
    error E2 = errors.differenceOfSquaresError(M1, M2, perms[1]);
    error E3 = errors.differenceOfSquaresError(M1, M2, perms[2]);

    distractors[0] = E1.errorName;
    distractors[1] = E2.errorName;
    distractors[2] = E3.errorName;

    errs[0] = E1.errorType.toString();
    errs[1] = E2.errorType.toString();
    errs[2] = E3.errorType.toString();

    item I = new item();
    I.type = "x^2-y^2";
    I.complexity = 0.5;
    I.answer = answer;
    I.stem = stem;
    I.distractors = distractors;
    I.errors = errs;
    return I;
  }

  //################################################################################### (X+Y)^2

  item binomialSquareCompact(monomial M1, monomial M2) {
    int[] two = {2, 1};
    // stem: (M1 + M2)^2 = 
    String stem ="";
    if (latex) {
      stem = "\\left("+sum(M1, M2, floor(random(0, 2))).stringify()+"\\right)^2";
    } else {
      stem = "("+sum(M1, M2, floor(random(0, 2))).stringify()+")^2";
    }
    // answer
    monomial[] M = new monomial[3];
    M[0] = squareMonomial(M1);
    M[1] = squareMonomial(M2);
    M[2] = scalarProduct(productMonomial(M1, M2), two);

    String answer = multiSum(M, U.permutation(3)).stringify();
    // distractors
    String[] distractors = new String[3];
    String[] errs = new String[3];

    int[] perms = permutation(5); // selecting error type
    error E1 = errors.binomialSquareCompactError(M1, M2, perms[0]);
    error E2 = errors.binomialSquareCompactError(M1, M2, perms[1]);
    error E3 = errors.binomialSquareCompactError(M1, M2, perms[2]);

    distractors[0] = E1.errorName;
    distractors[1] = E2.errorName;
    distractors[2] = E3.errorName;

    errs[0] = E1.errorType.toString();
    errs[1] = E2.errorType.toString();
    errs[2] = E3.errorType.toString();

    item I = new item();
    I.type = "(x+y)^2";
    I.complexity = 0.5;
    I.answer = answer;
    I.stem = stem;
    I.distractors = distractors;
    I.errors = errs;
    return I;
  }

  //################################################################################### X^2 + Y^2 + 2XY

  item binomialSquareExpanded(monomial M1, monomial M2) {
    // stem: M1^2 + M2^2 + 2.M1.M2 = 
    int[] two = {2, 1};
    monomial[] M = new monomial[3];
    M[0] = squareMonomial(M1);
    M[1] = squareMonomial(M2);
    M[2] = scalarProduct(productMonomial(M1, M2), two);

    String stem = multiSum(M, permutation(3)).stringify();
    // answer
    String answer = "";
    String answer1 = "";
    String answer2 = "";
    if (latex) {
      answer1 = "\\left("+sum(M1, M2, permutation(2)[0]).stringify()+"\\right)^2";
      answer2 = "\\left("+sum(oppositeMonomial(M1), oppositeMonomial(M2), permutation(2)[0]).stringify()+"\\right)^2";
    } else {
      answer1 = "("+sum(M1, M2, permutation(2)[0]).stringify()+")^2";
      answer2 = "("+sum(oppositeMonomial(M1), oppositeMonomial(M2), permutation(2)[0]).stringify()+")^2";
    }

    // if both monomials are positive OR both negative, prefer an all-positive-sign answer.
    // preference is expressed in terms of a large probability "p"
    float p = random(0, 1);
    if (M1.sign == -1 && M2.sign == -1) {
      if (p<0.5) {
        answer =  answer2;
      } else {
        answer = answer1;
      }
    } else if (M1.sign == 1 && M2.sign == 1) {
      if (p<0.8) {
        answer = answer1;
      } else {
        answer = answer2;
      }
    } else {
      if (p<0.5) {
        answer = answer1;
      } else {
        answer = answer2;
      }
    }

    // distractors
    String[] distractors = new String[3];
    String[] errs = new String[3];
    int[] perms = permutation(4);
    if ((M1.nVariables == 1 && M2.degree == 0) || (M1.degree == 0 && M2.nVariables == 1)) {
      // also last error is available
      perms = permutation(5);
    }
    error E1 = errors.binomialSquareExpandedError(M1, M2, perms[0]);
    error E2 = errors.binomialSquareExpandedError(M1, M2, perms[1]);
    error E3 = errors.binomialSquareExpandedError(M1, M2, perms[2]);

    distractors[0] = E1.errorName;
    distractors[1] = E2.errorName;
    distractors[2] = E3.errorName;

    errs[0] = E1.errorType.toString();
    errs[1] = E2.errorType.toString();
    errs[2] = E3.errorType.toString();

    item I = new item();
    I.type = "x^2+y^2+2xy";
    I.complexity = 0.5;
    I.answer = answer;
    I.stem = stem;
    I.distractors = distractors;
    I.errors = errs;
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

  void generateCsv(Table table, String itemType, float complexity, int nItems, String name) {
    for (int i=0; i<nItems; i++) {
      item I = U.generateItem(itemType, complexity);
      U.addCsvRow(table, I.complexity, I.stem, I.answer, I.distractors[0], I.distractors[1], I.distractors[2]);
    }
    table.removeRow(0); // keeps true headings
    saveTable(table, "data/"+ name +".csv");
  }
}
