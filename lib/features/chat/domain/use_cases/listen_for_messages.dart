import 'package:dartz/dartz.dart';
import 'package:flovoo_chat_app_task/core/errors/failures.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/repo/chat_repo.dart';

class ListenForMessages {
  final ChatRepository repository;

  ListenForMessages(this.repository);

  Either<Failure, Stream<Message>> call() {
    return repository.incomingMessages();
  }
}
