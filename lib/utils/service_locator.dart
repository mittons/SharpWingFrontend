import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// This is our global ServiceLocator
GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());
}
