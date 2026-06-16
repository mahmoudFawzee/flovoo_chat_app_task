// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  text: json['text'] as String,
  isMe: json['isMe'] as bool,
  timestamp: DateTime.parse(json['timestamp'] as String),
  status: $enumDecode(_$MessageStatusModelEnumMap, json['status']),
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'text': instance.text,
      'isMe': instance.isMe,
      'timestamp': instance.timestamp.toIso8601String(),
      'status': _$MessageStatusModelEnumMap[instance.status]!,
    };

const _$MessageStatusModelEnumMap = {
  MessageStatusModel.sending: 'sending',
  MessageStatusModel.sent: 'sent',
  MessageStatusModel.delivered: 'delivered',
  MessageStatusModel.read: 'read',
};
