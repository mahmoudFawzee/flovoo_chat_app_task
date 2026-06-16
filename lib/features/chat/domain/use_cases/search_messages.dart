import 'package:dartz/dartz.dart';
import 'package:flovoo_chat_app_task/core/errors/failures.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/repo/chat_repo.dart';

class SearchMessages {
  final ChatRepository repository;

  SearchMessages(this.repository);

  Either<Failure, List<Message>> call(String query, {String? conversationId}) {
    return repository.searchMessage(query, conversationId: conversationId);
  }
}
