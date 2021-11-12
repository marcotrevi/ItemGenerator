class error {
  int[] errorCode = new int[3]; // a taxonomy of errors 
  String errorName = "";
  IntList errorType = new IntList();
  String description = "";
  monomial monomial;
  fraction scalar;

  error() {
  }

  fraction evaluate(fraction[] parameters) {
    fraction f = new fraction(0, 0);
    switch(errorCode[0]) {
    case 0:
      switch(errorCode[1]) {
      case 0: // powers
        fraction base = parameters[0];
        fraction exponent = parameters[1];
        switch(errorCode[2]) {
        case 0: // error 0.0.0
          f = errors._000(base, exponent);
          break;
        case 1: // error 0.0.1
          f = errors._001(base, exponent);
          break;
        case 2: // error 0.0.2
          f = errors._002(base, exponent);
          break;
        case 3: 
          f = errors._003(base, exponent);
          break;
        }
        break;
      }
      break;
    }
    return f;
  }

  boolean isAvailableWith(fraction[] parameters) {
    boolean check = true;
    return check;
  }
}
