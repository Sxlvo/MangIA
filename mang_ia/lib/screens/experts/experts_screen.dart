import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../models/models.dart';
import '../../providers/app_providers.dart';
import '../../widgets/shared_widgets.dart';

class ExpertsScreen extends ConsumerWidget {
  const ExpertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experts = ref.watch(expertsProvider);
    final filters = ref.watch(expertFiltersProvider);

    return AppPage(
      faintTitle: 'Esperti',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 112),
        children: [
          const AppLogo(),
          const SizedBox(height: 16),
          BackEyebrow(
            label: 'CERCA ESPERTI',
            onBack: () => goBackOrHome(context, ref),
          ),
          Text(
            'Trova il tuo match perfetto.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChipPill(
                label: 'Budget',
                selected: filters.contains(ExpertFilter.budget),
                onTap: () => ref
                    .read(expertFiltersProvider.notifier)
                    .toggle(ExpertFilter.budget),
              ),
              FilterChipPill(
                label: 'Specializzazione',
                selected: filters.contains(ExpertFilter.specialty),
                onTap: () => ref
                    .read(expertFiltersProvider.notifier)
                    .toggle(ExpertFilter.specialty),
              ),
              FilterChipPill(
                label: 'Disponibilita',
                selected: filters.contains(ExpertFilter.availability),
                onTap: () => ref
                    .read(expertFiltersProvider.notifier)
                    .toggle(ExpertFilter.availability),
              ),
              FilterChipPill(
                label: 'Cancella filtri',
                selected: filters.isEmpty,
                onTap: () => ref.read(expertFiltersProvider.notifier).clear(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            filters.isEmpty
                ? '3 esperti selezionati per te'
                : 'Filtri attivi: ${filters.length}',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 10),
          experts.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => const Text('Errore caricamento.'),
            data: (items) {
              final visible = items.where((expert) {
                final budgetOk =
                    !filters.contains(ExpertFilter.budget) ||
                    expert.budgetValue <= 50;
                final specialtyOk =
                    !filters.contains(ExpertFilter.specialty) ||
                    expert.matchRate >= 90;
                final availabilityOk =
                    !filters.contains(ExpertFilter.availability) ||
                    expert.availableToday;
                return budgetOk && specialtyOk && availabilityOk;
              }).toList();

              if (visible.isEmpty) {
                return const SoftCard(
                  child: Text(
                    'Nessun esperto corrisponde ai filtri selezionati.',
                  ),
                );
              }

              return Column(
                children: [
                  for (final expert in visible) ...[
                    ExpertMatchCard(expert: expert),
                    const SizedBox(height: 14),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ExpertMatchCard extends StatelessWidget {
  const ExpertMatchCard({required this.expert, super.key});

  final Expert expert;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  expert.imageUrl,
                  width: 68,
                  height: 82,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 68,
                    height: 82,
                    color: const Color(0xFFE1F8E8),
                    child: const Icon(Icons.person, color: AppColors.green),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expert.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${expert.specialty} - ${expert.location}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.star, color: AppColors.yellow, size: 15),
                        Icon(Icons.star, color: AppColors.yellow, size: 15),
                        Icon(Icons.star, color: AppColors.yellow, size: 15),
                        Icon(Icons.star, color: AppColors.yellow, size: 15),
                        Icon(
                          Icons.star_half,
                          color: AppColors.yellow,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Text('4.9', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      expert.price,
                      style: const TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              MatchBadge(rate: expert.matchRate),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final tag in expert.tags) ExpertTag(text: tag)],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: AppColors.yellow,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    expert.reason,
                    style: const TextStyle(fontSize: 12, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) =>
                            ExpertBookingScreen(expert: expert),
                      ),
                    );
                  },
                  child: const Text('Prenota consulto'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) =>
                            ExpertProfileScreen(expert: expert),
                      ),
                    );
                  },
                  child: const Text('Vedi profilo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpertBookingScreen extends StatefulWidget {
  const ExpertBookingScreen({required this.expert, super.key});

  final Expert expert;

  @override
  State<ExpertBookingScreen> createState() => _ExpertBookingScreenState();
}

class _ExpertBookingScreenState extends State<ExpertBookingScreen> {
  String? _selectedDay;
  String? _selectedSlot;

