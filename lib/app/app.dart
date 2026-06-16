import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flovoo_chat_app_task/core/di/injection.dart';
import 'package:flovoo_chat_app_task/core/router/app_router.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/conversations_bloc/conversations_bloc.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/conversations_bloc/conversations_event.dart';

class FlovooChatApp extends StatelessWidget {
  const FlovooChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ConversationsBloc>()..add(const LoadConversations()),
      child: MaterialApp.router(
        title: 'Flovoo Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
