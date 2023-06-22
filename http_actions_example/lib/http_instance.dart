import 'package:http_actions/http_actions.dart';

class HttpInstance with HttpActionMixin implements HttpActions {
  HttpInstance._([HttpBaseOptions? options]) {
    options = HttpBaseOptions(
      baseUrl: "http://ec2-54-234-190-161.compute-1.amazonaws.com/v1/",
      showlogs: true,
    );
    this.options = options;

    interceptorsWrapper = InterceptorsWrapper(
      onRequest: (options) async {
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
