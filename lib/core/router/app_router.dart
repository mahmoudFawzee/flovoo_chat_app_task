import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/conversations_bloc/conversations_bloc.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/conversations_bloc/conversations_event.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/search_message_cubit/search_message_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flovoo_chat_app_task/core/di/injection.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/screens/chat_screen.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/screens/conversations_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: ConversationsScreen.pageRoute,
    routes: [
      GoRoute(
        path: ConversationsScreen.pageRoute,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  sl<ConversationsBloc>()..add(const LoadConversations()),
            ),
            BlocProvider(create: (_) => sl<SearchMessageCubit>()),
          ],
          child: const ConversationsScreen(),
        ),
      ),
      GoRoute(
        path: '/chat/:conversationId',
        builder: (context, state) {
          final conversationId = state.pathParameters['conversationId']!;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<ChatBloc>()),
              BlocProvider(create: (_) => sl<SearchMessageCubit>()),
            ],
            child: ChatScreen(conversationId: conversationId),
          );
        },
      ),
    ],
  );
}
