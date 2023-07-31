# http_actions

A HTTP networking package for Dart/Flutter,
supports Global configuration, Interceptors, FormData,
File uploading/downloading,
Timeout, Cache Data etc. 

## Get started

### Add dependency

You can use the command to add http_actions as a dependency with the latest stable version:

```console
$ dart pub add http_actions
```

Or you can manually add http_actions into the dependencies section in your pubspec.yaml:

```yaml
dependencies:
  http_actions: ^replace-with-latest-version
```

### Simple to use

```dart
import 'package:http_actions/http_actions.dart';

HttpActions httpActions = HttpActions();

void getHttp() async {
  final response = await httpActions.get('https://dart.dev');
  print(response);
}
```

## Examples

Operating a `GET` request:

```dart
import 'package:http_actions/http_actions.dart';

final HttpActions httpActions = HttpActions();

void request() async {
  HttpBaseResponse response;
  response = await httpActions.get('/somePath?id=15&name=something');
  print(response.data.toString());
  // The below request is the same as above.
  response = await httpActions.get(
    '/somePath',
    queryParameters: {'id': 15, 'name': 'something'},
  );
  print(response.data.toString());
}
```

Operating a `POST` request:

```dart
response = await httpActions.post('/somePath', data: {'id': 15, 'name': 'something'});
```

Operating a `PATCH` request:

```dart
response = await httpActions.patch('/somePath', data: {'id': 15, 'name': 'something'});
```

Operating a `PUT` request:

```dart
response = await httpActions.put('/somePath', data: {'id': 15, 'name': 'something'});
```

Operating a `DELETE` request:

```dart
response = await httpActions.delete('/somePath', data: {'id': 15, 'name': 'something'});
```

Upload multiple files to server using Multipart request:

```dart
final Map<String,dynamic> formData = {
  'name': 'http_actions',
  'date': DateTime.now().toString(),
  'file': await MultipartFile.fromPath(filed: "file", filePath: "filePath"),
};
final response = await http_actions.post('/somePath', data: formData);
```

### Interceptors

```dart
final HttpActions httpActions = HttpActions();
    httpActions.interceptorsWrapper = InterceptorsWrapper(
      onRequest: (options) async {
        // Do something before request is sent.
        // If you want to pass Authorization token in header you can pass,
            options.headers = {"Authorization":"token"};
        // If you want to cache data for specific endpoint you can do it from here using options param
            options.cacheData = false;
        return options;
      },
      onResponse: (response) async {
        // Do something with response data.
        // If you want to resolved the request OR continue call the request,
            response.resolveType = ResolveType.doResolve;
        return response;
      },
    );
final response = await http_actions.post('/somePath', data: formData);
```

### Create Http Instance

```dart
  class HttpInstance with HttpActionMixin implements HttpActions {
  HttpInstance._([HttpBaseOptions? options]) {
    options = HttpBaseOptions(
      baseUrl: "",
      showlogs: false,
      cacheData: true,
      headers: {},
      timeOut: const Duration(minutes: 5),
    );
    this.options = options;
    interceptorsWrapper = InterceptorsWrapper(
      onRequest: (options) async {
        options.cacheData = false;
        options.headers = {
          "Authorization":""
        };
        return options;
      },
      onResponse: (response) async {
        response.resolveType = ResolveType.doResolve;
        return response;
      },
    );
  }
  static HttpActions getInstance() => HttpInstance._();
}

final HttpActions httpActions = HttpInstance.getInstance();
httpActions.get("/somePath");
```
