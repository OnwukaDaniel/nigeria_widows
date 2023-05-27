class APIResponse {
  int code;
  String response;

  APIResponse({required this.code, required this.response});
}
class Success {
  int code;
  Object response;

  Success({required this.code, required this.response});
}
