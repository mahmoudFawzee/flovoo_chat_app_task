import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/search_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_message_state.dart';

class SearchMessageCubit extends Cubit<SearchMessageState> {
  final SearchMessages _useCase;
  SearchMessageCubit(this._useCase)
    : super(const SearchMessageState(SearchMessagesStateEnum.initial));
  void _safeEmit(SearchMessageState s) {
    if (!isClosed) emit(s);
  }

  void searchMessages(String query, {String? conversationId}) {
    final foundMessages = _useCase(query, conversationId: conversationId);
    foundMessages.fold(
      (failure) {
        _safeEmit(
          SearchMessageState(
            SearchMessagesStateEnum.error,
            errorMessage: failure.message,
          ),
        );
      },
      (messages) {
        final status = messages.isEmpty
            ? SearchMessagesStateEnum.noMessages
            : SearchMessagesStateEnum.gotMessages;
        _safeEmit(SearchMessageState(status, messagesList: messages));
      },
    );
  }
}
