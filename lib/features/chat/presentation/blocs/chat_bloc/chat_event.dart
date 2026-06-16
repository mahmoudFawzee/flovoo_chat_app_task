import 'package:equatable/equatable.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

final class LoadMessages extends ChatEvent {
  final String conversationId;

  const LoadMessages(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

final class SendMessageRequested extends ChatEvent {
  final String text;
  final String conversationId;

  const SendMessageRequested({
    required this.text,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [text, conversationId];
}

final class MessageReceived extends ChatEvent {
  final Message message;

  const MessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}
