import 'dart:async';

import 'package:flovoo_chat_app_task/features/chat/data/models/conversation_model.dart';
import 'package:flovoo_chat_app_task/features/chat/data/models/message_model.dart';

abstract class ChatDataSource {
  Future<List<ConversationModel>> getConversations();

  Future<List<MessageModel>> getMessages(String conversationId);

  Future<void> sendMessage(MessageModel message);

  Stream<MessageModel> incomingMessages();

  Stream<ConversationModel> conversationUpdates();

  Future<void> setActiveConversation(String? conversationId);
}

final class MockChatDataSource implements ChatDataSource {
  final List<ConversationModel> _conversations = [];
  final List<MessageModel> _messages = [];
  final _messageController = StreamController<MessageModel>.broadcast();
  final _conversationController =
      StreamController<ConversationModel>.broadcast();

  String? _activeConversationId;

  MockChatDataSource() {
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();

    // Conversations
    _conversations.addAll([
      ConversationModel(
        id: '1',
        contactName: 'Ahmed Hassan',
        lastMessage: 'See you tomorrow!',
        lastMessageTime: now.subtract(const Duration(minutes: 5)),
        unreadCount: 2,
      ),
      ConversationModel(
        id: '2',
        contactName: 'Sara Mohamed',
        lastMessage: 'Thanks for the update 👍',
        lastMessageTime: now.subtract(const Duration(hours: 1)),
        unreadCount: 0,
      ),
      ConversationModel(
        id: '3',
        contactName: 'Omar Ali',
        lastMessage: 'Can you send the files?',
        lastMessageTime: now.subtract(const Duration(hours: 3)),
        unreadCount: 5,
      ),
      ConversationModel(
        id: '4',
        contactName: 'Nour Ibrahim',
        lastMessage: 'Great work on the project!',
        lastMessageTime: now.subtract(const Duration(days: 1)),
        unreadCount: 1,
      ),
    ]);

    // Messages for conversation 1 (Ahmed Hassan)
    _messages.addAll([
      MessageModel(
        id: 'm1_1',
        conversationId: '1',
        text: 'Hey! How are you doing?',
        isMe: false,
        timestamp: now.subtract(const Duration(minutes: 30)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm1_2',
        conversationId: '1',
        text: 'I\'m doing great, thanks for asking!',
        isMe: true,
        timestamp: now.subtract(const Duration(minutes: 28)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm1_3',
        conversationId: '1',
        text: 'Are we still meeting tomorrow?',
        isMe: false,
        timestamp: now.subtract(const Duration(minutes: 15)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm1_4',
        conversationId: '1',
        text: 'Yes, at 10 AM. I\'ll be there.',
        isMe: true,
        timestamp: now.subtract(const Duration(minutes: 10)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm1_5',
        conversationId: '1',
        text: 'See you tomorrow!',
        isMe: false,
        timestamp: now.subtract(const Duration(minutes: 5)),
        status: MessageStatusModel.delivered,
      ),
    ]);

    // Messages for conversation 2 (Sara Mohamed)
    _messages.addAll([
      MessageModel(
        id: 'm2_1',
        conversationId: '2',
        text: 'Hi Sara, I just pushed the latest changes.',
        isMe: true,
        timestamp: now.subtract(const Duration(hours: 2)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm2_2',
        conversationId: '2',
        text: 'Let me check them out.',
        isMe: false,
        timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm2_3',
        conversationId: '2',
        text: 'Everything looks good! The new feature works well.',
        isMe: false,
        timestamp: now.subtract(const Duration(hours: 1, minutes: 30)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm2_4',
        conversationId: '2',
        text: 'Awesome! Glad it works.',
        isMe: true,
        timestamp: now.subtract(const Duration(hours: 1, minutes: 15)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm2_5',
        conversationId: '2',
        text: 'Thanks for the update 👍',
        isMe: false,
        timestamp: now.subtract(const Duration(hours: 1)),
        status: MessageStatusModel.delivered,
      ),
    ]);

    // Messages for conversation 3 (Omar Ali)
    _messages.addAll([
      MessageModel(
        id: 'm3_1',
        conversationId: '3',
        text: 'Hey Omar, how\'s the project going?',
        isMe: true,
        timestamp: now.subtract(const Duration(hours: 5)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm3_2',
        conversationId: '3',
        text: 'It\'s going well! Almost done with the backend.',
        isMe: false,
        timestamp: now.subtract(const Duration(hours: 4, minutes: 30)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm3_3',
        conversationId: '3',
        text: 'That\'s great news!',
        isMe: true,
        timestamp: now.subtract(const Duration(hours: 4)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm3_4',
        conversationId: '3',
        text: 'Can you send the files?',
        isMe: false,
        timestamp: now.subtract(const Duration(hours: 3)),
        status: MessageStatusModel.delivered,
      ),
    ]);

    // Messages for conversation 4 (Nour Ibrahim)
    _messages.addAll([
      MessageModel(
        id: 'm4_1',
        conversationId: '4',
        text: 'Hi Nour! Just wanted to say the presentation was amazing.',
        isMe: true,
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm4_2',
        conversationId: '4',
        text: 'Thank you so much! 😊',
        isMe: false,
        timestamp: now.subtract(const Duration(days: 1, hours: 1)),
        status: MessageStatusModel.delivered,
      ),
      MessageModel(
        id: 'm4_3',
        conversationId: '4',
        text: 'Great work on the project!',
        isMe: false,
        timestamp: now.subtract(const Duration(days: 1)),
        status: MessageStatusModel.delivered,
      ),
    ]);
  }

  @override
  Future<List<ConversationModel>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Return sorted by latest message first
    final sorted = List<ConversationModel>.from(_conversations)
      ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return sorted;
  }

  @override
  Future<List<MessageModel>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final filtered =
        _messages
            .where((message) => message.conversationId == conversationId)
            .toList()
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return filtered;
  }

  @override
  Stream<MessageModel> incomingMessages() {
    return _messageController.stream;
  }

  @override
  Stream<ConversationModel> conversationUpdates() {
    return _conversationController.stream;
  }

  @override
  Future<void> setActiveConversation(String? conversationId) async {
    _activeConversationId = conversationId;
    if (conversationId != null) {
      _markConversationAsRead(conversationId);
    }
  }

  void _markConversationAsRead(String conversationId) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final existing = _conversations[index];
      if (existing.unreadCount > 0) {
        final updated = ConversationModel(
          id: existing.id,
          contactName: existing.contactName,
          lastMessage: existing.lastMessage,
          lastMessageTime: existing.lastMessageTime,
          unreadCount: 0,
        );
        _conversations[index] = updated;
        _conversationController.add(updated);
      }
    }
  }

  @override
  Future<void> sendMessage(MessageModel message) async {
    // 1. Add message immediately with its initial status (sending)
    _messages.add(message);

    // 2. Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // 3. Update status to sent
    _updateMessageStatus(message.id, MessageStatusModel.sent);

    // Update conversation preview
    _updateConversationPreview(
      conversationId: message.conversationId,
      lastMessage: message.text,
      lastMessageTime: message.timestamp,
      incrementUnread: false,
    );

    // 4. Simulate delivered after 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      _updateMessageStatus(message.id, MessageStatusModel.delivered);
    });

    // Simulate auto-reply after sending
    _simulateReply(message.conversationId);
  }

  void _updateMessageStatus(String messageId, MessageStatusModel status) {
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final existing = _messages[index];
      _messages[index] = existing.copyWith(status: status);
    }
  }

  void _updateConversationPreview({
    required String conversationId,
    required String lastMessage,
    required DateTime lastMessageTime,
    required bool incrementUnread,
  }) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final existing = _conversations[index];
      final updated = ConversationModel(
        id: existing.id,
        contactName: existing.contactName,
        lastMessage: lastMessage,
        lastMessageTime: lastMessageTime,
        unreadCount: incrementUnread ? existing.unreadCount + 1 : 0,
      );
      _conversations[index] = updated;
      _conversationController.add(updated);
    }
  }

  Future<void> _simulateReply(String conversationId) async {
    await Future.delayed(const Duration(seconds: 2));

    final contactName = _conversations
        .firstWhere((c) => c.id == conversationId)
        .contactName;

    final reply = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      text: 'Reply from $contactName 👋',
      isMe: false,
      timestamp: DateTime.now(),
      status: MessageStatusModel.delivered,
    );

    _messages.add(reply);
    _messageController.add(reply);

    // Update conversation preview for the reply
    final isActive = conversationId == _activeConversationId;
    _updateConversationPreview(
      conversationId: conversationId,
      lastMessage: reply.text,
      lastMessageTime: reply.timestamp,
      incrementUnread: !isActive,
    );
  }
}
