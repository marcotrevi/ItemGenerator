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
    error[] E = new error[3];
    E[0] = new error();
    E[1] = new error();
    E[2] = new error();

    item I = new item();
    int[] complexity = new int[3];
    setItemParams(I, "a^n", complexity, answer, stem, E);
    return I;
  }

  //################################################################################### (x+y)(x-y)

  item sumDifference(monomial X, monomial Y, int[] complexity) {
    // stem: (x+y)(x-y) = 
    String stem = utils.sumDiff(X, Y, 0);
    // answer
    monomial X2 = utils.squareMonomial(X);
    monomial Y2 = utils.squareMonomial(Y);
    String answer = utils.diff(X2, Y2, utils.permutation(2)[0]).stringify();

    // distractors - each distractor can contain multiple errors
    error[] E = new error[3];
    E[0] = new error();
    E[1] = new error();
    E[2] = new error();

    monomial X2_error, Y2_error;
    // check available errors on X
    int[] X_availability = utils.permutation(errors.availability(X, "square"));
    // check available errors on Y
    int[] Y_availability = utils.permutation(errors.availability(Y, "square"));
    int X_errorIndex, Y_errorIndex;

    int[] perms = utils.permutation(7); // selecting error location in distractors

    for (int i=0; i<3; i++) {
      X_errorIndex = X_availability[min(i, X_availability.length-1)];
      Y_errorIndex = Y_availability[min(i, Y_availability.length-1)];
      X2_error = errors.squareError(X, X_errorIndex);
      Y2_error = errors.squareError(Y, Y_errorIndex);

      switch(perms[i]) {
      case 0: // error on X square
        E[i].errorName = utils.diff(X2_error, Y2, 0).stringify();
        E[i].errorType.append(X_errorIndex);
        break;
      case 1: // error on Y square
        E[i].errorName = utils.diff(X2, Y2_error, 0).stringify();
        E[i].errorType.append(Y_errorIndex);
        break;
      case 2: // incorrect identification of monomials
        E[i].errorName = utils.diff(Y2, X2, 0).stringify();
        E[i].errorType.append(50);
        break;
      case 3: // error on both squares
        E[i].errorName = utils.diff(X2_error, Y2_error, 0).stringify();
        E[i].errorType.append(X_errorIndex);
        E[i].errorType.append(Y_errorIndex);
        break;
      case 4: // error on X square and incorrect identification
        E[i].errorName = utils.diff(Y2, X2_error, 0).stringify();
        E[i].errorType.append(X_errorIndex);
        E[i].errorType.append(50);
        break;
      case 5: // error on Y square and incorrect identification
        E[i].errorName = utils.diff(Y2_error, X2, 0).stringify();
        E[i].errorType.append(Y_errorIndex);
        E[i].errorType.append(50);
        break;
      case 6: // error on both squares and incorrect identification
        E[i].errorName = utils.diff(Y2_error, X2_error, 0).stringify();
        E[i].errorType.append(X_errorIndex);
        E[i].errorType.append(Y_errorIndex);
        E[i].errorType.append(50);
        break;
      }
    }

    item I = new item();
    setItemParams(I, "(x+y)(x-y)", complexity, answer, stem, E);

    return I;
  }

  //################################################################################### x^2 - y^2

  item differenceOfSquares(monomial X, monomial Y, int[] complexity) {
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
    error[] E = new error[3];
    E[0] = new error();
    E[1] = new error();
    E[2] = new error();

    monomial X_error, Y_error;
    int[] X_availability = utils.permutation(errors.availability(X, "root"));
    int[] Y_availability = utils.permutation(errors.availability(Y, "root"));
    int X_errorIndex, Y_errorIndex;

    int[] perms = utils.permutation(7); // selecting error location in distractors

    for (int i=0; i<3; i++) {
      X_errorIndex = X_availability[min(i, X_availability.length-1)];
      Y_errorIndex = Y_availability[min(i, Y_availability.length-1)];
      X_error = errors.rootError(X, X_errorIndex);
      Y_error = errors.rootError(Y, Y_errorIndex);
      switch(perms[i]) {
      case 0: // error on X square
        E[i].errorName = utils.multiply(utils.sum(X_error, Y, 0).stringify(), utils.diff(X_error, Y, 0).stringify(), 0);
        E[i].errorType.append(X_errorIndex);
        break;
      case 1: // error on Y square
        E[i].errorName = utils.multiply(utils.sum(X, Y_error, 0).stringify(), utils.diff(X, Y_error, 0).stringify(), 0);
        E[i].errorType.append(Y_errorIndex);
        break;
      case 2: // incorrect identification of monomials
        E[i].errorName = utils.multiply(utils.sum(Y, X, 0).stringify(), utils.diff(Y, X, 0).stringify(), 0);
        E[i].errorType.append(50);
        break;
      case 3: // error on both squares
        // WARNING! errors cancel if:
        E[i].errorName = utils.multiply(utils.sum(X_error, Y_error, 0).stringify(), utils.diff(X_error, Y_error, 0).stringify(), 0);
        E[i].errorType.append(X_errorIndex);
        E[i].errorType.append(Y_errorIndex);
        break;
      case 4: // error on X square and incorrect identification
        // WARNING! errors cancel if:
        E[i].errorName = utils.multiply(utils.sum(Y, X_error, 0).stringify(), utils.diff(Y, X_error, 0).stringify(), 0);
        E[i].errorType.append(X_errorIndex);
        E[i].errorType.append(50);
        break;
      case 5: // error on Y square and incorrect identification
        // WARNING! errors cancel if:
        E[i].errorName = utils.multiply(utils.sum(Y_error, X, 0).stringify(), utils.diff(Y_error, X, 0).stringify(), 0);
        E[i].errorType.append(Y_errorIndex);
        E[i].errorType.append(50);
        break;
      case 6: // error on both squares and incorrect identification
        // WARNING! errors cancel if:
        E[i].errorName = utils.multiply(utils.sum(Y_error, X_error, 0).stringify(), utils.diff(Y_error, X_error, 0).stringify(), 0);
        E[i].errorType.append(X_errorIndex);
        E[i].errorType.append(Y_errorIndex);
        E[i].errorType.append(50);
        break;
      }
    }
    item I = new item();
    setItemParams(I, "x^2-y^2", complexity, answer, stem, E);

    return I;
  }

  //################################################################################### (x+y)^2

  item binomialSquareCompact(monomial X, monomial Y, int[] complexity) {
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
    error[] E = new error[3];

    E[0] = new error();
    E[1] = new error();
    E[2] = new error();

    // check possible errors
    int[] X_availability = utils.permutation(errors.availability(X, "square"));
    int[] Y_availability = utils.permutation(errors.availability(Y, "square"));
    int X_errorIndex, Y_errorIndex;
    monomial X_error, Y_error;

    int[] perms = utils.permutation(5); // selecting error type

    for (int i=0; i<3; i++) {
      X_errorIndex = X_availability[min(i, X_availability.length-1)];
      Y_errorIndex = Y_availability[min(i, Y_availability.length-1)];
      X_error = errors.squareError(X, X_errorIndex);
      Y_error = errors.squareError(Y, Y_errorIndex);

      switch(perms[i]) {
      case 0: // error on X square
        M[0] = X_error;
        M[1] = utils.squareMonomial(Y);
        M[2] = utils.productMonomial(utils.scalarProduct(X, two), Y);
        E[i].errorName = utils.multiSum(M, utils.permutation(3)).stringify();
        E[i].errorType.append(X_errorIndex);
        break;
      case 1: // error on Y square
        M[0] = utils.squareMonomial(X);
        M[1] = Y_error;
        M[2] = utils.productMonomial(utils.scalarProduct(X, two), Y);
        E[i].errorName = utils.multiSum(M, utils.permutation(3)).stringify();
        E[i].errorType.append(Y_errorIndex);
        break;
      case 2: // error on both squares
        M[0] = X_error;
        M[1] = Y_error;
        M[2] = utils.productMonomial(utils.scalarProduct(X, two), Y);
        E[i].errorName = utils.multiSum(M, utils.permutation(3)).stringify();
        E[i].errorType.append(X_errorIndex);
        E[i].errorType.append(Y_errorIndex);
        break;
      case 3: // sophomore's dream
        E[i].errorName = utils.sum(utils.squareMonomial(X), utils.squareMonomial(Y), 0).stringify();
        E[i].errorType.append(-1);
        break;
      case 4: // wrong double product sign
        M[0] = utils.squareMonomial(X);
        M[1] = utils.squareMonomial(Y);
        M[2] = utils.oppositeMonomial(utils.productMonomial(utils.scalarProduct(X, two), Y));    
        E[i].errorName = utils.multiSum(M, utils.permutation(3)).stringify();
        E[i].errorType.append(X_errorIndex);
        E[i].errorType.append(-1);
        break;
      }
    }

    item I = new item();
    setItemParams(I, "(x+y)^2", complexity, answer, stem, E);
    return I;
  }

  //################################################################################### x^2 + y^2 + 2xy

  item binomialSquareExpanded(monomial X, monomial Y, int[] complexity) {
    // stem: X^2 + Y^2 + 2SXY = 
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
    error[] E = new error[3];
    E[0] = new error();
    E[1] = new error();
    E[2] = new error();

    // check possible errors
    int[] X_availability = utils.permutation(errors.availability(X, "root"));
    int[] Y_availability = utils.permutation(errors.availability(Y, "root"));
    int X_errorIndex, Y_errorIndex;
    monomial X_error, Y_error;

    int[] perms = utils.permutation(4);
    if ((X.nVariables == 1 && Y.degree == 0) || (X.degree == 0 && Y.nVariables == 1)) {
      // also last error is available
      perms = utils.permutation(5);
    }

    for (int i=0; i<3; i++) {
      X_errorIndex = X_availability[min(i, X_availability.length-1)];
      Y_errorIndex = Y_availability[min(i, Y_availability.length-1)];
      X_error = errors.rootError(X, X_errorIndex);
      Y_error = errors.rootError(Y, Y_errorIndex);
      print(" ok: "+perms[i]+" ");
      switch(perms[i]) {
      case 0: // error on X root
        if (latex) {
          E[i].errorName = "\\left(" + utils.sum(X_error, Y, utils.permutation(2)[0]).stringify() + "\\right)^2";
        } else {
          E[i].errorName = "(" + utils.sum(X_error, Y, utils.permutation(2)[0]).stringify() + ")^2";
        }
        E[i].errorType.append(X_errorIndex);
        break;
      case 1: // error on Y root
        if (latex) {
          E[i].errorName = "\\left(" + utils.sum(X, Y_error, utils.permutation(2)[0]).stringify() + "\\right)^2";
        } else {
          E[i].errorName = "(" + utils.sum(X, Y_error, utils.permutation(2)[0]).stringify() + ")^2";
        }
        E[i].errorType.append(Y_errorIndex);
        break;
      case 2: // error on both roots
        if (latex) {
          E[i].errorName = "\\left(" + utils.sum(X_error, Y_error, utils.permutation(2)[0]).stringify() + "\\right)^2";
        } else {
          E[i].errorName = "(" + utils.sum(X_error, Y_error, utils.permutation(2)[0]).stringify() + ")^2";
        }
        E[i].errorType.append(X_errorIndex);
        E[i].errorType.append(Y_errorIndex);
        break;
      case 3: // always positive sum
        // WARNING: error not available is monomials have same signs
        if (X.sign * Y.sign == -1) {
          monomial Xplus = X;
          monomial Yplus = Y;
          if (X.sign == -1 && Y.sign == 1) {
            Xplus = utils.oppositeMonomial(X);
          }
          if (X.sign == 1 && Y.sign == -1) {
            Yplus = utils.oppositeMonomial(Y);
          }
          if (latex) {
            E[i].errorName = "\\left(" + utils.sum(Xplus, Yplus, utils.permutation(2)[0]).stringify() + "\\right)^2";
          } else {
            E[i].errorName = "(" + utils.sum(Xplus, Yplus, utils.permutation(2)[0]).stringify() + ")^2";
          }
          E[i].errorType.append(-1);
        } else {
          E[i].errorName = "0";
          E[i].errorType.append(-3);
        }
        break;
      case 4: // if one of the monomials has only one variable and the other is a scalar, one error is the "compactification":
        // e.g. (5x^3 + 6)^2 = 25x^6 + 60x^3 + 36 ---> 85x^9 + 36
        monomial monic1 = new monomial(X.nVariables);
        monic1.variables = X.variables;
        monic1.degrees = X.degrees;
        monic1.coefficient.N = 1;
        monic1.coefficient.D = 1;
        monic1.setDegree();

        monomial monic2 = new monomial(Y.nVariables);
        monic2.variables = Y.variables;
        monic2.degrees = Y.degrees;
        monic2.coefficient.N = 1;
        monic2.coefficient.D = 1;
        monic2.setDegree();
                
        fraction f1 = new fraction(X.coefficient.N, X.coefficient.D);
        fraction f2 = new fraction(Y.coefficient.N, Y.coefficient.D);

        if (X.degree == 0) {
                  print(" here1 ");
          monomial P = utils.productMonomial(utils.squareMonomial(monic2), utils.productMonomial(monic1, monic2));
          fraction a = new fraction(f2.N*f2.N, f2.D*f2.D);
          if (X.sign*Y.sign == -1) {
            fraction b = new fraction(-2*f1.N*f2.N, f1.D*f2.D);
            P.coefficient = math.fractionSum(a, b);
          } else {
            fraction b = new fraction(2*f1.N*f2.N, f1.D*f2.D);
            P.coefficient = math.fractionSum(a, b);
          }
          P.coefficient.simplify();
          E[i].errorName = utils.sum(P, utils.squareMonomial(X), 0).stringify();
        } else {
                  print(" here2 ");

          fraction a = new fraction(f1.N*f1.N, f1.D*f1.D);
          monomial P = utils.productMonomial(utils.squareMonomial(monic1), utils.productMonomial(monic1, monic2));
          if (X.sign*Y.sign == -1) {
            fraction b = new fraction(-2*f1.N*f2.N, f1.D*f2.D);
            P.coefficient = math.fractionSum(a, b);
          } else {
            fraction b = new fraction(2*f1.N*f2.N, f1.D*f2.D);
            P.coefficient = math.fractionSum(a, b);
          }
          P.coefficient.simplify();
          if (P.coefficient.N == -1 && P.coefficient.D == 1) {
            E[i].errorName = utils.removePlus(utils.sum(P, utils.squareMonomial(Y), 0).stringify());
          } else {          
            E[i].errorName = utils.sum(P, utils.squareMonomial(Y), 0).stringify();
          }
        }
        E[i].errorType.append(-5);
        break;
      }
    }

    item I = new item();
    setItemParams(I, "x^2+y^2+2xy", complexity, answer, stem, E );

    return I;
  }

  void setItemParams(item I, String type, int[] complexity, String answer, String stem, error[] E) {

    I.type = type;
    I.complexity = complexity;
    I.answer = answer;
    I.stem = stem;

    I.distractors[0] = E[0].errorName;
    I.distractors[1] = E[1].errorName;
    I.distractors[2] = E[2].errorName;

    I.errors[0] = E[0].errorType.toString();
    I.errors[1] = E[1].errorType.toString();
    I.errors[2] = E[2].errorType.toString();
  }
}
