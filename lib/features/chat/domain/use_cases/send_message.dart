import 'package:dartz/dartz.dart';
import 'package:flovoo_chat_app_task/core/errors/failures.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/repo/chat_repo.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Either<Failure, void>> call(Message message) {
    return repository.sendMessage(message);
  }
}
