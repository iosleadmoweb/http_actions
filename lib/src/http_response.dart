import 'package:http_actions/http_actions.dart';

class HttpBaseResponse {
  HttpBaseResponse({
    this.data,
    this.statusCode,
    this.responseOption,
  });

  Object? data;
  int? statusCode;
  HttpResponseOption? responseOption;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["code"] = statusCode;
    jsonData["data"] = data;
    return jsonData;
  }

  HttpBaseResponse.fromJson(Map<String, dynamic> json) {
    data = json["data"];
    statusCode = json["code"];
  }
}
