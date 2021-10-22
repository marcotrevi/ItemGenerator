class items {
  items() {
  }

  //################################################################################### a^n

  item scalarPower(fraction f, int n) {
    // stem: a^n = 
    String stem = "("+f.stringify()+")^"+n;
    // answer
    String answer = math.fractionPow(f, n).stringify();
    // distractors - each distractor can contain multiple errors
    String[] distractors = new String[3];
    String[] errs = new String[3];
    error[] E = new error[3];
    E[0] = new error();
    E[1] = new error();
    E[2] = new error();

    E[0].errorName = E[0].scalarValue.stringify();

    setPs(distractors, E, errs);

    item I = new item();
    I.type = "a^n";
    I.complexity = 0.5;
    I.answer = answer;
    I.stem = stem;
    I.distractors = distractors;
    I.errors = errs;
    return I;
  }

  //################################################################################### (x+y)(x-y)

  item sumDifference(monomial X, monomial Y) {
    // stem: (x+y)(x-y) = 
    String stem = utils.sumDiff(X, Y, floor(random(0, 8)));
    // answer
    monomial X2 = utils.squareMonomial(X);
    monomial Y2 = utils.squareMonomial(Y);
    String answer = utils.diff(X2, Y2, floor(random(0, 2))).stringify();
    // distractors - each distractor can contain multiple errors
    String[] distractors = new String[3];
    String[] errs = new String[3];
    error[] E = new error[3];
    E[0] = new error();
    E[1] = new error();
    E[2] = new error();

    int[] perms = utils.permutation(7); // selecting error location in distractors
    for (int i=0; i<3; i++) {
      // selecting errors
      switch(perms[i]) {
      case 0: // error on X square
        E[i].errorName = utils.diff(errors.squareError(X, 0), Y2, 0).stringify();
        E[i].errorType.append(0);
        break;
      case 1: // error on Y square
        E[i].errorName = utils.diff(X2, errors.squareError(Y, 0), 0).stringify();
        E[i].errorType.append(0);
        break;
      case 2: // incorrect identification of monomials
        E[i].errorName = utils.diff(Y2, X2, 0).stringify();
        E[i].errorType.append(-1);
        break;
      case 3: // error on both squares
        E[i].errorName = utils.diff(errors.squareError(X, 0), errors.squareError(Y, 0), 0).stringify();
        E[i].errorType.append(0);
        E[i].errorType.append(0);
        break;
      case 4: // error on X square and incorrect identification
        E[i].errorName = utils.diff(Y2, errors.squareError(X, 0), 0).stringify();
        E[i].errorType.append(0);
        E[i].errorType.append(-1);
        break;
      case 5: // error on Y square and incorrect identification
        E[i].errorName = utils.diff(errors.squareError(Y, 0), X2, 0).stringify();
        E[i].errorType.append(0);
        E[i].errorType.append(-1);
        break;
      case 6: // error on both squares and incorrect identification
        E[i].errorName = utils.diff(errors.squareError(Y, 0), errors.squareError(X, 0), 0).stringify();
        E[i].errorType.append(0);
        E[i].errorType.append(0);
        E[i].errorType.append(-1);
        break;
      }
    }

    setParams(distractors, E[0], E[1], E[2], errs);

    item I = new item();
    I.type = "(x+y)(x-y)";
    I.complexity = 0.5;
    I.answer = answer;
    I.stem = stem;
    I.distractors = distractors;
    I.errors = errs;
    return I;
  }

  //################################################################################### x^2 - y^2

  item differenceOfSquares(monomial X, monomial Y) {
    // stem: x^2 - y^2 = 
    monomial X2 = utils.squareMonomial(X);
    monomial Y2 = utils.squareMonomial(Y);

    String stem = utils.diff(X2, Y2, floor(random(0, 2))).stringify();
    // answer
    String answer = "";
    if (latex) {
      answer = "\\left(" + utils.sum(X, Y, floor(random(0, 2))).stringify() + "\\right)\\left(" + utils.diff(X, Y, floor(random(0, 2))).stringify() + "\\right)";
    } else {
      answer = "(" + utils.sum(X, Y, floor(random(0, 2))).stringify() + ")(" + utils.diff(X, Y, floor(random(0, 2))).stringify() + ")";
    }
    // distractors
    String[] distractors = new String[3];
    String[] errs = new String[3];

    int[] perms = utils.permutation(7); // selecting error location in distractors
    error E1 = errors.differenceOfSquaresError(X, Y, perms[0]);
    error E2 = errors.differenceOfSquaresError(X, Y, perms[1]);
    error E3 = errors.differenceOfSquaresError(X, Y, perms[2]);

    setParams(distractors, E1, E2, E3, errs);

    item I = new item();
    I.type = "x^2-y^2";
    I.complexity = 0.5;
    I.answer = answer;
    I.stem = stem;
    I.distractors = distractors;
    I.errors = errs;
    return I;
  }

  //################################################################################### (x+y)^2

  item binomialSquareCompact(monomial X, monomial Y) {
    int[] two = {2, 1};
    // stem: (X + Y)^2 = 
    String stem ="";
    if (latex) {
      stem = "\\left("+utils.sum(X, Y, floor(random(0, 2))).stringify()+"\\right)^2";
    } else {
      stem = "("+utils.sum(X, Y, floor(random(0, 2))).stringify()+")^2";
    }
    // answer
    monomial X2 = utils.squareMonomial(X);
    monomial Y2 = utils.squareMonomial(Y);

    monomial[] M = new monomial[3];
    M[0] = X2;
    M[1] = Y2;
    M[2] = utils.scalarProduct(utils.productMonomial(X, Y), two);

    String answer = utils.multiSum(M, utils.permutation(3)).stringify();
    // distractors
    String[] distractors = new String[3];
    String[] errs = new String[3];

    int[] perms = utils.permutation(5); // selecting error type
    error E1 = errors.binomialSquareCompactError(X, Y, perms[0]);
    error E2 = errors.binomialSquareCompactError(X, Y, perms[1]);
    error E3 = errors.binomialSquareCompactError(X, Y, perms[2]);

    setParams(distractors, E1, E2, E3, errs);

    item I = new item();
    I.type = "(x+y)^2";
    I.complexity = 0.5;
    I.answer = answer;
    I.stem = stem;
    I.distractors = distractors;
    I.errors = errs;
    return I;
  }

  //################################################################################### x^2 + y^2 + 2xy

  item binomialSquareExpanded(monomial X, monomial Y) {
    // stem: X^2 + Y^2 + 2.X.Y = 
    int[] two = {2, 1};
    monomial[] M = new monomial[3];
    monomial X2 = utils.squareMonomial(X);
    monomial Y2 = utils.squareMonomial(Y);
    M[0] = X2;
    M[1] = Y2;
    M[2] = utils.scalarProduct(utils.productMonomial(X, Y), two);

    String stem = utils.multiSum(M, utils.permutation(3)).stringify();
    // answer
    String answer = "";
    String answer1 = "";
    String answer2 = "";
    if (latex) {
      answer1 = "\\left("+utils.sum(X, Y, utils.permutation(2)[0]).stringify()+"\\right)^2";
      answer2 = "\\left("+utils.sum(utils.oppositeMonomial(X), utils.oppositeMonomial(Y), utils.permutation(2)[0]).stringify()+"\\right)^2";
    } else {
      answer1 = "("+utils.sum(X, Y, utils.permutation(2)[0]).stringify()+")^2";
      answer2 = "("+utils.sum(utils.oppositeMonomial(X), utils.oppositeMonomial(Y), utils.permutation(2)[0]).stringify()+")^2";
    }

    // if both monomials are positive OR both negative, prefer an all-positive-sign answer.
    // preference is expressed in terms of a large probability "p"
    float p = random(0, 1);
    if (X.sign == -1 && Y.sign == -1) {
      if (p<0.5) {
        answer =  answer2;
      } else {
        answer = answer1;
      }
    } else if (X.sign == 1 && Y.sign == 1) {
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
    int[] perms = utils.permutation(4);
    if ((X.nVariables == 1 && Y.degree == 0) || (X.degree == 0 && Y.nVariables == 1)) {
      // also last error is available
      perms = utils.permutation(5);
    }
    error E1 = errors.binomialSquareExpandedError(X, Y, perms[0]);
    error E2 = errors.binomialSquareExpandedError(X, Y, perms[1]);
    error E3 = errors.binomialSquareExpandedError(X, Y, perms[2]);

    setParams(distractors, E1, E2, E3, errs);

    item I = new item();
    I.type = "x^2+y^2+2xy";
    I.complexity = 0.5;
    I.answer = answer;
    I.stem = stem;
    I.distractors = distractors;
    I.errors = errs;
    return I;
  }


  void setPs(String[] distractors, error[] errors, String[] errs) {
    for (int i=0; i<distractors.length; i++) {
      distractors[i] = errors[i].errorName;
      errs[i] = errors[i].errorType.toString();
    }
  }

  void setParams(String[] distractors, error E1, error E2, error E3, String[] errs) {
    distractors[0] = E1.errorName;
    distractors[1] = E2.errorName;
    distractors[2] = E3.errorName;

    errs[0] = E1.errorType.toString();
    errs[1] = E2.errorType.toString();
    errs[2] = E3.errorType.toString();
  }

  //######################################################################################## ITEM GENERATOR

  item generateItem(String type, float complexity) {
    monomial X, Y;
    item I = new item();
    // each item type has its own constructor
    switch(type) {
    case "x^2-y^2":
      X = utils.generateMonomial(complexity);
      Y = utils.generateNonSimilar(X, complexity);
      I = differenceOfSquares(X, Y);
      break;
    case "(x+y)(x-y)":
      X = utils.generateMonomial(complexity);
      Y = utils.generateNonSimilar(X, complexity);
      I = sumDifference(X, Y);
      break;
    case "x^2+y^2+2xy":
      X = utils.generateMonomial(complexity);
      Y = utils.generateNonSimilar(X, complexity);
      I = binomialSquareExpanded(X, Y);
      break;
    case "(x+y)^2":
      X = utils.generateMonomial(complexity);
      Y = utils.generateNonSimilar(X, complexity);
      I = binomialSquareCompact(X, Y);
      break;
    }
    return I;
  }
}
