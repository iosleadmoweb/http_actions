import 'package:http/http.dart' as http;

enum HttpRequestNames {
  GET,
  POST,
  PATCH,
  PUT,
  DELETE,
}

class HttpHelperss {
  Future<http.MultipartFile> generatePathToMultipartFile({
    required String keyName,
    required String filePath,
  }) async {
    return await http.MultipartFile.fromPath(
      keyName,
      filePath,
    );
  }
}
