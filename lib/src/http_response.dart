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
}
