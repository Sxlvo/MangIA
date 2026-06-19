import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../providers/app_providers.dart';
import '../../widgets/shared_widgets.dart';

class ScanFlowScreen extends ConsumerWidget {
  const ScanFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDetails = ref.watch(scanDetailsProvider);
    return showDetails ? const ScanDetailsScreen() : const CameraScreen();
  }
}

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  final _cameraPreviewKey = GlobalKey<_RealCameraPreviewState>();

  Future<void> _takePicture() async {
    await _cameraPreviewKey.currentState?.captureFrame();
    ref.read(manualMealFormProvider.notifier).hide();
    ref.read(scanDetailsProvider.notifier).showDetails();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF1C1C1C),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D),
              borderRadius: BorderRadius.circular(34),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 92,
                  left: 16,
                  right: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: AspectRatio(
                      aspectRatio: 0.72,
                      child: RealCameraPreview(
                        key: _cameraPreviewKey,
                        onCapture: () {
                          ref.read(scanDetailsProvider.notifier).showDetails();
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 42,
                  left: 18,
                  child: CameraTopButton(
                    icon: Icons.close,
                    onTap: () {
                      ref.read(scanDetailsProvider.notifier).showCamera();
                      ref.read(manualMealFormProvider.notifier).hide();
                      ref.read(selectedTabProvider.notifier).select(0);
                    },
                  ),
                ),
                const Positioned(
                  top: 42,
                  right: 18,
                  child: CameraTopButton(icon: Icons.cameraswitch_outlined),
                ),
                const Center(child: CameraReticle()),
                Positioned(
                  left: 72,
                  right: 72,
                  bottom: 120,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.58),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.mint,
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Scatta una foto chiara del tuo piatto',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 54,
                  right: 54,
                  bottom: 42,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        radius: 23,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.restaurant, color: AppColors.green),
                      ),
                      GestureDetector(
                        onTap: _takePicture,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFF313131),
                              width: 5,
                            ),
                          ),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFF2B2B2B),
                        child: Icon(Icons.flash_on, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RealCameraPreview extends StatefulWidget {
  const RealCameraPreview({required this.onCapture, super.key});

  final VoidCallback onCapture;

  @override
  State<RealCameraPreview> createState() => _RealCameraPreviewState();
}

class _RealCameraPreviewState extends State<RealCameraPreview> {
  CameraController? _controller;
  Object? _cameraError;

  @override
  void initState() {
    super.initState();
    _openCamera();
  }

  Future<void> _openCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _cameraError = 'Nessuna camera disponibile');
        return;
      }

      final selected = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        selected,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _cameraError = null;
      });
    } catch (error) {
      if (mounted) {
        setState(() => _cameraError = error);
      }
    }
  }

  Future<void> captureFrame() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      widget.onCapture();
      return;
    }

    try {
      await controller.takePicture();
    } catch (_) {
      // Se l'emulatore non permette lo scatto, continuiamo comunque col mock AI.
    }
    widget.onCapture();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final previewSize = controller.value.previewSize;
            if (previewSize == null) {
              return CameraPreview(controller);
            }

            final previewRatio = previewSize.height / previewSize.width;
            final containerRatio = constraints.maxWidth / constraints.maxHeight;
            var width = constraints.maxWidth;
            var height = constraints.maxHeight;

            if (containerRatio > previewRatio) {
              height = width / previewRatio;
            } else {
              width = height * previewRatio;
            }

            return Center(
              child: SizedBox(
                width: width,
                height: height,
                child: CameraPreview(controller),
              ),
            );
          },
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color(0xFF111111)),
        Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.58),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _cameraError == null
                  ? 'Apro la fotocamera...'
                  : 'Fotocamera non disponibile su questo dispositivo/emulatore.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class CameraTopButton extends StatelessWidget {
  const CameraTopButton({required this.icon, this.onTap, super.key});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white.withValues(alpha: 0.18),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class CameraReticle extends StatelessWidget {
  const CameraReticle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 230,
      child: CustomPaint(painter: ReticlePainter()),
    );
  }
}

class ReticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const corner = 42.0;

    final path = Path()
      ..moveTo(0, corner)
      ..lineTo(0, 0)
      ..lineTo(corner, 0)
      ..moveTo(size.width - corner, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, corner)
      ..moveTo(size.width, size.height - corner)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - corner, size.height)
      ..moveTo(corner, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height - corner);

    canvas.drawPath(path, paint);
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * 0.42,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.24)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScanDetailsScreen extends ConsumerWidget {
  const ScanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scan = ref.watch(scanResultProvider);
    final showManualForm = ref.watch(manualMealFormProvider);

    return AppPage(
      faintTitle: 'Dettagli',
      child: scan.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ListView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 112),
          children: const [
            AppLogo(),
            SizedBox(height: 16),
            InfoBox(
              color: Color(0xFFFFE7E7),
              border: AppColors.danger,
              icon: Icons.warning_amber_rounded,
              title: 'Pasto non riconosciuto',
              text:
                  'La foto non e stata letta correttamente. Puoi aggiungere il pasto manualmente.',
            ),
            SizedBox(height: 14),
            ManualMealForm(),
          ],
        ),
        data: (data) => ListView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 112),
          children: [
            const AppLogo(),
            const SizedBox(height: 16),
            BackEyebrow(
              label: 'RISULTATO AI',
              onBack: () => ref.read(scanDetailsProvider.notifier).showCamera(),
            ),
            Text(
              data.recognized ? 'Analisi pasto' : 'Pasto non riconosciuto',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.green,
              ),
            ),
            const SizedBox(height: 12),
            if (data.recognized) MealResultHero(result: data),
            if (!data.recognized || showManualForm) ...[
              const InfoBox(
                color: Color(0xFFFFF6D7),
                border: AppColors.yellow,
                icon: Icons.edit_note,
                title: 'Aggiunta manuale',
                text:
                    'Inserisci nome del piatto, porzione e dettagli utili. MangIA usera questi dati per darti un feedback.',
              ),
              const SizedBox(height: 12),
              const ManualMealForm(),
              const SizedBox(height: 14),
            ],
            if (data.recognized && !showManualForm) ...[
              const SizedBox(height: 12),
              InfoBox(
                color: const Color(0xFFFFF6D7),
                border: AppColors.yellow,
                icon: Icons.lightbulb_outline,
                title: 'Informazioni sul pasto',
                text: data.info,
              ),
              const SizedBox(height: 12),
              InfoBox(
                color: const Color(0xFFFFE7E7),
                border: AppColors.danger,
                icon: Icons.warning_amber_rounded,
                title: 'Ferro insufficiente',
                text: data.warning,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(manualMealFormProvider.notifier).show();
                },
                icon: const Icon(Icons.edit_note),
                label: const Text(
                  'Pasto non riconosciuto? Aggiungi manualmente',
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Text(
              'Aggiungi per migliorare il ferro',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final suggestion in data.suggestions)
                  SuggestionChip(
                    label: suggestion,
                    onTap: () {
                      ref
                          .read(analysisChatProvider.notifier)
                          .send(
                            'Come posso usare $suggestion in questo pasto?',
                          );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 14),
            const MiniChatCard(),
          ],
        ),
      ),
    );
  }
}

