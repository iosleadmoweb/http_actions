import 'package:http_actions/http_actions.dart';

class HttpActionExample with HttpActionMixin implements HttpActions {
  HttpActionExample._() {
    options = HttpBaseOptions(
      baseUrl: "Base Url",
    );
    interceptorsWrapper = InterceptorsWrapper(
      onRequest: (options) async {
        return options;
      },
      onResponse: (responseOption) async {
        return responseOption;
      },
    );
  }
  static HttpActions getInstance() => HttpActionExample._();
}
