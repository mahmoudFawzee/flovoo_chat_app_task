import 'package:dartz/dartz.dart';
import 'package:flovoo_chat_app_task/core/errors/failures.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/conversation.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Conversation>>> getConversations();

  Future<Either<Failure, List<Message>>> getMessages(String conversationId);

  Future<Either<Failure, void>> sendMessage(Message message);

  Stream<Message> incomingMessages();
}
