import 'package:http_actions/http_actions.dart';
import 'package:http/http.dart' as http;

abstract class HttpActions {
  HttpActions();

  late HttpBaseOptions options;

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

  Future<HttpBaseResponse> onRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
    required HttpRequestNames requestName,
  });

  Future<http.Response> fetchAPI({
    Object? data,
    required HttpRequestOption requestOption,
    required HttpRequestNames requestName,
  });

  Future<http.Response> multipartFetch({
    required dynamic body,
    required HttpRequestNames requestName,
    required HttpRequestOption requestOption,
  });

  Future<void> download(String url,
      {required Function(int totalBytes, int receivedBytes) onDownloadProgress,
      required Function(List<int> totalBytes) onDownloadDone});
}
