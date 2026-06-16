import 'package:flutter/material.dart';
import 'package:flovoo_chat_app_task/features/chat/domain/entities/message.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          left: isMe ? 64 : 12,
          right: isMe ? 12 : 64,
          top: 4,
          bottom: 4,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe
                ? const Radius.circular(16)
                : const Radius.circular(4),
            bottomRight: isMe
                ? const Radius.circular(4)
                : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isMe
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat.jm().format(message.timestamp),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isMe
                        ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  MessageStatusIcon(message),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStatusIcon extends StatelessWidget {
  const MessageStatusIcon(this.message, {super.key});
  final Message message;
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(
      context,
    ).colorScheme.onPrimary.withValues(alpha: 0.7);
    const size = 14.0;

    switch (message.status) {
      case MessageStatus.sending:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(strokeWidth: 1.5, color: color),
        );
      case MessageStatus.sent:
        return Icon(Icons.check, size: size, color: color);
      case MessageStatus.delivered:
        return Icon(Icons.done_all, size: size, color: color);
      case MessageStatus.failed:
        return Icon(
          Icons.error_outline,
          size: size,
          color: Colors.red.shade200,
        );
    }
  }
}
