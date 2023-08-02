import 'package:http/http.dart' as http;
import 'package:http_actions/http_actions.dart';

enum HttpRequestNames {
  GET,
  POST,
  PATCH,
  PUT,
  DELETE,
}

extension HttpRequestNamesHelpers on HttpRequestNames {
  bool get isGet => this == HttpRequestNames.GET;
}

class MultipartFile {
  static Future<http.MultipartFile> fromPath(
      {required String filed,
      required String filePath,
      String? filename,
      MediaType? contentType}) async {
    return await http.MultipartFile.fromPath(
      filed,
      filePath,
      contentType: contentType,
      filename: filename,
    );
  }

  static Future<http.MultipartFile> fromString(
      {required String filed,
      required String value,
      String? filename,
      MediaType? contentType}) async {
    return await http.MultipartFile.fromString(
      filed,
      value,
      contentType: contentType,
      filename: filename,
    );
  }

  static Future<http.MultipartFile> fromBytes(
      {required String filed,
      required Uint8List value,
      String? filename,
      MediaType? contentType}) async {
    return await http.MultipartFile.fromBytes(
      filed,
      value,
      contentType: contentType,
      filename: filename,
    );
  }
}
