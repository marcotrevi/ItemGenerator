class errors {
  errors() {
  }

  //######################################################################################## ERROR DATABASE

  error pow1(fraction f, int n) {
    boolean isAvailable = true;
    error E = new error();
    E.id = 0;
    E.description = "(a/b)^n => n.a/b [base multiplied by exponent instead of raised to the n-th power]";
    E.exceptions = "exceptions: a=0; n=1; a=2 & b=1 & n=2";
    if (f.N == 0 || n==1 || (f.N==2 && f.D==1 && n==2)) {
      isAvailable = false;
    }
    if (isAvailable) {
      E.scalarValue.N = n*f.N;
      E.scalarValue.D = f.D;
    } else {
    }
    return E;
  }

  error power2(monomial M, int errorType) {
    // there are 6 possible errors in this list
    boolean isAvailable = true;
    error E = new error();
    monomial S = new monomial(0);
    switch(errorType) {
    case 0:
      E.id = 0;
      E.description = "(a.M(x))^2 => a.M(x)^2 [coefficient not squared, only the literal part M(x)]";
      E.exceptions = "exceptions: a=0; a=1";
      E.monomialValue = new monomial(M.nVariables);
      E.monomialValue.variables = M.variables;
      E.monomialValue.coefficient = M.coefficient;

      S.sign = 1;
      S.coefficient.N = M.coefficient.N;
      S.coefficient.D = M.coefficient.D;
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = M.degrees[i]*2;
      }
      break;
    case 1: // double of coefficient instead of square (kx)^2= 2kx^2
      // WARNING: is correct if coefficient is 2
      error e = pow1(M.coefficient, 2);
      S.sign = M.sign;
      S.coefficient = e.scalarValue;
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = M.degrees[i]*2;
      }
      break;
    case 2: // double of monomial instead of square: (kx)^2 = 2kx
      // WARNING: is correct if monomial is constant and equal to 2
      S.sign = M.sign;
      S.coefficient.N = 2*M.coefficient.N;
      S.coefficient.D = M.coefficient.D;
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = M.degrees[i];
      }
      break;
    case 3: // square of exponent instead of double: (kx^n)^2 = k^2x^(n^2)
      // WARNING: is correct if coefficient is 1 or if exponent is 2
      S.sign = 1;
      S.coefficient.N = int(pow(M.coefficient.N, 2));
      S.coefficient.D = int(pow(M.coefficient.D, 2));
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = int(pow(M.degrees[i], 2));
      }
      break;
    case 4: // doubling coefficient, both numerator and denominator if coefficient is a fraction, while correctly squaring variables
      // WARNING: is correct if coefficient is 2
      S.sign = M.sign;
      S.coefficient.N = 2*M.coefficient.N;
      if (M.coefficient.D > 1) {
        S.coefficient.D = 2*M.coefficient.D;
      } else {
        S.coefficient.D = M.coefficient.D;
      }
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = 2*M.degrees[i];
      }
      break;
    case 5: // kept minus sign. Rest is ok. Available error only if M.sign = -1
      S.sign = -1;
      S.coefficient.N = int(pow(M.coefficient.N, 2));
      S.coefficient.D = int(pow(M.coefficient.D, 2));
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = 2*M.degrees[i];
      }
      break;
    }
    S.setDegree();
    return E;
  }

  //######################################################################################## ERROR: square root

  monomial rootError(monomial M, int errorType) {
    // monomial M is already the correct root.
    monomial R = new monomial(M.nVariables);
    R.variables = M.variables;
    // preference of positive root
    if (random(0, 1)<0.8) {
      R.sign = 1;
    } else {
      R.sign = -1;
    }
    switch(errorType) {
    case 0: // root of only numerator
      // WARNING: is correct if coefficient is an integer
      R.coefficient.N = M.coefficient.N;
      R.coefficient.D = int(pow(M.coefficient.D, 2));
      for (int i=0; i<M.nVariables; i++) {
        R.degrees[i] = M.degrees[i]*2;
      }
      break;
    case 1: // root only of variable part
      // WARNING: is correct if coefficient is 1
      R.coefficient.N = int(pow(M.coefficient.N, 2));
      R.coefficient.D = int(pow(M.coefficient.D, 2));
      for (int i=0; i<R.nVariables; i++) {
        R.degrees[i] = M.degrees[i];
      }
      break;
    case 2: // root only of coefficient
      // WARNING: is correct if coefficient is 1 or if degree is 0.
      R.sign = M.sign;
      R.coefficient.N = M.coefficient.N;
      R.coefficient.D = M.coefficient.D;
      for (int i=0; i<R.nVariables; i++) {
        R.degrees[i] = M.degrees[i]*2;
      }
      break;
    case 3: // half of coefficient (sort of fake error to have at least one available error even when the monomial is the number 1)
      R.coefficient.N = 2*M.coefficient.N;
      R.coefficient.D = M.coefficient.D;
      for (int i=0; i<R.nVariables; i++) {
        R.degrees[i] = M.degrees[i]*2;
      }
      break;
    }
    R.setDegree();
    return R;
  }

  //######################################################################################## ERROR: double product

  monomial doubleProductError(monomial M, monomial M2, int errorType) {
    monomial DP = new monomial(M.nVariables);
    DP.variables = M.variables;
    DP.sign = 1;
    switch(errorType) {
    case 0: // root of only numerator
      DP.coefficient.N = M.coefficient.N;
      DP.coefficient.D = int(pow(M.coefficient.D, 2));
      for (int i=0; i<M.nVariables; i++) {
        DP.degrees[i] = M.degrees[i]*2;
      }
      break;
    case 1: // only variable degree is cut in half
      DP.coefficient.N = int(pow(M.coefficient.N, 2));
      DP.coefficient.D = int(pow(M.coefficient.D, 2));
      for (int i=0; i<DP.nVariables; i++) {
        DP.degrees[i] = M.degrees[i];
      }
      break;
    }
    DP.setDegree();
    return DP;
  }

  //######################################################################################## ERROR: square

  monomial squareError(monomial M, int errorType) {
    // there are 6 errors in this list
    monomial S = new monomial(M.nVariables);
    S.variables = M.variables;
    switch(errorType) {
    case 0: // missed square of coefficient in squaring a monomial: (kx)^2 = kx^2
      // WARNING: is correct if coefficient is 1
      S.sign = 1;
      S.coefficient.N = M.coefficient.N;
      S.coefficient.D = M.coefficient.D;
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = M.degrees[i]*2;
      }
      break;
    case 1: // double of coefficient instead of square (kx)^2= 2kx^2
      // WARNING: is correct if coefficient is 2
      S.sign = M.sign;
      S.coefficient.N = 2*M.coefficient.N;
      S.coefficient.D = M.coefficient.D;
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = M.degrees[i]*2;
      }
      break;
    case 2: // double of monomial instead of square: (kx)^2 = 2kx
      // WARNING: is correct if monomial is constant and equal to 2
      S.sign = M.sign;
      S.coefficient.N = 2*M.coefficient.N;
      S.coefficient.D = M.coefficient.D;
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = M.degrees[i];
      }
      break;
    case 3: // square of exponent instead of double: (kx^n)^2 = k^2x^(n^2)
      // WARNING: is correct if coefficient is 1 or if exponent is 2
      S.sign = 1;
      S.coefficient.N = int(pow(M.coefficient.N, 2));
      S.coefficient.D = int(pow(M.coefficient.D, 2));
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = int(pow(M.degrees[i], 2));
      }
      break;
    case 4: // doubling coefficient, both numerator and denominator if coefficient is a fraction, while correctly squaring variables
      // WARNING: is correct if coefficient is 2
      S.sign = M.sign;
      S.coefficient.N = 2*M.coefficient.N;
      if (M.coefficient.D > 1) {
        S.coefficient.D = 2*M.coefficient.D;
      } else {
        S.coefficient.D = M.coefficient.D;
      }
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = 2*M.degrees[i];
      }
      break;
    case 5: // kept minus sign. Rest is ok. Available error only if M.sign = -1
      S.sign = -1;
      S.coefficient.N = int(pow(M.coefficient.N, 2));
      S.coefficient.D = int(pow(M.coefficient.D, 2));
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = 2*M.degrees[i];
      }
      break;
    }
    S.setDegree();
    return S;
  }

  // ########################################################################################################################### ERROR CONSTRUCTORS

  error differenceOfSquaresError(monomial M1, monomial M2, int errorType) {
    // item type: x^2 - y^2
    error E = new error();

    // check possible errors
    /*
    int errorIndex1 = U.permutation(availability(M1, "square"))[0];
     int errorIndex2 = U.permutation(availability(M2, "square"))[0];
     monomial errorM1 = squareError(M1, errorIndex1);
     monomial errorM2 = squareError(M2, errorIndex2);
     */

    int errorIndex1 = U.permutation(availability(M1, "root"))[0];
    int errorIndex2 = U.permutation(availability(M2, "root"))[0];
    monomial errorM1 = rootError(M1, errorIndex1);
    monomial errorM2 = rootError(M2, errorIndex2);

    int[] sumPerm = U.permutation(2);
    int[] diffPerm = U.permutation(2);
    int[] multPerm = U.permutation(2);

    switch(errorType) {
    case 0: // error on M1 square
      E.errorName = U.multiply(U.sum(errorM1, M2, sumPerm[0]).stringify(), U.diff(errorM1, M2, diffPerm[0]).stringify(), multPerm[0]);
      E.errorType.append(errorIndex1);
      break;
    case 1: // error on M2 square
      E.errorName = U.multiply(U.sum(M1, errorM2, sumPerm[0]).stringify(), U.diff(M1, errorM2, diffPerm[0]).stringify(), multPerm[0]);
      E.errorType.append(errorIndex2);
      break;
    case 2: // incorrect identification of monomials
      E.errorName = U.multiply(U.sum(M2, M1, sumPerm[0]).stringify(), U.diff(M2, M1, diffPerm[0]).stringify(), multPerm[0]);
      E.errorType.append(-1);
      break;
    case 3: // error on both squares
      E.errorName = U.multiply(U.sum(errorM1, errorM2, sumPerm[0]).stringify(), U.diff(errorM1, errorM2, diffPerm[0]).stringify(), multPerm[0]);
      E.errorType.append(errorIndex1);
      E.errorType.append(errorIndex2);
      break;
    case 4: // error on M1 square and incorrect identification
      E.errorName = U.multiply(U.sum(M2, errorM1, sumPerm[0]).stringify(), U.diff(M2, errorM1, diffPerm[0]).stringify(), multPerm[0]);
      E.errorType.append(errorIndex1);
      E.errorType.append(-1);
      break;
    case 5: // error on M2 square and incorrect identification
      E.errorName = U.multiply(U.sum(errorM2, M1, sumPerm[0]).stringify(), U.diff(errorM2, M1, diffPerm[0]).stringify(), multPerm[0]);
      E.errorType.append(errorIndex2);
      E.errorType.append(-1);
      break;
    case 6: // error on both squares and incorrect identification
      E.errorName = U.multiply(U.sum(errorM2, errorM1, sumPerm[0]).stringify(), U.diff(errorM2, errorM1, diffPerm[0]).stringify(), multPerm[0]);
      E.errorType.append(errorIndex1);
      E.errorType.append(errorIndex2);
      E.errorType.append(-1);
      break;
    }
    return E;
  }

  error sumDiffError(monomial M1, monomial M2, int perm) {
    // item type: (x+y)(x-y)
    error E = new error();

    // check possible errors
    int errorIndex1 = U.permutation(availability(M1, "square"))[0];
    int errorIndex2 = U.permutation(availability(M2, "square"))[0];
    monomial errorM1 = squareError(M1, errorIndex1);
    monomial errorM2 = squareError(M2, errorIndex2);

    int[] diffPerms = U.permutation(2);

    switch(perm) {
    case 0: // error on M1 square
      E.errorName = U.diff(errorM1, U.squareMonomial(M2), diffPerms[0]).stringify();
      E.errorType.append(errorIndex1);
      break;
    case 1: // error on M2 square
      E.errorName = U.diff(U.squareMonomial(M1), errorM2, diffPerms[0]).stringify();
      E.errorType.append(errorIndex2);
      break;
    case 2: // incorrect identification of monomials
      E.errorName = U.diff(U.squareMonomial(M2), U.squareMonomial(M1), diffPerms[0]).stringify();
      E.errorType.append(-1);
      break;
    case 3: // error on both squares
      E.errorName = U.diff(errorM1, errorM2, diffPerms[0]).stringify();
      E.errorType.append(errorIndex1);
      E.errorType.append(errorIndex2);
      break;
    case 4: // error on M1 square and incorrect identification
      E.errorName = U.diff(U.squareMonomial(M2), errorM1, diffPerms[0]).stringify();
      E.errorType.append(errorIndex1);
      E.errorType.append(-1);
      break;
    case 5: // error on M2 square and incorrect identification
      E.errorName = U.diff(errorM2, U.squareMonomial(M1), diffPerms[0]).stringify();
      E.errorType.append(errorIndex2);
      E.errorType.append(-1);
      break;
    case 6: // error on both squares and incorrect identification
      E.errorName = U.diff(errorM2, errorM1, diffPerms[0]).stringify();
      E.errorType.append(errorIndex1);
      E.errorType.append(errorIndex2);
      E.errorType.append(-1);
      break;
    }
    return E;
  }

  error binomialSquareExpandedError(monomial M1, monomial M2, int errorType) {
    // item type: x^2 + y^2 + 2xy
    error E = new error();

    // check possible errors
    int[] availability1 = availability(M1, "root");
    int[] availability2 = availability(M2, "root");
    int errorIndex1 = utils.permutation(availability1)[0];
    monomial errorM1 = rootError(M1, errorIndex1);
    int errorIndex2 = utils.permutation(availability2)[0];
    monomial errorM2 = rootError(M2, errorIndex2);

    monomial[] M = new monomial[3];
    int[] two = {2, 1};
    switch(errorType) {
    case 0: // error on M1 root
      if (latex) {
        E.errorName = "\\left(" + utils.sum(errorM1, M2, utils.permutation(2)[0]).stringify() + "\\right)^2";
      } else {
        E.errorName = "(" + utils.sum(errorM1, M2, utils.permutation(2)[0]).stringify() + ")^2";
      }
      E.errorType.append(errorIndex1);
      break;
    case 1: // error on M2 root
      if (latex) {
        E.errorName = "\\left(" + utils.sum(M1, errorM2, utils.permutation(2)[0]).stringify() + "\\right)^2";
      } else {
        E.errorName = "(" + utils.sum(M1, errorM2, utils.permutation(2)[0]).stringify() + ")^2";
      }
      E.errorType.append(errorIndex2);
      break;
    case 2: // error on both roots
      if (latex) {
        E.errorName = "\\left(" + utils.sum(errorM1, errorM2, utils.permutation(2)[0]).stringify() + "\\right)^2";
      } else {
        E.errorName = "(" + utils.sum(errorM1, errorM2, utils.permutation(2)[0]).stringify() + ")^2";
      }
      E.errorType.append(errorIndex1);
      E.errorType.append(errorIndex2);
      break;
    case 3: // always positive sum
      // WARNING: error not available is monomials have same signs
      if (M1.sign * M2.sign == -1) {
        monomial M1plus = M1;
        monomial M2plus = M2;
        if (M1.sign == -1 && M2.sign == 1) {
          M1plus = utils.oppositeMonomial(M1);
        }
        if (M1.sign == 1 && M2.sign == -1) {
          M2plus = utils.oppositeMonomial(M2);
        }
        if (latex) {
          E.errorName = "\\left(" + utils.sum(M1plus, M2plus, utils.permutation(2)[0]).stringify() + "\\right)^2";
        } else {
          E.errorName = "(" + utils.sum(M1plus, M2plus, utils.permutation(2)[0]).stringify() + ")^2";
        }
        E.errorType.append(-1);
      } else {
        E.errorName = "0";
        E.errorType.append(-3);
      }
      break;
    case 4: // if one of the monomials has only one variable and the other is a scalar, one error is the "compactification" 
      monomial monic1 = new monomial(M1.nVariables);
      monic1.variables = M1.variables;
      monic1.degrees = M1.degrees;
      monic1.coefficient = new fraction(1, 1);
      monic1.setDegree();

      monomial monic2 = new monomial(M2.nVariables);
      monic2.variables = M2.variables;
      monic2.degrees = M2.degrees;
      monic2.coefficient = new fraction(1, 1);
      monic2.setDegree();
      int a = M1.coefficient.N;
      int b = M1.coefficient.D;
      int c = M2.coefficient.N;
      int d = M2.coefficient.D;

      if (M1.degree == 0) {
        monomial P = U.productMonomial(U.squareMonomial(monic2), U.productMonomial(monic1, monic2));
        fraction f1 = new fraction(c*c, d*d);  
        if (M1.sign*M2.sign == -1) {
          fraction f2 = new fraction(-2*a*c, b*d);
          P.coefficient = math.fractionSum(f1, f2);
        } else {
          fraction f2 = new fraction(2*a*c, b*d);
          P.coefficient = math.fractionSum(f1, f2);
        }
        P.coefficient.simplify();
        E.errorName = U.sum(P, U.squareMonomial(M1), 0).stringify();
      } else {
        monomial P = U.productMonomial(U.squareMonomial(monic1), U.productMonomial(monic1, monic2));
        fraction f1 = new fraction(a*a, b*b);  
        if (M1.sign*M2.sign == -1) {
          fraction f2 = new fraction(-2*a*c, b*d);
          P.coefficient = math.fractionSum(f1, f2);
        } else {
          fraction f2 = new fraction(2*a*c, b*d);
          P.coefficient = math.fractionSum(f1, f2);
        }
        P.coefficient.simplify();
        if (P.coefficient.N == -1 && P.coefficient.D == 1) {
          E.errorName = U.removePlus(U.sum(P, U.squareMonomial(M2), 0).stringify());
        } else {          
          E.errorName = U.sum(P, U.squareMonomial(M2), 0).stringify();
        }
      }
      E.errorType.append(-5);
      break;
    }
    return E;
  }

  error binomialSquareCompactError(monomial M1, monomial M2, int errorType) {
    // item type: (x+y)^2
    error E = new error();

    // check possible errors
    int errorIndex1 = utils.permutation(availability(M1, "square"))[0];
    int errorIndex2 = utils.permutation(availability(M2, "square"))[0];
    int errorIndex3 = utils.permutation(availability(M2, "double product"))[0];

    monomial errorM1 = squareError(M1, errorIndex1);
    monomial errorM2 = squareError(M2, errorIndex2);
    monomial errorM1M2 = doubleProductError(M1, M2, errorIndex3);

    monomial[] M = new monomial[3];
    int[] two = {2, 1};
    switch(errorType) {
    case 0: // error on M1 square
      M[0] = errorM1;
      M[1] = utils.squareMonomial(M2);
      M[2] = utils.productMonomial(utils.scalarProduct(M1, two), M2);
      E.errorName = utils.multiSum(M, utils.permutation(3)).stringify();
      E.errorType.append(errorIndex1);
      break;
    case 1: // error on M2 square
      M[0] = utils.squareMonomial(M1);
      M[1] = errorM2;
      M[2] = utils.productMonomial(utils.scalarProduct(M1, two), M2);
      E.errorName = utils.multiSum(M, utils.permutation(3)).stringify();
      E.errorType.append(errorIndex2);
      break;
    case 2: // error on both squares
      M[0] = errorM1;
      M[1] = errorM2;
      M[2] = utils.productMonomial(utils.scalarProduct(M1, two), M2);
      E.errorName = utils.multiSum(M, utils.permutation(3)).stringify();
      E.errorType.append(errorIndex1);
      E.errorType.append(errorIndex2);
      break;
    case 3: // sophomore's dream
      E.errorName = utils.sum(utils.squareMonomial(M1), utils.squareMonomial(M2), 0).stringify();
      E.errorType.append(-1);
      break;
    case 4: // wrong double product sign
      M[0] = utils.squareMonomial(M1);
      M[1] = utils.squareMonomial(M2);
      M[2] = utils.oppositeMonomial(utils.productMonomial(utils.scalarProduct(M1, two), M2));    
      E.errorName = utils.multiSum(M, utils.permutation(3)).stringify();
      E.errorType.append(errorIndex1);
      E.errorType.append(-1);
      break;
    }
    return E;
  }

  //############################################################################ END ERRORS

  int[] availability(monomial M, String type) {
    IntList availableErrors = new IntList();
    switch(type) {
    case "square":
      // 6 error cases
      for (int i=0; i<6; i++) {
        availableErrors.append(i);
      }
      boolean allSquare = true;
      for (int i=0; i<M.nVariables; i++) {
        if (M.degrees[i] != 2) {
          allSquare = false;
          i = M.nVariables;
        }
      }
      if (allSquare) {
        // if all degrees are equal to 2, error 3 not available
        availableErrors = utils.removeInt(availableErrors, 3);
      }
      if (M.sign == 1) {
        // if M has positive coefficient, error 5 not available
<<<<<<< HEAD
        availableErrors = U.removeInt(availableErrors, 5);
=======
        availableErrors = utils.removeInt(availableErrors, 5);
>>>>>>> restructure_errors
        if (M.coefficient.D == 1) {
          switch(M.coefficient.N) {
          case 1:
            // if M has coefficient 1, error 0 and 3  not available
            availableErrors = utils.removeInt(availableErrors, 0);
            availableErrors = utils.removeInt(availableErrors, 3);
            break;
          case 2:
            // if M has coefficient 2, error 1 and 4 not available
            availableErrors = utils.removeInt(availableErrors, 1);
            availableErrors = utils.removeInt(availableErrors, 4);
            break;
          }
        }
      }
      break;
    case "double product":
      for (int i=0; i<5; i++) {
        availableErrors.append(i);
      }
      break;
    case "root":
      for (int i=0; i<4; i++) {
        availableErrors.append(i);
      }
      if (M.coefficient.D == 1 && M.degree == 0) {
        // monomial is an integer
        availableErrors = U.removeInt(availableErrors, 0);
        if (M.coefficient.N == 1) {
          // monomial is the number 1
          availableErrors = U.removeInt(availableErrors, 1);
          availableErrors = U.removeInt(availableErrors, 2);
        }
      }
      if (M.coefficient.N == 1 && M.coefficient.D == 1) {
        availableErrors = U.removeInt(availableErrors, 1);
      }
      if (M.degree == 0) {
        availableErrors = U.removeInt(availableErrors, 2);
      }
      break;
    }
    int[] errors = new int[availableErrors.size()];

    for (int i=0; i<availableErrors.size(); i++) {
      errors[i] = availableErrors.get(i);
    }

    return errors;
  }
}
