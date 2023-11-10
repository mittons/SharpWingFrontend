import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sharp_wing_frontend/config/config.dart';
import 'package:sharp_wing_frontend/models/task.dart';
import 'package:sharp_wing_frontend/services/task_service.dart';
import 'package:sharp_wing_frontend/services/task_service_result.dart';
import 'package:sharp_wing_frontend/utils/service_locator.dart';
import 'package:http/http.dart' as http;

import '../../mock/mock_http_client_factory.dart';
import '../../mock/mock_task_data_layer.dart';

void main() {
  group('TaskService Unit Tests - Happy paths', () {
    AppConfig appConfig = TestConfig();
    MockTaskDataLayer mockTaskDataLayer = MockTaskDataLayer();

    tearDown(() => {
          serviceLocator.unregister<http.Client>(),
        });

    test('getAllTasks returns success 200', () async {
      var desiredResponseMap =
          mockTaskDataLayer.getAllTasks().map((task) => task.toJson()).toList();

      String desiredResponseJson = json.encode(desiredResponseMap);

      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.get200Client(desiredResponseJson));

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.getAllTasks();

      expect(res.success, true);
    });

    test('getTaskById returns success 200', () async {
      var desiredResponseMap = mockTaskDataLayer.getTaskById(1)!.toJson();

      String desiredResponseJson = json.encode(desiredResponseMap);

      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.get200Client(desiredResponseJson));

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.getTaskById(1);

      expect(res.success, true);
    });

    test('getTaskDetails returns success 200', () async {
      Task task1 = mockTaskDataLayer.getTaskById(1)!;
      List<Task> subTasks = mockTaskDataLayer
          .getAllTasks()
          .where((task) => task.parentId == 1)
          .toList();
      List<Task> pathEnumeration = [
        mockTaskDataLayer.getTaskById(task1.parentId!)!
      ];

      Map<String, dynamic> desiredResponseMap = {
        'currentTask': task1,
        'subTasks': subTasks,
        'pathEnumeration': pathEnumeration,
      };

      String desiredResponseJson = json.encode(desiredResponseMap);

      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.get200Client(desiredResponseJson));

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.getTaskDetails(1);

      expect(res.success, true);
    });

    test('getRootTask returns success 200', () async {
      var desiredResponseMap = mockTaskDataLayer.getTaskById(0)!.toJson();

      String desiredResponseJson = json.encode(desiredResponseMap);

      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.get200Client(desiredResponseJson));

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.getRootTask();

      expect(res.success, true);
    });

    test('createTask returns success 201', () async {
      Task taskToCreate = mockTaskDataLayer.getTaskById(1)!;

      var desiredResponseMap = taskToCreate.toJson();
      String desiredResponseJson = json.encode(desiredResponseMap);

      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.get201Client(desiredResponseJson));

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.createTask(taskToCreate);

      expect(res.success, true);
    });

    test('updateTask returns success 204', () async {
      Task taskToUpdate = mockTaskDataLayer.getTaskById(1)!;

      serviceLocator
          .registerSingleton<http.Client>(MockClientFactory.get204Client());

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.updateTask(taskToUpdate);

      expect(res.success, true);
    });

    test('deleteTask returns success 204', () async {
      int taskToDeleteId = 1;

      serviceLocator
          .registerSingleton<http.Client>(MockClientFactory.get204Client());

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.deleteTask(taskToDeleteId);

      expect(res.success, true);
    });
  });

  group('TaskService Unit Tests - Invalid Json Returns', () {
    AppConfig appConfig = TestConfig();
    MockTaskDataLayer mockTaskDataLayer = MockTaskDataLayer();

    tearDown(() => {
          serviceLocator.unregister<http.Client>(),
        });

    test('getAllTasks returns NO-success 200 - invalid response format',
        () async {
      String invalidResponseJson = json.encode("123#abc");

      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.get200Client(invalidResponseJson));

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.getAllTasks();

      expect(res.success, false);
    });

    test('getTaskById returns NO-success 200 - invalid response format',
        () async {
      String invalidResponseJson = json.encode("123#abc");

      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.get200Client(invalidResponseJson));

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.getTaskById(1);

      expect(res.success, false);
    });

    test('getTaskDetails returns NO-success 200 - invalid response format',
        () async {
      String invalidResponseJson = json.encode("123#abc");

      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.get200Client(invalidResponseJson));

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.getTaskDetails(1);

      expect(res.success, false);
    });

    test('getRootTask returns NO-success 200 - invalid response format',
        () async {
      String invalidResponseJson = json.encode("123#abc");

      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.get200Client(invalidResponseJson));

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.getRootTask();

      expect(res.success, false);
    });

    test('createTask returns NO-success 201 - invalid response format',
        () async {
      Task taskToCreate = mockTaskDataLayer.getTaskById(1)!;

      String invalidResponseJson = json.encode("123#abc");

      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.get201Client(invalidResponseJson));

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.createTask(taskToCreate);

      expect(res.success, false);
    });
  });

  group('TaskService Unit Tests - Http Client Exceptions and Errors', () {
    AppConfig appConfig = TestConfig();

    MockTaskDataLayer mockTaskDataLayer = MockTaskDataLayer();

    tearDown(() => {
          serviceLocator.unregister<http.Client>(),
        });

    test('handles 404 response', () async {
      serviceLocator
          .registerSingleton<http.Client>(MockClientFactory.get404Client());

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.getAllTasks();
      expect(res.success, false);

      res = await taskService.getTaskById(1);
      expect(res.success, false);

      res = await taskService.getTaskDetails(1);
      expect(res.success, false);

      res = await taskService.getRootTask();
      expect(res.success, false);

      res = await taskService.createTask(mockTaskDataLayer.getTaskById(1)!);
      expect(res.success, false);

      res = await taskService.updateTask(mockTaskDataLayer.getTaskById(1)!);
      expect(res.success, false);

      res = await taskService.deleteTask(1);
      expect(res.success, false);
    });

    test('handles SocketException', () async {
      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.getSocketExceptionClient());

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.getAllTasks();
      expect(res.success, false);

      res = await taskService.getTaskById(1);
      expect(res.success, false);

      res = await taskService.getTaskDetails(1);
      expect(res.success, false);

      res = await taskService.getRootTask();
      expect(res.success, false);

      res = await taskService.createTask(mockTaskDataLayer.getTaskById(1)!);
      expect(res.success, false);

      res = await taskService.updateTask(mockTaskDataLayer.getTaskById(1)!);
      expect(res.success, false);

      res = await taskService.deleteTask(1);
      expect(res.success, false);
    });

    test('handles TimeoutException', () async {
      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.getTimeoutExceptionClient());

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.getAllTasks();
      expect(res.success, false);

      res = await taskService.getTaskById(1);
      expect(res.success, false);

      res = await taskService.getTaskDetails(1);
      expect(res.success, false);

      res = await taskService.getRootTask();
      expect(res.success, false);

      res = await taskService.createTask(mockTaskDataLayer.getTaskById(1)!);
      expect(res.success, false);

      res = await taskService.updateTask(mockTaskDataLayer.getTaskById(1)!);
      expect(res.success, false);

      res = await taskService.deleteTask(1);
      expect(res.success, false);
    });

    test('handles HttpException', () async {
      serviceLocator.registerSingleton<http.Client>(
          MockClientFactory.getHttpExceptionClient());

      TaskService taskService = TaskService(baseApiUrl: appConfig.baseApiUrl);

      TaskServiceResult res = await taskService.getAllTasks();
      expect(res.success, false);

      res = await taskService.getTaskById(1);
      expect(res.success, false);

      res = await taskService.getTaskDetails(1);
      expect(res.success, false);

      res = await taskService.getRootTask();
      expect(res.success, false);

      res = await taskService.createTask(mockTaskDataLayer.getTaskById(1)!);
      expect(res.success, false);

      res = await taskService.updateTask(mockTaskDataLayer.getTaskById(1)!);
      expect(res.success, false);

      res = await taskService.deleteTask(1);
      expect(res.success, false);
    });
  });
}
