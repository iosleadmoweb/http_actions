import 'package:http_actions/http_actions.dart';

class HttpInstance with HttpActionMixin implements HttpActions {
  HttpInstance._([HttpBaseOptions? options]) {
    options = HttpBaseOptions(
      baseUrl: "https://fakestoreapi.com/",
    );
    this.options = options;

    interceptorsWrapper = InterceptorsWrapper(
      onRequest: (options) async {
        options.headers = {"Content-Type": "application/json"};
        return options;
      },
      onResponse: (response) async {
        return response;
      },
    );
  }
  static HttpActions getInstance() => HttpInstance._();
}
