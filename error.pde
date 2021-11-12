class error {
  int[] errorCode = new int[3]; // a taxonomy of errors 
  String errorName = "";
  IntList errorType = new IntList();
  String description = "";
  monomial monomial;
  fraction scalar;

  error() {
//    this.errorCode = errorCode;
  }

  fraction evaluateError(fraction[] parameters) {
    fraction f = new fraction(0, 0);
    switch(errorCode[0]) {
    case 0:
      switch(errorCode[1]) {
      case 0:
        switch(errorCode[2]) {
        case 0: // error 0.0.0
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
