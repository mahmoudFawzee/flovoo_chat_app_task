import 'package:flovoo_chat_app_task/features/chat/presentation/blocs/search_message_cubit/search_message_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchMessagesPage extends StatefulWidget {
  static const pageRoute = '/search-messages';
  const SearchMessagesPage({super.key, this.conversationId});

  final String? conversationId;

  @override
  State<SearchMessagesPage> createState() => _SearchMessagesPageState();
}

class _SearchMessagesPageState extends State<SearchMessagesPage> {
  final TextEditingController _controller = TextEditingController();

  void _search(String query) {
    context.read<SearchMessageCubit>().searchMessages(
      query,
      conversationId: widget.conversationId,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Messages')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _search,
              decoration: const InputDecoration(
                hintText: 'Search messages...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<SearchMessageCubit, SearchMessageState>(
              builder: (context, state) {
                switch (state.state) {
                  case SearchMessagesStateEnum.loading:
                    return const Center(child: CircularProgressIndicator());
                  case SearchMessagesStateEnum.initial:
                    return const Center(child: Text('Start typing to search'));

                  case SearchMessagesStateEnum.noMessages:
                    return const Center(child: Text('No messages found'));

                  case SearchMessagesStateEnum.error:
                    return Center(
                      child: Text(state.errorMessage ?? 'Something went wrong'),
                    );

                  case SearchMessagesStateEnum.gotMessages:
                    final messages = state.messagesList ?? [];

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];

                        return ListTile(
                          title: Text(
                            message.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(message.timestamp.toString()),
                          onTap: () {
                            context.pop(message);
                          },
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
