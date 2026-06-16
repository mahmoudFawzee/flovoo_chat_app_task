import 'package:dartz/dartz.dart';
import 'package:flovoo_chat_app_task/core/errors/failures.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/repo/chat_repo.dart';

class SetActiveConversation {
  final ChatRepository repository;

  SetActiveConversation(this.repository);

  Future<Either<Failure, void>> call(String? conversationId) {
    return repository.setActiveConversation(conversationId);
  }
}
