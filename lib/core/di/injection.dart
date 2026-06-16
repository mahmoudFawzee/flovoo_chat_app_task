import 'package:flovoo_chat_app_task/features/chat/data/data_source/chat_data_source.dart';
import 'package:flovoo_chat_app_task/features/chat/data/repo/chat_repository_impl.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/repo/chat_repo.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/get_conversations.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/get_messages.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/listen_for_conversation_updates.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/listen_for_messages.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/send_message.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/set_active_conversation.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/conversations_bloc/conversations_bloc.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/search_message_cubit/search_message_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void initDependencies() {
  // ── Data Sources ──
  sl.registerLazySingleton<ChatDataSource>(() => MockChatDataSource());

  // ── Repository ──
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));

  // ── Use Cases ──
  sl.registerLazySingleton(() => GetConversations(sl()));
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SearchMessageCubit(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => ListenForMessages(sl()));
  sl.registerLazySingleton(() => ListenForConversationUpdates(sl()));
  sl.registerLazySingleton(() => SetActiveConversation(sl()));

  // ── Blocs ──
  sl.registerFactory(
    () => ConversationsBloc(
      getConversations: sl(),
      listenForConversationUpdates: sl(),
    ),
  );
  sl.registerFactory(
    () => ChatBloc(
      getMessages: sl(),
      sendMessage: sl(),
      listenForMessages: sl(),
      setActiveConversation: sl(),
    ),
  );
  sl.registerFactory(() => SearchMessageCubit(sl()));
}
