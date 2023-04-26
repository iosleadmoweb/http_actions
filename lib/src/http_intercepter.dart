import 'package:http_actions/http_actions.dart';

enum InterceptorResultType {
  next,
  resolve,
  resolveCallFollowing,
  reject,
  rejectCallFollowing,
}

typedef InterceptorSendCallback = Future<HttpRequestOption> Function(
  HttpRequestOption requestOption,
);

typedef InterceptorSuccessCallback = Future<HttpResponseOption> Function(
  HttpResponseOption responseOption,
);

class InterceptorsWrapper {
  final InterceptorSendCallback? __onRequest;

  final InterceptorSuccessCallback? __onResponse;

  InterceptorsWrapper({
    InterceptorSendCallback? onRequest,
    InterceptorSuccessCallback? onResponse,
  })  : __onRequest = onRequest,
        __onResponse = onResponse;

  InterceptorSendCallback? get onRequest => __onRequest;

  InterceptorSuccessCallback? get onResponse => __onResponse;
}
