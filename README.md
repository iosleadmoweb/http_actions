# http_actions

A HTTP networking package for Dart/Flutter,
supports Global configuration, Interceptors, FormData,
File uploading/downloading,
Timeout, Cache Data etc. 

## Why use this package?
A powerful Flutter package for making HTTP requests with support for interceptors and caching with dynamic configuration.

## Interceptors
Interceptors are a powerful feature of our Flutter package that allow you to intercept and manipulate HTTP requests and responses before they are sent or received. With interceptors, you gain fine-grained control over the communication between your Flutter app and the server, enabling you to add authentication tokens, modify headers, log requests, or even implement caching strategies. Whether you need to enhance security, optimize network performance, or customize request handling, our package's interceptors provide a flexible and convenient solution for all your HTTP communication needs.

## Cache
Our Flutter package goes beyond traditional HTTP request handling by offering a seamless cache data flow. With our cache data flow, you can effortlessly store and retrieve HTTP responses, gracefully handling offline scenarios, our package's cache data flow empowers your Flutter app to provide a smoother user experience.


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
      // Pass the common header for all requests
      headers: {},
      // Add request timeout
      timeOut: const Duration(minutes: 5),
    );
    this.options = options;
    interceptorsWrapper = InterceptorsWrapper(
      onRequest: (options) async {
        options.cacheData = false;
        //If you want to pass specific header for specific request then you should options.headers.
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
