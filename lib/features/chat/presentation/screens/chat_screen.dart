import 'package:flovoo_chat_app_task/core/router/routes.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/helpers/search_arguments.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/widget/app_bar_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/chat_bloc/chat_event.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/chat_bloc/chat_state.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/widget/chat_input.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/widget/message_bubble.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  const ChatScreen({super.key, required this.conversationId});
  static const pageRoute = '/chat/:conversationId';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessages(widget.conversationId));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          AppBarIconButton(
            onPressed: () async {
              final message = await context.push<Message>(
                Routes.searchMessages,
                extra: SearchArguments(conversationId: widget.conversationId),
              );

              if (!mounted || message == null) {
                return;
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          // Message list
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                // Auto-scroll to bottom when messages change
                if (state is ChatLoaded) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                return switch (state) {
                  ChatInitial() || ChatLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  ChatError(:final message) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 56,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(message, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () {
                              context.read<ChatBloc>().add(
                                LoadMessages(widget.conversationId),
                              );
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ChatLoaded(:final messages) =>
                    messages.isEmpty
                        ? Center(
                            child: Text(
                              'No messages yet.\nSay hello! 👋',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: messages.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return MessageBubble(
                                message: messages.reversed.toList()[index],
                              );
                            },
                          ),
                };
              },
            ),
          ),

          // Input area
          ChatInput(
            onSend: (text) {
              context.read<ChatBloc>().add(
                SendMessageRequested(
                  text: text,
                  conversationId: widget.conversationId,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
