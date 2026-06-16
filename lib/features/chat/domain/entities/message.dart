import 'package:equatable/equatable.dart';

 class Message extends Equatable {
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

  Message copyWith({
    String? id,
    String? conversationId,
    String? text,
    bool? isMe,
    DateTime? timestamp,
    MessageStatus? status,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, conversationId, text, isMe, timestamp, status];
}

enum MessageStatus { sending, sent, delivered, failed }
