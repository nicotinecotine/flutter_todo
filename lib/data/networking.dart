import 'package:dio/dio.dart';
import 'package:flutter_todo/models/task_model.dart';

const String baseUrl = 'https://beta.mrdekk.ru/todobackend';
const String token = '';
int revision = 0;
Dio dioInstance = Dio();

Future<List<Task>> getTasksList() async {
  dioInstance.options.headers['Authorization'] = "Bearer $token";
  return ([]);
}

Future<void> updateTasksList() async {
  dioInstance.options.headers['Authorization'] = "Bearer $token";
  return Future.delayed(
    const Duration(
      seconds: 1,
    ),
  );
}