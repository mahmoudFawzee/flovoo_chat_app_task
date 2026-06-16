final class Message {
  final String id;
  final String conversationId;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageStatus status;
  const Message({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.status,
  });
}

enum MessageStatus { sending, sent, delivered, read }
