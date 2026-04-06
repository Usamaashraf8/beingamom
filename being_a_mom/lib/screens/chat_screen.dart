import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/child.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/quick_actions.dart';
import 'image_analysis_screen.dart';

class ChatScreen extends StatefulWidget {
  final Child child;

  const ChatScreen({super.key, required this.child});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isLoading = false;
  bool _showQuickActions = true;

  @override
  void initState() {
    super.initState();
    _welcomeMessage();
  }

  void _welcomeMessage() {
    _messages.add(Message(
      content: "Hi! I'm Beeba, ${widget.child.name}'s health friend! I'm here to help with any questions about health, nutrition, and growing up healthy. Remember, I'm not a doctor, but I can share helpful information! What would you like to talk about?",
      isUser: false,
      createdAt: DateTime.now(),
    ));
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(
        content: message,
        isUser: true,
        createdAt: DateTime.now(),
      ));
      _isLoading = true;
      _showQuickActions = false;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await context.read<ApiService>().sendMessage(
        message,
        widget.child.id,
      );

      setState(() {
        _messages.add(Message(
          content: response,
          isUser: false,
          createdAt: DateTime.now(),
        ));
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(Message(
          content: "I'm sorry, I couldn't get a response. Please try again.",
          isUser: false,
          createdAt: DateTime.now(),
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.face, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Beeba', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  '${widget.child.name}\'s friend',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ImageAnalysisScreen(child: widget.child),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Age indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.secondaryColor.withOpacity(0.2),
            child: Row(
              children: [
                const Icon(Icons.cake, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  '${widget.child.name} is ${widget.child.ageDisplay} old',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(message: message);
              },
            ),
          ),

          // Quick actions
          if (_showQuickActions)
            QuickActions(
              onActionTap: (action) {
                _sendMessage(action);
              },
            ),

          // Input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        filled: true,
                        fillColor: AppTheme.backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(_messageController.text),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send, color: Colors.white),
                      onPressed: _isLoading
                          ? null
                          : () => _sendMessage(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}