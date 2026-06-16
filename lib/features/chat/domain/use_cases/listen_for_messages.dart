import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/repo/chat_repo.dart';

class ListenForMessages {
  final ChatRepository repository;

  ListenForMessages(this.repository);

  Stream<Message> call() {
    return repository.incomingMessages();
  }
}
