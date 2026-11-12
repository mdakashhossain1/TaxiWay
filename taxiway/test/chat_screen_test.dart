import 'dart:async';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxiway/core/api/network_failure.dart';
import 'package:taxiway/core/data/chat_repository.dart';
import 'package:taxiway/core/models/chat_message.dart';
import 'package:taxiway/core/providers.dart';
import 'package:taxiway/core/theme/app_theme.dart';
import 'package:taxiway/core/widgets/app_shimmer.dart';
import 'package:taxiway/core/widgets/empty_state.dart';
import 'package:taxiway/core/widgets/inline_retry.dart';
import 'package:taxiway/core/widgets/network_error_view.dart';
import 'package:taxiway/features/chat/presentation/screens/chat_screen.dart';
import 'package:taxiway/l10n/generated/app_localizations.dart';
import 'package:toastification/toastification.dart';

class _FakeChat extends ChatRepository {
  bool failSignIn = true;
  bool failSend = false;
  int signInCalls = 0;
  int sendCalls = 0;
  final messages = StreamController<List<ChatMessage>>.broadcast();

  @override
  Future<String> ensureSignedIn() async {
    signInCalls++;
    if (failSignIn) throw const NetworkFailure(NetworkFailureKind.offline);
    return 'support';
  }

  @override
  Stream<List<ChatMessage>> streamMessages(String conversationId) => messages.stream;

  @override
  Future<void> sendMessage(String conversationId, String text) async {
    sendCalls++;
    if (failSend) throw const NetworkFailure(NetworkFailureKind.timeout);
  }

  @override
  String? get myUid => 'me';
}

Future<void> _pumpChat(WidgetTester tester, _FakeChat chat) async {
  tester.view.physicalSize = const Size(360, 740);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [chatRepositoryProvider.overrideWithValue(chat)],
      child: ToastificationWrapper(
        child: MaterialApp(
          theme: AppTheme.light,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const ChatScreen(title: 'Support'),
        ),
      ),
    ),
  );
}

Future<void> teardown(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 4));
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('chat: skeleton, offline error with retry, empty state, failed send keeps the text', (tester) async {
    final chat = _FakeChat();
    addTearDown(chat.messages.close);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await _pumpChat(tester, chat);
    expect(find.byType(ChatShimmer), findsOneWidget, reason: 'skeleton while signing in');

    await tester.pump(const Duration(milliseconds: 800));
    expect(find.byType(NetworkErrorView), findsOneWidget);
    expect(find.text(l10n.errorOfflineTitle), findsOneWidget);

    chat.failSignIn = false;
    await tester.tap(find.text(l10n.tryAgainLabel));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 800));
    expect(chat.signInCalls, 2, reason: 'retry signs in again instead of reusing the failure');
    expect(find.byType(ChatShimmer), findsOneWidget, reason: 'skeleton while the first snapshot loads');

    chat.messages.add(const []);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text(l10n.chatEmptyTitle), findsOneWidget);

    chat.failSend = true;
    await tester.enterText(find.byType(TextField), 'hello driver');
    await tester.tap(find.byIcon(BootstrapIcons.send_fill));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(seconds: 1));
    expect(chat.sendCalls, 1);
    expect(find.widgetWithText(TextField, 'hello driver'), findsOneWidget, reason: 'unsent text is put back');
    expect(find.text(l10n.errorTimeoutTitle), findsOneWidget, reason: 'the toast explains the timeout');

    await teardown(tester);
  });

  testWidgets('chat: a stream failure with nothing loaded offers a retry, not "say hello"', (tester) async {
    final chat = _FakeChat()..failSignIn = false;
    addTearDown(chat.messages.close);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await _pumpChat(tester, chat);
    await tester.pump(const Duration(milliseconds: 500));
    chat.messages.addError(StateError('permission-denied'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(InlineRetry), findsOneWidget);
    expect(find.text(l10n.chatLoadFailed), findsOneWidget);
    expect(find.text(l10n.chatEmptyTitle), findsNothing);

    await teardown(tester);
  });
}
