class monomial {
  int sign; // +1 or -1
  int nVariables;
  int[] coefficient = new int[2];
  int[] variables;
  int[] degrees;
  int degree = 0;

  monomial(int nVariables) {
    this.nVariables = nVariables;
    variables = new int[nVariables];
    degrees = new int[nVariables];
  }


  void setDegree() {
    for (int i=0; i<nVariables; i++) {
      degree = degree + degrees[i];
    }
  }

  boolean isInt() {
    boolean check = false;
    if (coefficient[1] == 1) {
      check = true;
    }
    return check;
  }

  String stringify() {
    String M = "";
    String _sign = "";
    String _coefficient = "";
    String _variables = "";

    if (sign == -1) {
      _sign = "-";
    } else {
      _sign = "+";
    }

    // check if coefficient is 1
    if (coefficient[0] == 1 && coefficient[1] == 1 && degree == 0) {
      // monomial is unity: +1 or -1
      _coefficient = str(1);
    }    

    if (coefficient[0] != 1 && coefficient[1] == 1) {
      // coefficient is an integer different from 1
      _coefficient = str(coefficient[0]);
    }

    if (coefficient[1] > 1) {
      // coefficient is a fraction.
      _coefficient = str(coefficient[0]) + "/" + str(coefficient[1]);
    }

    for (int i=0; i<nVariables; i++) {
      if (degrees[i] > 1) {
        _variables = _variables + U.varNames[variables[i]]+"^"+str(degrees[i]);
      } else {
        _variables = _variables + U.varNames[variables[i]];
      }
    }

    M = _sign + _coefficient + _variables;

    return M;
  }
}
