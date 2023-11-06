import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:io';

class MockClientFactory {
  static http.Client get200Client(String response) {
    return MockClient((request) async {
      return http.Response(response, 200);
    });
  }

  static http.Client get201Client(String response) {
    return MockClient((request) async {
      return http.Response(response, 201);
    });
  }

  static http.Client get204Client() {
    return MockClient((request) async {
      return http.Response("", 204);
    });
  }

  static http.Client get404Client() {
    return MockClient((request) async {
      return http.Response("", 404);
    });
  }

  static http.Client getSocketExceptionClient() {
    return MockClient((request) async {
      throw const SocketException('This is a simulated socket exception!');
    });
  }

  static http.Client getTimeoutExceptionClient() {
    return MockClient((request) async {
      throw TimeoutException('This is a simulated timeout exception!');
    });
  }

  static http.Client getHttpExceptionClient() {
    return MockClient((request) async {
      throw const HttpException('This is a simulated http exception!');
    });
  }
}
