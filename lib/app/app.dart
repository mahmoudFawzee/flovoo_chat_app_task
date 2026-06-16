import 'package:flutter/material.dart';
import 'package:flovoo_chat_app_task/core/router/app_router.dart';

class FlovooChatApp extends StatelessWidget {
  const FlovooChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flovoo Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
