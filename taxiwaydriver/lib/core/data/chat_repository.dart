import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../models/chat_message.dart';

abstract class ChatRepository {
  /// Ride conversation ID is deterministic and known by both client and
  /// server as soon as a booking exists — no round-trip needed to compute it.
  String rideConversationId(String bookingId) => 'ride_$bookingId';

  /// Signs in to Firebase with a backend-minted custom token so Firestore's
  /// `request.auth.uid` checks pass, and returns the support conversation ID
  /// the backend created/ensured for this account. Safe to call repeatedly —
  /// only round-trips once per app session.
  Future<String> ensureSignedIn();

  Stream<List<ChatMessage>> streamMessages(String conversationId);

  Future<void> sendMessage(String conversationId, String text);

  String? get myUid;
}

class FirebaseChatRepositoryImpl extends ChatRepository {
  String? _uid;
  String? _supportConversationId;
  Future<String>? _signInFuture;

  // Firestore's .snapshots() opens a new underlying listener on every call —
  // caching by conversationId keeps the Stream identity stable across
  // rebuilds of anything that calls streamMessages() from inside build(),
  // so StreamBuilder doesn't tear down and re-subscribe on every rebuild.
  final Map<String, Stream<List<ChatMessage>>> _messageStreams = {};

  @override
  String? get myUid => _uid;

  @override
  Future<String> ensureSignedIn() {
    return _signInFuture ??= _signIn();
  }

  Future<String> _signIn() async {
    final response = await ApiClient.instance.post('/driver/chat-token');
    final data = response['data'] as Map<String, dynamic>;
    _uid = data['uid'] as String;
    _supportConversationId = data['support_conversation_id'] as String;
    await FirebaseAuth.instance.signInWithCustomToken(data['token'] as String);
    return _supportConversationId!;
  }

  @override
  Stream<List<ChatMessage>> streamMessages(String conversationId) {
    return _messageStreams.putIfAbsent(
      conversationId,
      () => FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('createdAt')
          .snapshots()
          .map((snap) => snap.docs.map(_toMessage).toList())
          .asBroadcastStream(),
    );
  }

  ChatMessage _toMessage(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'] as String? ?? '',
      text: data['text'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  @override
  Future<void> sendMessage(String conversationId, String text) async {
    await ensureSignedIn();
    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add({
      'senderId': _uid,
      'text': text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) => FirebaseChatRepositoryImpl());
