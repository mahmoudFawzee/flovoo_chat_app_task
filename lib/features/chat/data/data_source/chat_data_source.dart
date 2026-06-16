import 'dart:async';

import 'package:flovoo_chat_app_task/features/chat/data/models/conversation_model.dart';
import 'package:flovoo_chat_app_task/features/chat/data/models/message_model.dart';

abstract class ChatDataSource {
  Future<List<ConversationModel>> getConversations();

  Future<List<MessageModel>> getMessages(String conversationId);

  Future<void> sendMessage(MessageModel message);

  Stream<MessageModel> incomingMessages();
}

final class MockChatDataSource implements ChatDataSource {
  final List<ConversationModel> _conversations = [];

  final List<MessageModel> _messages = [];
  final _messageController = StreamController<MessageModel>.broadcast();
  MockChatDataSource() {
    _seedData();
  }
  void _seedData() {
    _conversations.add(
      ConversationModel(
        id: '1',
        contactName: 'Ahmed',
        lastMessage: 'Hello',
        lastMessageTime: DateTime.now(),
        unreadCount: 2,
      ),
    );

    _messages.addAll([
      MessageModel(
        id: '1',
        conversationId: '1',
        text: 'Hello',
        isMe: false,
        timestamp: DateTime.now(),
        status: MessageStatusModel.delivered,
      ),
    ]);
  }

  @override
  Future<List<ConversationModel>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _conversations;
  }

  @override
  Future<List<MessageModel>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _messages
        .where((message) => message.conversationId == conversationId)
        .toList();
  }

  @override
  Stream<MessageModel> incomingMessages() {
    return _messageController.stream;
  }

  @override
  Future<void> sendMessage(MessageModel message) async {
    await Future.delayed(const Duration(seconds: 1));

    _messages.add(message);
  }

  Future<void> simulateReply(String conversationId) async {
    await Future.delayed(const Duration(seconds: 2));

    final reply = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      text: 'Auto Reply',
      isMe: false,
      timestamp: DateTime.now(),
      status: MessageStatusModel.delivered,
    );

    _messages.add(reply);

    _messageController.add(reply);
  }
}