  void _selectSlot(String day, String slot) {
    setState(() {
      _selectedDay = day;
      _selectedSlot = slot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
          children: [
            Row(
              children: [
                CircleIconButton(
                  icon: Icons.chevron_left,
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                const Expanded(child: AppLogo()),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'Prenota consulto',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.green,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            ExpertCompactHeader(expert: widget.expert),
            const SizedBox(height: 18),
            BookingOption(
              title: 'Oggi',
              slots: const ['15:30', '17:00'],
              selectedDay: _selectedDay,
              selectedSlot: _selectedSlot,
              onSelected: _selectSlot,
            ),
            const SizedBox(height: 12),
            BookingOption(
              title: 'Domani',
              slots: const ['09:00', '12:30', '18:00'],
              selectedDay: _selectedDay,
              selectedSlot: _selectedSlot,
              onSelected: _selectSlot,
            ),
            const SizedBox(height: 12),
            BookingOption(
              title: 'Venerdi',
              slots: const ['10:15', '16:45'],
              selectedDay: _selectedDay,
              selectedSlot: _selectedSlot,
              onSelected: _selectSlot,
            ),
            if (_selectedSlot != null) ...[
              const SizedBox(height: 12),
              SoftCard(
                color: const Color(0xFFEFFAF2),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Selezionato: $_selectedDay alle $_selectedSlot',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _selectedSlot == null
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Richiesta inviata a ${widget.expert.name} per $_selectedDay alle $_selectedSlot.',
                          ),
                        ),
                      );
                    },
              icon: const Icon(Icons.calendar_month),
              label: const Text('Conferma richiesta'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpertProfileScreen extends StatelessWidget {
  const ExpertProfileScreen({required this.expert, super.key});

  final Expert expert;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
          children: [
            Row(
              children: [
                CircleIconButton(
                  icon: Icons.chevron_left,
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                const Expanded(child: AppLogo()),
              ],
            ),
            const SizedBox(height: 22),
            ExpertCompactHeader(expert: expert),
            const SizedBox(height: 16),
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profilo professionale',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(expert.reason, style: const TextStyle(height: 1.45)),
                  const SizedBox(height: 14),
                  const Text(
                    'Aree di lavoro',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final tag in expert.tags) ExpertTag(text: tag),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dettagli consulto',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ProfileDetail(
                    icon: Icons.place_outlined,
                    text: expert.location,
                  ),
                  ProfileDetail(icon: Icons.euro, text: expert.price),
                  ProfileDetail(
                    icon: Icons.schedule,
                    text: expert.availableToday
                        ? 'Disponibile oggi'
                        : 'Prima disponibilita domani',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => ExpertBookingScreen(expert: expert),
                  ),
                );
              },
              child: const Text('Prenota consulto'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpertCompactHeader extends StatelessWidget {
  const ExpertCompactHeader({required this.expert, super.key});

  final Expert expert;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              expert.imageUrl,
              width: 82,
              height: 92,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 82,
                height: 92,
                color: const Color(0xFFE1F8E8),
                child: const Icon(Icons.person, color: AppColors.green),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expert.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${expert.specialty} - ${expert.location}'),
                const SizedBox(height: 8),
                MatchBadge(rate: expert.matchRate),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookingOption extends StatelessWidget {
  const BookingOption({
    required this.title,
    required this.slots,
    required this.selectedDay,
    required this.selectedSlot,
    required this.onSelected,
    super.key,
  });

  final String title;
  final List<String> slots;
  final String? selectedDay;
  final String? selectedSlot;
  final void Function(String day, String slot) onSelected;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final slot in slots)
                ChoiceChip(
                  selected: selectedDay == title && selectedSlot == slot,
                  onSelected: (_) => onSelected(title, slot),
                  label: Text(slot),
                  selectedColor: const Color(0xFFDFF8E8),
                  checkmarkColor: AppColors.green,
                  labelStyle: TextStyle(
                    color: selectedDay == title && selectedSlot == slot
                        ? AppColors.green
                        : AppColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: selectedDay == title && selectedSlot == slot
                        ? AppColors.green
                        : const Color(0xFFE5E7EB),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({required this.icon, required this.text, super.key});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
