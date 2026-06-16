import 'package:flovoo_chat_app_task/core/router/routes.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/conversations_bloc/conversations_bloc.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/conversations_bloc/conversations_event.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/search_message_cubit/search_message_cubit.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/screens/search_message_screen.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/helpers/search_arguments.dart';
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
        path: Routes.conversations,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              sl<ConversationsBloc>()..add(const LoadConversations()),
          child: const ConversationsScreen(),
        ),
      ),
      GoRoute(
        path: Routes.chat,
        builder: (context, state) {
          final conversationId = state.pathParameters['conversationId']!;
          final args = state.extra as ChatArguments?;
          return BlocProvider(
            create: (_) => sl<ChatBloc>(),
            child: ChatScreen(
              conversationId: args?.conversationId ?? conversationId,
            ),
          );
        },
      ),

      GoRoute(
        path: Routes.searchMessages,
        builder: (context, state) {
          final args = state.extra as SearchArguments?;

          return BlocProvider(
            create: (_) => sl<SearchMessageCubit>(),
            child: SearchMessagesPage(conversationId: args?.conversationId),
          );
        },
      ),
    ],
  );
}
