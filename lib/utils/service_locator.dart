import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

//utils/service_locator.dart
// This is the global ServiceLocator
GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());
}
