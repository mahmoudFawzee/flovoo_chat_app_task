import 'package:equatable/equatable.dart';

final class Conversation extends Equatable {
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

  Conversation copyWith({
    String? id,
    String? contactName,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
  }) {
    return Conversation(
      id: id ?? this.id,
      contactName: contactName ?? this.contactName,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [id, contactName, lastMessage, lastMessageTime, unreadCount];
}
