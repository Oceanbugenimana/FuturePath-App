import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/futurepath_viewmodel.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class AiMentorScreen extends StatefulWidget {
  const AiMentorScreen({super.key});

  @override
  State<AiMentorScreen> createState() => _AiMentorScreenState();
}

class _AiMentorScreenState extends State<AiMentorScreen> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  static const _quickPrompts = [
    'How do I start learning to code?',
    'What salary can I expect in 3 years?',
    'Will AI replace my career?',
    'How to learn with a low budget?',
    'How do I improve my streak?',
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send(FuturePathViewModel vm) {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    _ctrl.clear();
    vm.sendChatMessage(text);
    Future.delayed(const Duration(milliseconds: 300), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FuturePathViewModel>();
    final messages = vm.chatMessages;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kNeonTeal.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.smart_toy, color: kNeonTeal, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alpha-9 AI Mentor',
                        style: TextStyle(
                            color: kStellarWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    Text('Elite futuristic career advisor',
                        style: TextStyle(color: kCyberGray, fontSize: 11)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: kCyberGray),
                onPressed: () => _showClearDialog(context, vm),
                tooltip: 'Clear chat',
              ),
            ],
          ),
        ),

        // Messages
        Expanded(
          child: messages.isEmpty
              ? _emptyState(vm)
              : ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  itemCount: messages.length + (vm.isChatLoading ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == messages.length) return _typingIndicator();
                    final msg = messages[i];
                    return _messageBubble(msg.sender, msg.text);
                  },
                ),
        ),

        // Quick prompts
        if (messages.isEmpty)
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _quickPrompts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () {
                  _ctrl.text = _quickPrompts[i];
                  _send(vm);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: kNeonTeal.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: kNeonTeal.withOpacity(0.25)),
                  ),
                  child: Text(_quickPrompts[i],
                      style: const TextStyle(
                          color: kNeonTeal, fontSize: 12)),
                ),
              ),
            ),
          ),

        // Input bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: BoxDecoration(
            color: kCyberCard,
            border: Border(
                top: BorderSide(color: kCyberGray.withOpacity(0.12))),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  style: const TextStyle(color: kStellarWhite, fontSize: 14),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(vm),
                  decoration: InputDecoration(
                    hintText: 'Ask Alpha-9 anything...',
                    hintStyle: TextStyle(
                        color: kCyberGray.withOpacity(0.6), fontSize: 13),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _send(vm),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [kNeonTeal, kNeonPurple]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _messageBubble(String sender, String text) {
    final isUser = sender == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: kNeonTeal.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy,
                  color: kNeonTeal, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? kNeonTeal.withOpacity(0.15)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: Border.all(
                  color: isUser
                      ? kNeonTeal.withOpacity(0.3)
                      : Colors.white.withOpacity(0.08),
                ),
              ),
              child: Text(text,
                  style: TextStyle(
                      color: isUser ? kStellarWhite : kStellarWhite,
                      fontSize: 13,
                      height: 1.5)),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _typingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: kNeonTeal.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy, color: kNeonTeal, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const SizedBox(
              width: 40,
              child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: kNeonTeal,
                  minHeight: 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(FuturePathViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kNeonTeal.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_outlined,
                  color: kNeonTeal, size: 48),
            ),
            const SizedBox(height: 20),
            const Text('Alpha-9 is ready',
                style: TextStyle(
                    color: kStellarWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
                'Ask me anything about your career, salary, skills, or learning path.',
                textAlign: TextAlign.center,
                style: TextStyle(color: kCyberGray, fontSize: 13, height: 1.5)),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, FuturePathViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kCyberCard,
        title: const Text('Clear Chat',
            style: TextStyle(color: kStellarWhite)),
        content: const Text('Delete all messages with Alpha-9?',
            style: TextStyle(color: kCyberGray)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: kCyberGray)),
          ),
          TextButton(
            onPressed: () {
              vm.clearChatHistory();
              Navigator.pop(context);
            },
            child: const Text('Clear',
                style: TextStyle(color: kDangerRed)),
          ),
        ],
      ),
    );
  }
}
