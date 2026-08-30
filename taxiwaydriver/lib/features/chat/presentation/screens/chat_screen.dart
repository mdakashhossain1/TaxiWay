import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/data/chat_repository.dart';
import '../../../../core/models/chat_message.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';

/// Route `extra` payload for [ChatScreen] — a plain value class so
/// `GoRouterState.extra` can be cast to something typed instead of a raw map.
class ChatScreenArgs {
  final String title;
  final String? conversationId;

  const ChatScreenArgs({required this.title, this.conversationId});
}

/// Pass [conversationId] directly for a known thread (e.g. a ride), or leave
/// it null for the support channel — the screen resolves the caller's own
/// support conversation ID after signing in.
class ChatScreen extends ConsumerStatefulWidget {
  final String title;
  final String? conversationId;

  const ChatScreen({super.key, required this.title, this.conversationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  Future<String>? _readyConversationId;

  @override
  void initState() {
    super.initState();
    _readyConversationId = _resolveConversationId();
  }

  Future<String> _resolveConversationId() async {
    final repo = ref.read(chatRepositoryProvider);
    final supportConversationId = await repo.ensureSignedIn();
    return widget.conversationId ?? supportConversationId;
  }

  Future<void> _send(String conversationId) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    try {
      await ref.read(chatRepositoryProvider).sendMessage(conversationId, text);
    } catch (_) {
      if (mounted) {
        AppToast.error(context, "Message didn't send. Please try again.");
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text(widget.title, style: AppTypography.of(context).h2.copyWith(fontSize: 18, color: AppColors.of(context).navy))),
      body: FutureBuilder<String>(
        future: _readyConversationId,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Could not open chat right now.', style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).mutedText)),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final conversationId = snapshot.data!;
          return _MessageList(conversationId: conversationId);
        },
      ),
      bottomBar: FutureBuilder<String>(
        future: _readyConversationId,
        builder: (context, snapshot) {
          final conversationId = snapshot.data;
          return _MessageInputBar(
            controller: _controller,
            enabled: conversationId != null,
            onSend: conversationId == null ? null : () => _send(conversationId),
          );
        },
      ),
    );
  }
}

class _MessageList extends ConsumerWidget {
  final String conversationId;
  const _MessageList({required this.conversationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(chatRepositoryProvider);
    final myUid = repo.myUid;

    return StreamBuilder<List<ChatMessage>>(
      stream: repo.streamMessages(conversationId),
      builder: (context, snapshot) {
        final messages = snapshot.data ?? const <ChatMessage>[];
        if (snapshot.connectionState == ConnectionState.waiting && messages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (messages.isEmpty) {
          return Center(
            child: Text('No messages yet — say hello!', style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).mutedText)),
          );
        }
        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[messages.length - 1 - index];
            return _MessageBubble(message: message, mine: message.senderId == myUid);
          },
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool mine;

  const _MessageBubble({required this.message, required this.mine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: mine ? AppColors.of(context).primary : AppColors.of(context).surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: AppTypography.of(context).body.copyWith(color: mine ? Colors.white : AppColors.of(context).navy),
            ),
            if (message.createdAt != null) ...[
              const SizedBox(height: 4),
              Text(
                DateFormat.jm().format(message.createdAt!),
                style: AppTypography.of(context).caption.copyWith(
                  color: mine ? Colors.white.withValues(alpha: 0.75) : AppColors.of(context).mutedText,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback? onSend;

  const _MessageInputBar({required this.controller, required this.enabled, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.of(context).card,
        border: Border(top: BorderSide(color: AppColors.of(context).border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend?.call(),
              decoration: InputDecoration(
                hintText: 'Type a message…',
                filled: true,
                fillColor: AppColors.of(context).surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.button), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: enabled ? AppColors.of(context).primary : AppColors.of(context).mutedText,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onSend,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(BootstrapIcons.send_fill, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
