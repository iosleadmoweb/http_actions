import 'package:http_actions/http_actions.dart';

class HttpInstance with HttpActionMixin implements HttpActions {
  HttpInstance._([HttpBaseOptions? options]) {
    options = HttpBaseOptions(
      baseUrl: "https://fakestoreapi.com/",
      showlogs: true,
    );
    this.options = options;

    interceptorsWrapper = InterceptorsWrapper(
      onRequest: (options) async {
        if (options.path != "/login") {
          options.cacheData = true;
        }
        options.headers = {"Content-Type": "application/json"};
        return options;
      },
      onResponse: (response) async {
        // response.resolveType = ResolveType.doResolve;
        return response;
      },
    );
  }
  static HttpActions getInstance() => HttpInstance._();
}
