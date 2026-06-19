import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../providers/app_providers.dart';
import '../../widgets/shared_widgets.dart';

class ChatAiScreen extends ConsumerStatefulWidget {
  const ChatAiScreen({super.key});

  @override
  ConsumerState<ChatAiScreen> createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends ConsumerState<ChatAiScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);

    return AppPage(
      faintTitle: 'Chat AI',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
            child: Row(
              children: [
                CircleIconButton(
                  icon: Icons.chevron_left,
                  onTap: () => goBackOrHome(context, ref),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.green,
                  child: Icon(Icons.eco, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'MangIA',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'Online - risponde subito',
                        style: TextStyle(color: AppColors.muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const CircleIconButton(icon: Icons.info_outline),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
              children: [
                const Center(
                  child: Text(
                    'Oggi',
                    style: TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 14),
                for (final message in messages) ChatBubble(message: message),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 106),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      PromptPill(
                        text: 'Come integro il ferro?',
                        onTap: () => _sendPrompt('Come integro il ferro?'),
                      ),
                      PromptPill(
                        text: 'Suggeriscimi una cena',
                        onTap: () => _sendPrompt('Suggeriscimi una cena'),
                      ),
                      PromptPill(
                        text: 'Quante calorie?',
                        onTap: () =>
                            _sendPrompt('Quante calorie ha questo pasto?'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Scrivi a MangIA...',
                          hintStyle: const TextStyle(color: AppColors.muted),
                          prefixIcon: VoiceInputButton(
                            onRecognized: (text) {
                              _controller.text = text;
                              _send();
                            },
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF4F1EA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.green,
                      ),
                      onPressed: _send,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'MangIA puo commettere errori. Consulta sempre un professionista.',
                  style: TextStyle(color: AppColors.muted, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    final text = _controller.text;
    _controller.clear();
    await ref.read(chatMessagesProvider.notifier).send(text);
  }

  Future<void> _sendPrompt(String text) async {
    _controller.clear();
    await ref.read(chatMessagesProvider.notifier).send(text);
  }
}
