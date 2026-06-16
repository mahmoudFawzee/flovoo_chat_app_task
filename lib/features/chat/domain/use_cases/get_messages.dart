import 'package:dartz/dartz.dart';
import 'package:flovoo_chat_app_task/core/errors/failures.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/repo/chat_repo.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Future<Either<Failure, List<Message>>> call(String conversationId) {
    return repository.getMessages(conversationId);
  }
}
