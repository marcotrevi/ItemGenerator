class items {
  items() {
  }
  
    item sumDifference(monomial M1, monomial M2) {
    // stem: (M1+M2)(M1-M2) = 
    String stem = utils.sumDiff(M1, M2, floor(random(0, 8)));
    //    String stem = sumDiff(M1, M2, floor(random(0, 8)));
    // answer
    String answer = utils.diff(utils.squareMonomial(M1), utils.squareMonomial(M2), floor(random(0, 2))).stringify();
    // distractors
    String[] distractors = new String[3];
    String[] errs = new String[3];

    int[] perms = utils.permutation(7); // selecting error location in distractors
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
    String stem = utils.diff(utils.squareMonomial(M1), utils.squareMonomial(M2), floor(random(0, 2))).stringify();
    // answer
    String answer = "";
    if (latex) {
      answer = "\\left(" + utils.sum(M1, M2, floor(random(0, 2))).stringify() + "\\right)\\left(" + utils.diff(M1, M2, floor(random(0, 2))).stringify() + "\\right)";
    } else {
      answer = "(" + utils.sum(M1, M2, floor(random(0, 2))).stringify() + ")(" + utils.diff(M1, M2, floor(random(0, 2))).stringify() + ")";
    }
    // distractors
    String[] distractors = new String[3];
    String[] errs = new String[3];

    int[] perms = utils.permutation(7); // selecting error location in distractors
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
      stem = "\\left("+utils.sum(M1, M2, floor(random(0, 2))).stringify()+"\\right)^2";
    } else {
      stem = "("+utils.sum(M1, M2, floor(random(0, 2))).stringify()+")^2";
    }
    // answer
    monomial[] M = new monomial[3];
    M[0] = utils.squareMonomial(M1);
    M[1] = utils.squareMonomial(M2);
    M[2] = utils.scalarProduct(utils.productMonomial(M1, M2), two);

    String answer = utils.multiSum(M, utils.permutation(3)).stringify();
    // distractors
    String[] distractors = new String[3];
    String[] errs = new String[3];

    int[] perms = utils.permutation(5); // selecting error type
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
    M[0] = utils.squareMonomial(M1);
    M[1] = utils.squareMonomial(M2);
    M[2] = utils.scalarProduct(utils.productMonomial(M1, M2), two);

    String stem = utils.multiSum(M, utils.permutation(3)).stringify();
    // answer
    String answer = "";
    String answer1 = "";
    String answer2 = "";
    if (latex) {
      answer1 = "\\left("+utils.sum(M1, M2, utils.permutation(2)[0]).stringify()+"\\right)^2";
      answer2 = "\\left("+utils.sum(utils.oppositeMonomial(M1), utils.oppositeMonomial(M2), utils.permutation(2)[0]).stringify()+"\\right)^2";
    } else {
      answer1 = "("+utils.sum(M1, M2, utils.permutation(2)[0]).stringify()+")^2";
      answer2 = "("+utils.sum(utils.oppositeMonomial(M1), utils.oppositeMonomial(M2), utils.permutation(2)[0]).stringify()+")^2";
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
    int[] perms = utils.permutation(4);
    if ((M1.nVariables == 1 && M2.degree == 0) || (M1.degree == 0 && M2.nVariables == 1)) {
      // also last error is available
      perms = utils.permutation(5);
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
