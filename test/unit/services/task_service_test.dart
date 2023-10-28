import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:sharp_wing_frontend/config/config.dart';
import 'package:sharp_wing_frontend/services/task_service.dart';
import 'package:sharp_wing_frontend/config/config.dart';
import 'package:get_it/get_it.dart';
import 'package:sharp_wing_frontend/utils/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http;

void main() {
  group("TaskService", () {
    AppConfig appConfig = TestConfig();

    //setupServiceLocator();
    serviceLocator.registerSingleton<http.Client>(MockClient((request) async {
      return http.Response("", 404);
    }));

    test('Fuck it', () {
      TaskService taskService =
          TaskService(baseApiUrl: TestConfig.baseApiUrlValue);

      taskService.getRootTask();
    });
  });
}
