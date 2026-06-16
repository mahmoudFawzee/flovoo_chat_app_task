import 'package:flovoo_chat_app_task/core/theme/app_theme.dart';
import 'package:flovoo_chat_app_task/core/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flovoo_chat_app_task/core/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlovooChatApp extends StatelessWidget {
  const FlovooChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Flovoo Chat',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: state,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
