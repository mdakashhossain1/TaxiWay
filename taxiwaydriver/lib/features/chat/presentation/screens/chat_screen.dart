import '../../../../core/theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/data/chat_repository.dart';
import '../../../../core/models/chat_message.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/inline_retry.dart';
import '../../../../core/widgets/network_error_view.dart';
import '../../../../l10n/generated/app_localizations.dart';

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
    _openConversation();
  }

  void _openConversation() {
    _readyConversationId = _resolveConversationId();
  }

  void _retryOpen() => setState(_openConversation);

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
    } catch (error) {
      if (!mounted) return;
      if (_controller.text.isEmpty) {
        _controller.value = TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
      }
      AppToast.failure(context, error, fallback: AppLocalizations.of(context).messageSendFailed);
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
            return NetworkErrorView(
              type: networkErrorTypeFor(snapshot.error!),
              isCompact: true,
              onRetry: () async => _retryOpen(),
            );
          }
          if (!snapshot.hasData) {
            return const ChatShimmer();
          }
          final conversationId = snapshot.data!;
          return _MessageList(conversationId: conversationId, onRetry: _retryOpen);
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
  final VoidCallback onRetry;
  const _MessageList({required this.conversationId, required this.onRetry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(chatRepositoryProvider);
    final myUid = repo.myUid;
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<ChatMessage>>(
      stream: repo.streamMessages(conversationId),
      builder: (context, snapshot) {
        final messages = snapshot.data ?? const <ChatMessage>[];
        if (snapshot.hasError && messages.isEmpty) {
          return InlineRetry(message: l10n.chatLoadFailed, onRetry: onRetry);
        }
        if (snapshot.connectionState == ConnectionState.waiting && messages.isEmpty) {
          return const ChatShimmer();
        }
        if (messages.isEmpty) {
          return EmptyState(
            icon: AppIcons.chat_dots,
            title: l10n.chatEmptyTitle,
            message: l10n.chatEmptyMessage,
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
                hintText: AppLocalizations.of(context).typeAMessage,
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
                child: Icon(AppIcons.send_fill, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
