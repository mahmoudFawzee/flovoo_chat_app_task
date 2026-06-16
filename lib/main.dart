import 'package:flovoo_chat_app_task/app/app.dart';
import 'package:flovoo_chat_app_task/core/di/injection.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initDependencies();
  runApp(const FlovooChatApp());
}
