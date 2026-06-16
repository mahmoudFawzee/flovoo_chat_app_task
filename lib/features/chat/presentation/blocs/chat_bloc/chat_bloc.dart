import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/get_messages.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/listen_for_messages.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/send_message.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/use_cases/set_active_conversation.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/chat_bloc/chat_event.dart';
import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/chat_bloc/chat_state.dart';
import 'package:uuid/uuid.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final ListenForMessages listenForMessages;
  final SetActiveConversation setActiveConversation;

  StreamSubscription<Message>? _messageSubscription;
  String? _currentConversationId;

  ChatBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.listenForMessages,
    required this.setActiveConversation,
  }) : super(const ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessageRequested>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
  }

  void _subscribeToIncomingMessages() {
    _messageSubscription?.cancel();
    final result = listenForMessages();
    result.fold(
      (_) {}, // Silently handle failure
      (stream) {
        _messageSubscription = stream.listen(
          (message) => add(MessageReceived(message)),
          onError: (_) {}, // Stream errors don't crash the bloc
        );
      },
    );
  }

  Future<void> _onMessageReceived(
    MessageReceived event,
    Emitter<ChatState> emit,
  ) async {
    // Only process messages for the current conversation
    if (event.message.conversationId != _currentConversationId) return;

    final currentState = state;
    if (currentState is! ChatLoaded) return;

    // Avoid duplicate messages
    final exists = currentState.messages.any((m) => m.id == event.message.id);
    if (exists) return;

    final updatedMessages = List<Message>.from(currentState.messages)
      ..add(event.message);

    if (emit.isDone) return;
    emit(ChatLoaded(updatedMessages));
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    _currentConversationId = event.conversationId;
    await setActiveConversation(event.conversationId);

    if (emit.isDone) return;
    emit(const ChatLoading());

    final result = await getMessages(event.conversationId);
    if (emit.isDone) return;

    result.fold((failure) => emit(ChatError(failure.message)), (messages) {
      emit(ChatLoaded(messages));
      // Subscribe to incoming messages after initial load
      _subscribeToIncomingMessages();
    });
  }

  Future<void> _onSendMessage(
    SendMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatLoaded) return;

    // Step 1: Create local message with status = sending
    final localMessage = Message(
      id: const Uuid().v4(),
      conversationId: event.conversationId,
      text: event.text,
      isMe: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    // Step 2: Optimistically add to UI immediately
    final messagesWithPending = List<Message>.from(currentState.messages)
      ..add(localMessage);

    if (emit.isDone) return;
    emit(ChatLoaded(messagesWithPending));

    // Step 3: Call repository
    final result = await sendMessage(localMessage);

    await result.fold(
      // Step 7: Handle failure
      (failure) async {
        if (emit.isDone) return;
        _updateMessageStatus(localMessage.id, MessageStatus.failed, emit);
      },
      // Step 5: Update to sent
      (_) async {
        if (emit.isDone) return;
        _updateMessageStatus(localMessage.id, MessageStatus.sent, emit);

        // Step 6: Simulate delivered after a short delay
        await Future.delayed(const Duration(milliseconds: 500));

        if (emit.isDone) return;
        _updateMessageStatus(localMessage.id, MessageStatus.delivered, emit);
      },
    );
  }

  void _updateMessageStatus(
    String messageId,
    MessageStatus newStatus,
    Emitter<ChatState> emit,
  ) {
    if (emit.isDone) return;

    final currentState = state;
    if (currentState is! ChatLoaded) return;

    final updatedMessages = currentState.messages.map((message) {
      if (message.id == messageId) {
        return message.copyWith(status: newStatus);
      }
      return message;
    }).toList();

    emit(ChatLoaded(updatedMessages));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    setActiveConversation(null);
    return super.close();
  }
}
