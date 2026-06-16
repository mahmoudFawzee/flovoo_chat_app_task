import 'package:flovoo_chat_app_task/core/theme/cubit/theme_cubit.dart';
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
    //final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        actions: [
          IconButton(
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
            ConversationsError(:final message) => _ErrorView(
              message: message,
              onRetry: () {
                context.read<ConversationsBloc>().add(
                  const LoadConversations(),
                );
              },
            ),
            ConversationsLoaded(:final conversations) =>
              conversations.isEmpty
                  ? const _EmptyView()
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

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
