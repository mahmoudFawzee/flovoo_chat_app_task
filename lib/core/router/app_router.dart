import 'package:flovoo_chat_app_task/features/chat/presentation/screens/chat_screen.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/screens/conversations_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: ConversationsScreen.pageRoute,
    routes: [
      GoRoute(
        path: ConversationsScreen.pageRoute,
        builder: (context, state) => ConversationsScreen(),
      ),
      GoRoute(
        path: ChatScreen.pageRoute,
        builder: (context, state) => ChatScreen(),
      ),
    ],
  );
}
