import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/conversation.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/get_conversations.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/listen_for_conversation_updates.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/conversations_bloc/conversations_event.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/conversations_bloc/conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final GetConversations getConversations;
  final ListenForConversationUpdates listenForConversationUpdates;

  StreamSubscription<Conversation>? _updatesSubscription;

  ConversationsBloc({
    required this.getConversations,
    required this.listenForConversationUpdates,
  }) : super(const ConversationsInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<RefreshConversations>(_onRefreshConversations);
    on<ConversationUpdated>(_onConversationUpdated);

    _subscribeToUpdates();
  }

  void _subscribeToUpdates() {
    final result = listenForConversationUpdates();
    result.fold(
      (_) {}, // Silently handle failure — conversations still load via fetch
      (stream) {
        _updatesSubscription = stream.listen(
          (conversation) => add(ConversationUpdated(conversation)),
          onError: (_) {}, // Stream errors don't crash the bloc
        );
      },
    );
  }

  Future<void> _onConversationUpdated(
    ConversationUpdated event,
    Emitter<ConversationsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ConversationsLoaded) return;

    final conversations = List<Conversation>.from(currentState.conversations);
    final index = conversations.indexWhere(
      (c) => c.id == event.conversation.id,
    );

    if (index != -1) {
      conversations[index] = event.conversation;
    } else {
      conversations.insert(0, event.conversation);
    }

    // Re-sort by latest message time
    conversations.sort(
      (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
    );

    if (emit.isDone) return;
    emit(ConversationsLoaded(conversations));
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ConversationsState> emit,
  ) async {
    if (emit.isDone) return;
    emit(const ConversationsLoading());
    await _fetchConversations(emit);
  }

  Future<void> _onRefreshConversations(
    RefreshConversations event,
    Emitter<ConversationsState> emit,
  ) async {
    await _fetchConversations(emit);
  }

  Future<void> _fetchConversations(Emitter<ConversationsState> emit) async {
    final result = await getConversations();

    if (emit.isDone) return;

    result.fold(
      (failure) => emit(ConversationsError(failure.message)),
      (conversations) => emit(ConversationsLoaded(conversations)),
    );
  }

  @override
  Future<void> close() {
    _updatesSubscription?.cancel();
    return super.close();
  }
}
