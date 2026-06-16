import 'package:dartz/dartz.dart';
import 'package:flovoo_chat_app_task/core/errors/failures.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/conversation.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/repo/chat_repo.dart';

class ListenForConversationUpdates {
  final ChatRepository repository;

  ListenForConversationUpdates(this.repository);

  Either<Failure, Stream<Conversation>> call() {
    return repository.conversationUpdates();
  }
}
