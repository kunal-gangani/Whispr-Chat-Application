import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whispr_chat_application/Controller/auth_controller.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find<AuthController>();

  // Reactive variables
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxString currentUserId = ''.obs;
  final RxString currentChatId = ''.obs; // Added currentChatId
  final RxBool isLoading = false.obs;
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    currentUserId.value = _authController.currentUserId.value;
  }

  /// Generate consistent chat ID between two users
  String generateChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort(); // Ensure consistent order
    return ids.join('_');
  }

  /// Initialize chat with another user
  void initializeChat(String otherUserId) {
    currentChatId.value = generateChatId(currentUserId.value, otherUserId);
    _listenToMessages();
  }

  /// Listen for messages in the current chat
  void _listenToMessages() {
    if (currentChatId.value.isEmpty) return;

    _firestore
        .collection('chats')
        .doc(currentChatId.value)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.assignAll(snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'text': data['text'],
          'senderId': data['senderId'],
          'timestamp': data['timestamp'],
          'isRead': data['isRead'] ?? false,
        };
      }).toList());
    }, onError: (error) {
      log("Error listening to messages: $error");
    });
  }

  /// Get the last message for the current chat
  String getLastMessage() {
    if (messages.isEmpty) return "No messages yet";
    return messages.first['text'] ?? "";
  }

  /// Get formatted last message time
  String getLastMessageTime() {
    if (messages.isEmpty) return "";
    final timestamp = messages.first['timestamp'];
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
      return DateFormat('HH:mm').format(date);
    } else if (date.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  /// Get unread message count for the current chat
  int getUnreadMessageCount() {
    return messages
        .where((msg) =>
            msg['senderId'] != currentUserId.value && msg['isRead'] == false)
        .length;
  }

  /// Send a new message
  Future<void> sendMessage(String otherUserId) async {
    final messageText = messageController.text.trim();
    if (messageText.isEmpty) return;
    if (currentUserId.value.isEmpty) {
      Get.snackbar('Error', 'You must be logged in to send messages');
      return;
    }

    isLoading.value = true;
    try {
      // Use currentChatId if available, otherwise generate new one
      final chatId = currentChatId.value.isNotEmpty
          ? currentChatId.value
          : generateChatId(currentUserId.value, otherUserId);

      // Create/update the chat document
      await _firestore.collection('chats').doc(chatId).set({
        'participants': [currentUserId.value, otherUserId],
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSender': currentUserId.value,
        'unreadCount': FieldValue.increment(1),
      }, SetOptions(merge: true));

      // Add the new message
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'text': messageText,
        'senderId': currentUserId.value,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      messageController.clear();
      messageFocusNode.requestFocus();

      // Update unread count for recipient
      await _updateRecipientUnreadCount(chatId, otherUserId);
    } catch (e) {
      log('Error sending message: $e');
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateRecipientUnreadCount(
      String chatId, String recipientId) async {
    try {
      await _firestore.collection('Users').doc(recipientId).update({
        'unreadChats.$chatId': FieldValue.increment(1),
      });
    } catch (e) {
      log('Error updating unread count: $e');
    }
  }

  /// Clear chat data when leaving chat
  void clearChat() {
    messages.clear();
    currentChatId.value = '';
  }

  @override
  void onClose() {
    messageController.dispose();
    messageFocusNode.dispose();
    clearChat();
    super.onClose();
  }
}
