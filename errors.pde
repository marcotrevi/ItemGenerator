class errors { 

  errors() {
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
      R.coefficient[0] = M.coefficient[0];
      R.coefficient[1] = int(pow(M.coefficient[1], 2));
      for (int i=0; i<M.nVariables; i++) {
        R.degrees[i] = M.degrees[i]*2;
      }
      break;
    case 1: // root only of variable part
      // WARNING: is correct if coefficient is 1
      R.coefficient[0] = int(pow(M.coefficient[0], 2));
      R.coefficient[1] = int(pow(M.coefficient[1], 2));
      for (int i=0; i<R.nVariables; i++) {
        R.degrees[i] = M.degrees[i];
      }
      break;
    case 2: // root only of coefficient
      // WARNING: is correct if coefficient is 1
      R.coefficient[0] = M.coefficient[0];
      R.coefficient[1] = M.coefficient[1];
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
      DP.coefficient[0] = M.coefficient[0];
      DP.coefficient[1] = int(pow(M.coefficient[1], 2));
      for (int i=0; i<M.nVariables; i++) {
        DP.degrees[i] = M.degrees[i]*2;
      }
      break;
    case 1: // only variable degree is cut in half
      DP.coefficient[0] = int(pow(M.coefficient[0], 2));
      DP.coefficient[1] = int(pow(M.coefficient[1], 2));
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
      S.coefficient[0] = M.coefficient[0];
      S.coefficient[1] = M.coefficient[1];
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = M.degrees[i]*2;
      }
      break;
    case 1: // double of coefficient instead of square (kx)^2= 2kx^2
      // WARNING: is correct if coefficient is 2
      S.sign = M.sign;
      S.coefficient[0] = 2*M.coefficient[0];
      S.coefficient[1] = M.coefficient[1];
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = M.degrees[i]*2;
      }
      break;
    case 2: // double of monomial instead of square: (kx)^2 = 2kx
      // WARNING: is correct if monomial is constant and equal to 2
      S.sign = M.sign;
      S.coefficient[0] = 2*M.coefficient[0];
      S.coefficient[1] = M.coefficient[1];
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = M.degrees[i];
      }
      break;
    case 3: // square of exponent instead of double: (kx^n)^2 = k^2x^(n^2)
      // WARNING: is correct if coefficient is 1 or if exponent is 2
      S.sign = 1;
      S.coefficient[0] = int(pow(M.coefficient[0], 2));
      S.coefficient[1] = int(pow(M.coefficient[1], 2));
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = int(pow(M.degrees[i], 2));
      }
      break;
    case 4: // doubling coefficient, both numerator and denominator if coefficient is a fraction, while correctly squaring variables
      // WARNING: is correct if coefficient is 2
      S.sign = M.sign;
      S.coefficient[0] = 2*M.coefficient[0];
      if (M.coefficient[1] > 1) {
        S.coefficient[1] = 2*M.coefficient[1];
      } else {
        S.coefficient[1] = M.coefficient[1];
      }
      for (int i=0; i<S.nVariables; i++) {
        S.degrees[i] = 2*M.degrees[i];
      }
      break;
    case 5: // kept minus sign. Rest is ok. Available error only if M.sign = -1
      S.sign = -1;
      S.coefficient[0] = int(pow(M.coefficient[0], 2));
      S.coefficient[1] = int(pow(M.coefficient[1], 2));
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
    int errorIndex1 = U.permutation(availability(M1, "square"))[0];
    int errorIndex2 = U.permutation(availability(M2, "square"))[0];
    monomial errorM1 = squareError(M1, errorIndex1);
    monomial errorM2 = squareError(M2, errorIndex2);

    switch(errorType) {
    case 0: // error on M1 square
      E.errorName = U.multiply(U.sum(errorM1, M2, 0), U.diff(errorM1, M2, 0), 0);
      E.errorType.append(errorIndex1);
      break;
    case 1: // error on M2 square
      E.errorName = U.multiply(U.sum(M1, errorM2, 0), U.diff(M1, errorM2, 0), 0);
      E.errorType.append(errorIndex2);
      break;
    case 2: // incorrect identification of monomials
      E.errorName = U.multiply(U.sum(M2, M1, 0), U.diff(M2, M1, 0), 0);
      E.errorType.append(-1);
      break;
    case 3: // error on both squares
      E.errorName = U.multiply(U.sum(errorM1, errorM2, 0), U.diff(errorM1, errorM2, 0), 0);
      E.errorType.append(errorIndex1);
      E.errorType.append(errorIndex2);
      break;
    case 4: // error on M1 square and incorrect identification
      E.errorName = U.multiply(U.sum(M2, errorM1, 0), U.diff(M2, errorM1, 0), 0);
      E.errorType.append(errorIndex1);
      E.errorType.append(-1);
      break;
    case 5: // error on M2 square and incorrect identification
      E.errorName = U.multiply(U.sum(errorM2, M1, 0), U.diff(errorM2, M1, 0), 0);
      E.errorType.append(errorIndex2);
      E.errorType.append(-1);
      break;
    case 6: // error on both squares and incorrect identification
      E.errorName = U.multiply(U.sum(errorM2, errorM1, 0), U.diff(errorM2, errorM1, 0), 0);
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
      E.errorName = U.diff(errorM1, U.squareMonomial(M2), diffPerms[0]);
      E.errorType.append(errorIndex1);
      break;
    case 1: // error on M2 square
      E.errorName = U.diff(U.squareMonomial(M1), errorM2, diffPerms[0]);
      E.errorType.append(errorIndex2);
      break;
    case 2: // incorrect identification of monomials
      E.errorName = U.diff(U.squareMonomial(M2), U.squareMonomial(M1), diffPerms[0]);
      E.errorType.append(-1);
      break;
    case 3: // error on both squares
      E.errorName = U.diff(errorM1, errorM2, diffPerms[0]);
      E.errorType.append(errorIndex1);
      E.errorType.append(errorIndex2);
      break;
    case 4: // error on M1 square and incorrect identification
      E.errorName = U.diff(U.squareMonomial(M2), errorM1, diffPerms[0]);
      E.errorType.append(errorIndex1);
      E.errorType.append(-1);
      break;
    case 5: // error on M2 square and incorrect identification
      E.errorName = U.diff(errorM2, U.squareMonomial(M1), diffPerms[0]);
      E.errorType.append(errorIndex2);
      E.errorType.append(-1);
      break;
    case 6: // error on both squares and incorrect identification
      E.errorName = U.diff(errorM2, errorM1, diffPerms[0]);
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
    int errorIndex1 = U.permutation(availability(M1, "root"))[0];
    int errorIndex2 = U.permutation(availability(M2, "root"))[0];

    monomial errorM1 = rootError(M1, errorIndex1);
    monomial errorM2 = rootError(M2, errorIndex2);
    println("error index 1: "+errorIndex1);
    println("square : "+U.squareMonomial(M1).stringify());
    println("root   : "+M1.stringify());
    println("error  : "+errorM1.stringify());
    println("error index 2: "+errorIndex2);
    println("square : "+U.squareMonomial(M2).stringify());
    println("root   : "+M2.stringify());
    println("error  : "+errorM2.stringify());

    monomial[] M = new monomial[3];
    int[] two = {2, 1};
    switch(errorType) {
    case 0: // error on M1 root
      E.errorName = "(" + U.sum(errorM1, M2, U.permutation(2)[0]) + ")^2";
      E.errorType.append(errorIndex1);
      break;
    case 1: // error on M2 root
      E.errorName = "(" + U.sum(M1, errorM2, U.permutation(2)[0]) + ")^2";
      E.errorType.append(errorIndex2);
      break;
    case 2: // error on both roots
      E.errorName = "(" + U.sum(errorM1, errorM2, U.permutation(2)[0]) + ")^2";
      E.errorType.append(errorIndex1);
      E.errorType.append(errorIndex2);
      break;
    case 3: // always positive sum
      // WARNING: error not available is monomials have different signs
      if (M1.sign * M2.sign == -1) {
        monomial M1plus = M1;
        monomial M2plus = M2;
        if (M1.sign == -1 && M2.sign == 1) {
          M1plus = U.oppositeMonomial(M1);
        }
        if (M1.sign == 1 && M2.sign == -1) {
          M2plus = U.oppositeMonomial(M2);
        }
        E.errorName = "(" + U.sum(M1plus, M2plus, U.permutation(2)[0]) + ")^2";
        E.errorType.append(-1);
      } else {
        E.errorName = "monomials have same sign";
        E.errorType.append(-3);
      }
      break;
    case 4:
      E.errorName = "0";
      E.errorType.append(errorIndex1);
      E.errorType.append(-2);
      break;
    }
    return E;
  }

  error binomialSquareCompactError(monomial M1, monomial M2, int errorType) {
    // item type: (x+y)^2
    error E = new error();

    // check possible errors
    int errorIndex1 = U.permutation(availability(M1, "square"))[0];
    int errorIndex2 = U.permutation(availability(M2, "square"))[0];
    int errorIndex3 = U.permutation(availability(M2, "double product"))[0];

    monomial errorM1 = squareError(M1, errorIndex1);
    monomial errorM2 = squareError(M2, errorIndex2);
    monomial errorM1M2 = doubleProductError(M1, M2, errorIndex3);

    monomial[] M = new monomial[3];
    int[] two = {2, 1};
    switch(errorType) {
    case 0: // error on M1 square
      M[0] = errorM1;
      M[1] = U.squareMonomial(M2);
      M[2] = U.productMonomial(U.scalarProduct(M1, two), M2);
      E.errorName = U.multiSum(M, U.permutation(3));
      E.errorType.append(errorIndex1);
      break;
    case 1: // error on M2 square
      M[0] = U.squareMonomial(M1);
      M[1] = errorM2;
      M[2] = U.productMonomial(U.scalarProduct(M1, two), M2);
      E.errorName = U.multiSum(M, U.permutation(3));
      E.errorType.append(errorIndex2);
      break;
    case 2: // error on both squares
      M[0] = errorM1;
      M[1] = errorM2;
      M[2] = U.productMonomial(U.scalarProduct(M1, two), M2);
      E.errorName = U.multiSum(M, U.permutation(3));
      E.errorType.append(errorIndex1);
      E.errorType.append(errorIndex2);
      break;
    case 3: // sophomore's dream
      E.errorName = U.sum(U.squareMonomial(M1), U.squareMonomial(M2), 0);
      E.errorType.append(-1);
      break;
    case 4: // wrong double product sign
      M[0] = U.squareMonomial(M1);
      M[1] = U.squareMonomial(M2);
      M[2] = U.oppositeMonomial(U.productMonomial(U.scalarProduct(M1, two), M2));    
      E.errorName = U.multiSum(M, U.permutation(3));
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
        availableErrors = U.removeInt(availableErrors, 3);
      }
      if (M.sign == 1) {
        // if M has positive coefficient, error 5 not available
        availableErrors = U.removeInt(availableErrors, 5);
        if (M.coefficient[1] == 1) {
          switch(M.coefficient[0]) {
          case 1:
            // if M has coefficient 1, error 0 and 3  not available
            availableErrors = U.removeInt(availableErrors, 0);
            availableErrors = U.removeInt(availableErrors, 3);
            break;
          case 2:
            // if M has coefficient 2, error 1 and 4 not available
            availableErrors = U.removeInt(availableErrors, 1);
            availableErrors = U.removeInt(availableErrors, 4);
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
      for (int i=0; i<2; i++) {
        availableErrors.append(i);
      }
      if (M.coefficient[1] == 1 && M.degree == 0) {
        // monomial is an integer
        availableErrors = U.removeInt(availableErrors, 0);
        if (M.coefficient[0] == 1) {
          // monomial is the number 1
          availableErrors = U.removeInt(availableErrors, 1);
          availableErrors = U.removeInt(availableErrors, 2);
        }
      }
      if (M.coefficient[0] == 1 && M.coefficient[1] == 1) {
        availableErrors = U.removeInt(availableErrors, 1);
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
