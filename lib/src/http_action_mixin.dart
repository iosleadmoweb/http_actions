import 'dart:convert';
import 'dart:developer';

import 'package:http_actions/http_actions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

abstract class HttpActionMixin implements HttpActions {
  @override
  HttpBaseOptions? options;

  @override
  InterceptorsWrapper? interceptorsWrapper;

  InterceptorsWrapper? get _inter => interceptorsWrapper;

  http.Client get _client => http.Client();

  // Handler method to make http GET request,
  @override
  Future<HttpBaseResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  }) {
    return _onRequest(
      path,
      queryParameters: queryParameters,
      requestName: HttpRequestNames.GET,
      header: header,
    );
  }

  // Handler method to make downlaod request,
  @override
  Future<void> download(String url,
      {required Function(int totalBytes, int receivedBytes) onDownloadProgress,
      required Function(List<int> totalBytes) onDownloadDone}) async {
    options ??= HttpBaseOptions.initOptions();
    //Get header which is are available in BaseOption
    Map<String, String> allHeaders = options!.headers ?? {};

    //Create RequestOption object with baseUrl, headers, path and queryParameters
    HttpRequestOption requestOption = HttpRequestOption(
      baseUrl: url,
      headers: allHeaders,
      path: url,
    );

    //Check in Interceptor is not null then should do call back of request with Interceptor
    // to get any extra value from user
    if (_inter != null && _inter?.onRequest != null) {
      requestOption = await _inter!.onRequest!(
        requestOption,
      );
    }
    int _total = 0, _received = 0;
    late http.StreamedResponse _response;
    final List<int> _bytes = [];

    //Send request and stream response
    _response = await http.Client().send(
      http.Request(
        HttpRequestNames.GET.name,
        Uri.parse(url),
      ),
    )
      ..headers.addAll(requestOption.headers ?? {});
    _total = _response.contentLength ?? 0;

    //listening stream
    _response.stream.listen((value) {
      //Updating all bytes
      _bytes.addAll(value);

      //Updating received bytes
      _received += value.length;

      //Call back function to update in UI.
      onDownloadProgress(
        _total,
        _received,
      );
    }).onDone(() async {
      //Done download files and call callback function to update in UI.
      onDownloadDone(_bytes);
    });
  }

  // Handler method to make http post request,
  @override
  Future<HttpBaseResponse> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  }) {
    return _onRequest(path,
        queryParameters: queryParameters,
        requestName: HttpRequestNames.POST,
        header: header,
        data: data);
  }

  // Handler method to make http patch request,
  @override
  Future<HttpBaseResponse> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  }) {
    return _onRequest(path,
        queryParameters: queryParameters,
        requestName: HttpRequestNames.PATCH,
        header: header,
        data: data);
  }

  // Handler method to make http put request,
  @override
  Future<HttpBaseResponse> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  }) {
    return _onRequest(path,
        queryParameters: queryParameters,
        requestName: HttpRequestNames.PUT,
        header: header,
        data: data);
  }

  // Handler method to make http delete request,
  @override
  Future<HttpBaseResponse> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  }) {
    return _onRequest(path,
        queryParameters: queryParameters,
        requestName: HttpRequestNames.DELETE,
        header: header,
        data: data);
  }

  //Handel all http request throut here
  //[path] last path of request
  //[data] request data
  //[queryParameters] request queryParam
  //[header] request headers (If any perticular api need any extra header)
  //[requestName] identifire of request name
  // @override
  Future<HttpBaseResponse> _onRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
    required HttpRequestNames requestName,
  }) async {
    options ??= HttpBaseOptions.initOptions();
    //Get header which is are available in BaseOption
    Map<String, String> allHeaders = options!.headers ?? {};
    if (header != null) {
      //If extra header not null then should concet it
      allHeaders.addAll(header);
    }

    //Create RequestOption object with baseUrl, headers, path and queryParameters
    HttpRequestOption requestOption = HttpRequestOption(
      baseUrl: options!.baseUrl,
      headers: allHeaders,
      path: path,
      queryParam: queryParameters,
    );

    //Check in Interceptor is not null then should do call back of request with Interceptor
    // to get any extra value from user
    if (_inter != null && _inter?.onRequest != null) {
      requestOption = await _inter!.onRequest!(
        requestOption,
      );
    }

    if (!(await CacheManagerPreference.instance.checkConnection())) {
      var cachedFile = await CacheManagerPreference.instance.cacheManager
          .getFileFromCache(requestOption.requestUrl.toString());
      if (cachedFile != null) {
        var cachedData = await cachedFile.file.readAsString();
        return HttpBaseResponse.fromJson(json.decode(cachedData));
      }
    }

    //Call fetch api and get request response
    http.Response apiResponse = await _fetchAPI(
        requestName: requestName, requestOption: requestOption, data: data);

    //Create HttpResponseOption object with status, headers, path and baseUrl
    HttpResponseOption responseOption = HttpResponseOption(
      baseUrl: options!.baseUrl,
      path: path,
      statusCode: apiResponse.statusCode,
      headers: requestOption.headers,
    );

    if (options!.showlogs) {
      log("----------------Response----------------");
      log("EndPoint");
      log("${responseOption.baseUrl}${responseOption.path}");
      log("Status Code");
      log(apiResponse.statusCode.toString());
      log("Data");
      log(apiResponse.body.toString());
    }
    try {
      //Create HttpBaseResponse object with apiResponse status code
      HttpBaseResponse httpResponse = HttpBaseResponse(
        statusCode: apiResponse.statusCode,
      );

      //Check in Interceptor is not null then should do call back of onRequest with Interceptor
      // to get any extra value from user
      if (_inter != null && _inter?.onResponse != null) {
        responseOption = await _inter!.onResponse!(responseOption);
        if (responseOption.resolveType.isDoResolve) {
          return await _onRequest(path,
              requestName: requestName,
              data: data,
              header: header,
              queryParameters: queryParameters);
        }
      }

      //Decode the response from bytes
      String enCodedStr = utf8.decode(apiResponse.bodyBytes);

      //If decoded string not empty then should decode with json and set that data to HttpBaseResponse object
      if (enCodedStr.isNotEmpty) {
        httpResponse.data = jsonDecode(enCodedStr);
        //Check is there Web OR Not
        // "flutter_cache_manager" did not support in web
        if (!kIsWeb) {
          //Check is enable cache data
          if (options!.cacheData) {
            try {
              //Store data to cache_manager
              var byteList = utf8.encode(json.encode(httpResponse.toJson()));
              var bytes = Uint8List.fromList(byteList);
              await CacheManagerPreference.instance.cacheManager
                  .putFile(requestOption.requestUrl.toString(), bytes);
            } catch (e) {
              if (options!.showlogs) {
                log("----------------Cache Service----------------");
                log(e.toString());
              }
            }
          }
        }
      }
      // Set responseOption to httpResponse
      httpResponse.responseOption = responseOption;
      return httpResponse;
    } catch (e) {
      return HttpBaseResponse(
        statusCode: apiResponse.statusCode,
        responseOption: responseOption,
      );
    }
  }

  //Handel fetch api
  Future<http.Response> _fetchAPI({
    Object? data,
    required HttpRequestOption requestOption,
    required HttpRequestNames requestName,
  }) async {
    // Check if data is map and data have containsValue http.MultipartFile then should call multipart request
    if (data is Map) {
      if (data.containsValue(http.MultipartFile)) {
        return await _multipartFetch(
          body: data,
          requestName: requestName,
          requestOption: requestOption,
        );
      }
    }

    // encode request data
    final enCodedData = data == null ? null : jsonEncode(data);

    if (options!.showlogs) {
      log("----------------Request----------------");
      log("EndPoint");
      log(requestOption.requestUrl.toString());
      log("Header");
      log(requestOption.headers.toString());
      log("Data");
      log(data.toString());
    }

    // Check requestType and call appropriate request
    switch (requestName) {
      //Call Get request
      case HttpRequestNames.GET:
        return await _client
            .get(requestOption.requestUrl, headers: requestOption.headers)
            .timeout(options!.timeOut);

      //Call Post request
      case HttpRequestNames.POST:
        return await _client
            .post(requestOption.requestUrl,
                headers: requestOption.headers, body: enCodedData)
            .timeout(options!.timeOut);

      //Call Patch request
      case HttpRequestNames.PATCH:
        return await _client
            .patch(requestOption.requestUrl,
                headers: requestOption.headers, body: enCodedData)
            .timeout(options!.timeOut);

      //Call Put request
      case HttpRequestNames.PUT:
        return await _client
            .put(requestOption.requestUrl,
                headers: requestOption.headers, body: enCodedData)
            .timeout(options!.timeOut);

      //Call Delete request
      case HttpRequestNames.DELETE:
        return await _client
            .delete(requestOption.requestUrl,
                headers: requestOption.headers, body: enCodedData)
            .timeout(options!.timeOut);
    }
  }

  //Handle multipart request
  Future<http.Response> _multipartFetch({
    required dynamic body,
    required HttpRequestNames requestName,
    required HttpRequestOption requestOption,
  }) async {
    //Create multipart request object
    http.MultipartRequest request =
        http.MultipartRequest(requestName.name, requestOption.requestUrl);

    //Set all header to MultipartRequest object
    if (requestOption.headers != null) {
      for (var entry in requestOption.headers!.entries) {
        request.headers[entry.key] = entry.value;
      }
    }

    //When we doing multipart request then should Content-Type="multipart/form-data"
    request.headers["Content-Type"] = "multipart/form-data";

    //Set request files and fileds to MultipartRequest object
    for (var entry in body.entries) {
      //If value type is http.MultipartFile then should set into files else fileds
      if (entry.value is http.MultipartFile) {
        request.files.add(entry.value);
      } else {
        request.fields[entry.key] = entry.value.toString();
      }
    }

    try {
      //Send request
      var streamedResponse = await request
          .send()
          .timeout(const Duration(seconds: 1400), onTimeout: () {
        // ignore: null_argument_to_non_null_type
        return Future.value(null);
      });
      try {
        //Generate response from streamedResponse
        return await http.Response.fromStream(streamedResponse);
      } catch (e) {
        //Throw error if getting any issue
        return Future.error(e.toString());
      }
    } catch (e) {
      //Throw error if getting any issue
      return Future.error(e.toString());
    }
  }
}
