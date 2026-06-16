import 'package:flovoo_chat_app_task/core/router/routes.dart';
import 'package:flovoo_chat_app_task/core/theme/cubit/theme_cubit.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/helpers/search_arguments.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/widget/app_bar_icon_button.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/widget/conversation_error_view.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/widget/conversations_empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/conversations_bloc/conversations_bloc.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/conversations_bloc/conversations_event.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/conversations_bloc/conversations_state.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/widget/conversation_tile.dart';
import 'package:go_router/go_router.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});
  static const pageRoute = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        actions: [
          AppBarIconButton(
            onPressed: () async {
              final message = await context.push<Message>(
                Routes.searchMessages,
              );
              if (message != null && context.mounted) {
                context.push(
                  Routes.chat,
                  extra: ChatArguments(conversationId: message.conversationId),
                );
              }
            },
            icon: const Icon(Icons.search),
          ),
          AppBarIconButton(
            onPressed: () => context.read<ThemeCubit>().toggleTheme(context),
            icon: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                return Icon(
                  state == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                  color: state == ThemeMode.dark ? Colors.white : Colors.black,
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<ConversationsBloc, ConversationsState>(
        builder: (context, state) {
          return switch (state) {
            ConversationsInitial() || ConversationsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ConversationsError(:final message) => ErrorView(
              message: message,
              onRetry: () {
                context.read<ConversationsBloc>().add(
                  const LoadConversations(),
                );
              },
            ),
            ConversationsLoaded(:final conversations) =>
              conversations.isEmpty
                  ? const EmptyView()
                  : RefreshIndicator(
                      onRefresh: () async {
                        context.read<ConversationsBloc>().add(
                          const RefreshConversations(),
                        );
                      },
                      child: ListView.separated(
                        itemCount: conversations.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1, indent: 72),
                        itemBuilder: (context, index) {
                          final conversation = conversations[index];
                          return ConversationTile(
                            conversation: conversation,
                            onTap: () {
                              context.push('/chat/${conversation.id}');
                            },
                          );
                        },
                      ),
                    ),
          };
        },
      ),
    );
  }
}
