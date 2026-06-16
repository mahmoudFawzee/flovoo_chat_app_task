part of 'search_message_cubit.dart';

final class SearchMessageState extends Equatable {
  final SearchMessagesStateEnum state;
  final List<Message>? messagesList;
  final String? errorMessage;
  const SearchMessageState(this.state, {this.messagesList,this.errorMessage});

  @override
  List<Object?> get props => [state, messagesList];
}

enum SearchMessagesStateEnum { gotMessages, error, noMessages, initial }
