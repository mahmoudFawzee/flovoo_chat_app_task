import 'package:equatable/equatable.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/conversation.dart';

sealed class ConversationsState extends Equatable {
  const ConversationsState();

  @override
  List<Object?> get props => [];
}

final class ConversationsInitial extends ConversationsState {
  const ConversationsInitial();
}

final class ConversationsLoading extends ConversationsState {
  const ConversationsLoading();
}

final class ConversationsLoaded extends ConversationsState {
  final List<Conversation> conversations;

  const ConversationsLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

final class ConversationsError extends ConversationsState {
  final String message;

  const ConversationsError(this.message);

  @override
  List<Object?> get props => [message];
}
