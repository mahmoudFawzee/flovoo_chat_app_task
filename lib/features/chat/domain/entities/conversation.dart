final class Conversation {
  final String id;
  final String contactName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  const Conversation({
    required this.id,
    required this.contactName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}
