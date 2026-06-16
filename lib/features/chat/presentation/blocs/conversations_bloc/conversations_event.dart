import 'package:equatable/equatable.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/conversation.dart';

sealed class ConversationsEvent extends Equatable {
  const ConversationsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadConversations extends ConversationsEvent {
  const LoadConversations();
}

final class RefreshConversations extends ConversationsEvent {
  const RefreshConversations();
}

final class ConversationUpdated extends ConversationsEvent {
  final Conversation conversation;

  const ConversationUpdated(this.conversation);

  @override
  List<Object?> get props => [conversation];
}
