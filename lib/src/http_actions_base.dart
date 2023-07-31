import 'package:http_actions/http_actions.dart';
// import 'package:http/http.dart' as http;

HttpActions createHttpActions([HttpBaseOptions? options]) =>
    throw UnsupportedError('');

abstract class HttpActions {
  factory HttpActions([options]) => createHttpActions(options);

  HttpBaseOptions? options;

  InterceptorsWrapper? interceptorsWrapper;

  Future<HttpBaseResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  });

  Future<HttpBaseResponse> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  });

  Future<HttpBaseResponse> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  });

  Future<HttpBaseResponse> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  });

  Future<HttpBaseResponse> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  });

  Future<void> download(String url,
      {required Function(int totalBytes, int receivedBytes) onDownloadProgress,
      required Function(List<int> totalBytes) onDownloadDone});
}
