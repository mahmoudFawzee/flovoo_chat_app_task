import 'package:dartz/dartz.dart';
import 'package:flovoo_chat_app_task/core/errors/exception_wrapper.dart';
import 'package:flovoo_chat_app_task/core/errors/failures.dart';
import 'package:flovoo_chat_app_task/features/chat/data/data_source/chat_data_source.dart';
import 'package:flovoo_chat_app_task/features/chat/data/models/message_model.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/conversation.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/repo/chat_repo.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource dataSource;

  ChatRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Conversation>>> getConversations() =>
      exceptionWrapper(() async {
        final data = await dataSource.getConversations();
        return data.map((item) => item.toEntity()).toList();
      });

  @override
  Future<Either<Failure, List<Message>>> getMessages(String conversationId) =>
      exceptionWrapper(() async {
        final data = await dataSource.getMessages(conversationId);
        return data.map((item) => item.toEntity()).toList();
      });

  @override
  Future<Either<Failure, void>> sendMessage(Message message) =>
      exceptionWrapper(() async {
        return dataSource.sendMessage(MessageModel.fromEntity(message));
      });

  @override
  Either<Failure, Stream<Message>> incomingMessages() => streamExceptionWrapper(
    () => dataSource.incomingMessages().map((item) => item.toEntity()),
  );

  @override
  Either<Failure, Stream<Conversation>> conversationUpdates() =>
      streamExceptionWrapper(
        () => dataSource.conversationUpdates().map((item) => item.toEntity()),
      );

  @override
  Future<Either<Failure, void>> setActiveConversation(String? conversationId) =>
      exceptionWrapper(() async {
        return dataSource.setActiveConversation(conversationId);
      });
}
