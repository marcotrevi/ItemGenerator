class item {
  String type, stem, answer;
  String[] distractors;
  String[] errors;
  errors[] _errors;
  float complexity;

  item() {
  }

  void printme() {
    int len0 = distractors[0].length();
    int len1 = distractors[1].length();
    int len2 = distractors[2].length();
    int len = max(len0, len1, len2) + 5;
    String space = "";
    for (int i=0; i<len; i++) {
      space = space + " ";
    }
    println("---------------------------------------------------------------------------------------------");
    println("item type___: "+type);
    println("---------------------------------------------------------------------------------------------");
    println("stem________: "+stem);
    println("---------------------------------------------------------------------------------------------");
    println("answer______: "+answer);
    println("distractor 1: "+distractors[0]+ space.substring(0,len-len0) + " error type: " + errors[0]);
    println("distractor 2: "+distractors[1]+ space.substring(0,len-len1) + " error type: " + errors[1]);
    println("distractor 3: "+distractors[2]+ space.substring(0,len-len2) + " error type: " + errors[2]);
    println("---------------------------------------------------------------------------------------------");
  }

  String csv_line() {
    String l = complexity + "," + stem + "," + answer + "," + distractors[0] + ","+ distractors[1] + ","+ distractors[2];
    return l;
  }
}
