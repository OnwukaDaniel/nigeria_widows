class Success {
  int code;
  Object response;

  Success({required this.code, required this.response});
}

class Failure {
  int code;
  Object errorResponse;

  Failure({required this.code, this.errorResponse = "No response"});
}
