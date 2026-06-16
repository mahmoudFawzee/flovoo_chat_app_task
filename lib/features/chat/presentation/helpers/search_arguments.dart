enum SearchScope { global, conversation }

class SearchArguments {
  final String? conversationId;

  const SearchArguments({this.conversationId});
}

class ChatArguments {
  final String? conversationId;
  const ChatArguments({this.conversationId});
}
