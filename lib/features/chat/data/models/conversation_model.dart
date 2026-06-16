import 'package:flovoo_chat_app_task/features/chat/domain/entities/conversation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation_model.g.dart';

@JsonSerializable()
class ConversationModel {
  final String id;
  final String contactName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  const ConversationModel({
    required this.id,
    required this.contactName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
  Conversation toEntity() => Conversation(
    id: id,
    contactName: contactName,
    lastMessage: lastMessage,
    lastMessageTime: lastMessageTime,
    unreadCount: unreadCount,
  );
}
