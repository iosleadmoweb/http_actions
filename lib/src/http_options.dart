enum ResponseType { json, stream, plain, bytes }

enum ResolveType {
  doContinue,
  doResolve,
}

extension ResolveTypeHelpers on ResolveType {
  bool get isDoContinue => this == ResolveType.doContinue;
  bool get isDoResolve => this == ResolveType.doResolve;
}

class HttpBaseOptions {
  String baseUrl;
  Map<String, String>? headers;
  Duration timeOut;
  bool showlogs;
  bool cacheDate;

  HttpBaseOptions(
      {required this.baseUrl,
      this.headers,
      this.timeOut = const Duration(minutes: 5),
      this.showlogs = true,
      this.cacheDate = false});

  static HttpBaseOptions initOptions() {
    return HttpBaseOptions(
        baseUrl: "", headers: {"Authorization": "application/json"});
  }
}

class HttpRequestOption extends HttpBaseOptions {
  Map<String, dynamic>? queryParam;
  Object? extra;
  String path;

  HttpRequestOption({
    this.queryParam,
    this.extra,
    required this.path,
    required String baseUrl,
    Map<String, String>? headers,
  }) : super(baseUrl: baseUrl) {
    this.headers = removeDuplicates(headers ?? {});
  }

  Map<String, String> removeDuplicates(Map<String, String> map) {
    Map<String, String> uniqueMap = {};
    map.forEach((key, value) {
      if (!uniqueMap.containsKey(key)) {
        uniqueMap[key] = value;
      }
    });
    return uniqueMap;
  }

  Uri get requestUrl {
    String concetUrl = baseUrl + path;
    if (queryParam != null && queryParam?.isNotEmpty == true) {
      queryParam!.forEach((key, value) {
        if (key == queryParam!.keys.first) {
          concetUrl += "?$key=$value";
        } else {
          concetUrl += "&$key=$value";
        }
      });
    }
    return Uri.parse(concetUrl);
  }
}

class HttpResponseOption extends HttpBaseOptions {
  Map<String, dynamic>? queryParam;
  Object? extra;
  String path;
  int? statusCode;
  ResolveType resolveType = ResolveType.doContinue;

  HttpResponseOption({
    required this.path,
    required String baseUrl,
    this.statusCode,
    Map<String, String>? headers,
  }) : super(baseUrl: baseUrl, headers: headers);
}
