import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whispr_chat_application/Controller/auth_controller.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxMap<String, List<Map<String, dynamic>>> _messages =
      <String, List<Map<String, dynamic>>>{}.obs;
  final RxString _currentChatId = ''.obs;
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();

  // Getters
  List<Map<String, dynamic>> get messages =>
      _messages[_currentChatId.value] ?? [];
  String get currentChatId => _currentChatId.value;

  // Initialize chat with a user
  void initializeChat(String currentUserId, String otherUserId) {
    _currentChatId.value = _generateChatId(currentUserId, otherUserId);
    _listenToMessages();
  }

  String _generateChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1-$userId2'
        : '$userId2-$userId1';
  }

  void _listenToMessages() {
    _firestore
        .collection('chats')
        .doc(_currentChatId.value)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _messages[_currentChatId.value] = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'text': data['text'],
          'senderId': data['senderId'],
          'timestamp': data['timestamp'],
          'isRead': data['isRead'] ?? false,
        };
      }).toList();
      update();
    });
  }

  Future<void> sendMessage(String senderId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    try {
      await _firestore
          .collection('chats')
          .doc(_currentChatId.value)
          .collection('messages')
          .add({
        'text': text,
        'senderId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
      messageController.clear();
      messageFocusNode.requestFocus();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    messageFocusNode.dispose();
    super.onClose();
  }

  String getLastMessage(String chatId) {
    if (_messages[chatId] == null || _messages[chatId]!.isEmpty) {
      return "No messages yet";
    }
    return _messages[chatId]!.first['text'] ?? "";
  }

  int getUnreadMessageCount(String otherUserId) {
    final currentUserId = Get.find<AuthController>().currentUserId.value;
    if (currentUserId == null) return 0;

    final chatId = _generateChatId(currentUserId, otherUserId);
    if (_messages[chatId] == null) return 0;

    return _messages[chatId]!
        .where(
            (msg) => msg['senderId'] != currentUserId && msg['isRead'] == false)
        .length;
  }

  String getLastMessageTime(String chatId) {
    if (_messages[chatId] == null || _messages[chatId]!.isEmpty) {
      return "";
    }
    final timestamp = _messages[chatId]!.first['timestamp'];
    if (timestamp is Timestamp) {
      return _formatMessageTime(timestamp.toDate());
    }
    return "";
  }

  String _formatMessageTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.isAfter(today)) {
      return DateFormat('HH:mm').format(date); // Today - show time only
    } else if (date.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d').format(date); // Older - show date
    }
  }

  Future<void> markMessagesAsRead(String chatId, String currentUserId) async {
    final unreadMessages = _messages[chatId]!
        .where(
            (msg) => msg['senderId'] != currentUserId && msg['isRead'] == false)
        .toList();

    final batch = _firestore.batch();
    for (var msg in unreadMessages) {
      final docRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(msg['id']);
      batch.update(docRef, {'isRead': true});
    }

    if (unreadMessages.isNotEmpty) {
      await batch.commit();
    }
  }
}
