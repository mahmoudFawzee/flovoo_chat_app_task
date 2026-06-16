import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  final String id;
  final String conversationId;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageStatusModel status;
  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
  factory MessageModel.fromEntity(Message message) => MessageModel(
    id: message.id,
    conversationId: message.conversationId,
    text: message.text,
    isMe: message.isMe,
    timestamp: message.timestamp,
    status: _messageStatusFromEntity(message.status),
  );

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
  Message toEntity() => Message(
    id: id,
    conversationId: conversationId,
    text: text,
    isMe: isMe,
    timestamp: timestamp,
    status: status.toEntity,
  );

  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? text,
    bool? isMe,
    DateTime? timestamp,
    MessageStatusModel? status,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}

enum MessageStatusModel { sending, sent, delivered, failed }

extension ToEntity on MessageStatusModel {
  MessageStatus get toEntity {
    switch (this) {
      case MessageStatusModel.delivered:
        return MessageStatus.delivered;
      case MessageStatusModel.sending:
        return MessageStatus.sending;
      case MessageStatusModel.sent:
        return MessageStatus.sent;
      case MessageStatusModel.failed:
        return MessageStatus.failed;
    }
  }
}

MessageStatusModel _messageStatusFromEntity(MessageStatus status) {
  switch (status) {
    case MessageStatus.delivered:
      return MessageStatusModel.delivered;
    case MessageStatus.sending:
      return MessageStatusModel.sending;
    case MessageStatus.sent:
      return MessageStatusModel.sent;
    case MessageStatus.failed:
      return MessageStatusModel.failed;
  }
}
