import 'package:flovoo_chat_app_task/features/chat/data/data_source/chat_data_source.dart';
import 'package:flovoo_chat_app_task/features/chat/data/repo/chat_repository_impl.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/repo/chat_repo.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void initDependencies() {
  // Data Sources
  sl.registerLazySingleton<ChatDataSource>(() => MockChatDataSource());

  // Repository
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
}