class ManualMealForm extends ConsumerStatefulWidget {
  const ManualMealForm({super.key});

  @override
  ConsumerState<ManualMealForm> createState() => _ManualMealFormState();
}

class _ManualMealFormState extends ConsumerState<ManualMealForm> {
  final _mealController = TextEditingController();
  final _portionController = TextEditingController();
  final _notesController = TextEditingController();
  String _mealType = 'Pranzo';

  @override
  void dispose() {
    _mealController.dispose();
    _portionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aggiungi pasto manualmente',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _mealController,
            decoration: _manualInputDecoration(
              label: 'Nome del piatto',
              hint: 'Es. pasta e ceci',
              icon: Icons.restaurant_menu,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _portionController,
            decoration: _manualInputDecoration(
              label: 'Porzione',
              hint: 'Es. piatto medio, 250g',
              icon: Icons.scale_outlined,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _mealType,
            decoration: _manualInputDecoration(
              label: 'Categoria',
              hint: 'Seleziona categoria',
              icon: Icons.schedule,
            ),
            items: const [
              DropdownMenuItem(value: 'Colazione', child: Text('Colazione')),
              DropdownMenuItem(value: 'Spuntino', child: Text('Spuntino')),
              DropdownMenuItem(value: 'Pranzo', child: Text('Pranzo')),
              DropdownMenuItem(value: 'Cena', child: Text('Cena')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _mealType = value);
              }
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _notesController,
            minLines: 2,
            maxLines: 4,
            decoration: _manualInputDecoration(
              label: 'Note facoltative',
              hint: 'Ingredienti, allergeni, condimenti...',
              icon: Icons.notes,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _saveManualMeal,
                  icon: const Icon(Icons.check),
                  label: const Text('Salva pasto'),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.outlined(
                tooltip: 'Chiudi form',
                onPressed: () {
                  ref.read(manualMealFormProvider.notifier).hide();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _manualInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.green),
      filled: true,
      fillColor: const Color(0xFFF8F6F1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _saveManualMeal() {
    final meal = _mealController.text.trim();
    if (meal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci almeno il nome del piatto.')),
      );
      return;
    }

    ref.read(manualMealFormProvider.notifier).hide();
    ref
        .read(analysisChatProvider.notifier)
        .send(
          'Ho aggiunto manualmente: $meal, categoria $_mealType, porzione ${_portionController.text.trim().isEmpty ? "non specificata" : _portionController.text.trim()}. ${_notesController.text.trim()}',
        );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$meal salvato manualmente.')));
  }
}

class MiniChatCard extends ConsumerStatefulWidget {
  const MiniChatCard({super.key});

  @override
  ConsumerState<MiniChatCard> createState() => _MiniChatCardState();
}

class _MiniChatCardState extends ConsumerState<MiniChatCard> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(analysisChatProvider);
    final visibleMessages = messages.length <= 4
        ? messages
        : messages.sublist(messages.length - 4);

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFE1F8E8),
                child: Icon(Icons.eco, color: AppColors.green, size: 18),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chiedi a MangIA',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Text(
                      'Disponibile ora',
                      style: TextStyle(color: AppColors.green, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          const Text(
            'Domande frequenti',
            style: TextStyle(color: AppColors.muted, fontSize: 11),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              PromptPill(
                text: 'Come integro il ferro?',
                onTap: () => _sendPrompt('Come integro il ferro?'),
              ),
              PromptPill(
                text: 'Consigli per la cena',
                onTap: () =>
                    _sendPrompt('Consigliami una cena ricca di ferro.'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final message in visibleMessages) ChatBubble(message: message),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Scrivi su questo pasto...',
                    hintStyle: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                    prefixIcon: VoiceInputButton(
                      onRecognized: (text) {
                        _controller.text = text;
                        _send();
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF4F1EA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: AppColors.green),
                onPressed: _send,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    final text = _controller.text;
    _controller.clear();
    await ref.read(analysisChatProvider.notifier).send(text);
  }

  Future<void> _sendPrompt(String text) async {
    _controller.clear();
    await ref.read(analysisChatProvider.notifier).send(text);
  }
}
