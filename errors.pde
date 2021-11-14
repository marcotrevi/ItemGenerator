class errors {
  errors() {
  }

  //######################################################################################## ERROR: power evaluation

  fraction powerError(fraction a, int N, int errorType) {
    // #errors: 3
    fraction f = new fraction(1, 1);
    fraction n = new fraction(1,1);
    n.N = N;
    switch(errorType) {
    case 0: // multiplication instead of power.
      // WARNING: is correct if: n=1; a=2 & n=2
      f.N = a.N*n.N;
      f.D = a.D;
      f.sign = a.sign;
      break;
    case 1: // sum instead of power
      // WARNING: is correct if: a=0 & n=1; a=2 & n=2
      f.N = a.N + n.N;
      f.D = a.D;  
      f.sign = a.sign;
      break;
    case 2: // does nothing if n=0
      // WARNING: is correct if: n=1; available only if: n=0
      f.N = a.N;
      f.D = a.D;
      f.sign = a.sign;
      break;
    case 3: // forgets minus sign
      f = utils.power(a, n);
      f.sign = 1;
      break;
    case 4: // 0
      f.N = 0;
      f.D = 1;
      f.sign = a.sign;
      break;
    case 5: // 1
      f.N = 1;
      f.D = 1;
      f.sign = a.sign;
      break;
    }
    return f;
  }

  //######################################################################################## ERROR: square root

  monomial rootError(monomial M, int errorType) {
    // #errors: 4
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
    // #errors: 2
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
    // #errors: 6
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

  //############################################################################ END ERRORS

  IntList availabilityArithmetic(String type, IntList availableErrors, fraction[] parameters) {
    IntList subsetErrors = new IntList();
    int n_cases = availableErrors.size();
    switch(type) {
    case "power evaluation":
      // parameters[0]: base
      // parameters[1]: exponent
      fraction base = parameters[0];
      fraction exponent = parameters[1];
      for (int i=0; i<n_cases; i++) {
        int index = availableErrors.get(i);
        if (!utils.areFractionsEqual(powerError(base, exponent.N, index), utils.power(base, exponent)))
          subsetErrors.append(index);
      }
      break;
    }
    return subsetErrors;
  }

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
      if (M.isTwo()) {
        // if monomial is the scalar 2, error 2 not available
        availableErrors = utils.removeInt(availableErrors, 2);
      }
      if (allSquare) {
        // if all degrees are equal to 2, error 3 not available
        availableErrors = utils.removeInt(availableErrors, 3);
      }
      if (M.sign == 1) {
        // if M has positive coefficient, error 5 not available
        availableErrors = utils.removeInt(availableErrors, 5);
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
        availableErrors = utils.removeInt(availableErrors, 0);
        if (M.isOne()) {
          // monomial is the number 1
          availableErrors = utils.removeInt(availableErrors, 1);
          availableErrors = utils.removeInt(availableErrors, 2);
        }
      }
      if (M.isMonic()) {
        availableErrors = utils.removeInt(availableErrors, 1);
      }
      if (M.isScalar()) {
        availableErrors = utils.removeInt(availableErrors, 2);
      }
      break;
    case "power":
      for (int i=0; i<4; i++) {
        availableErrors.append(i);
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
