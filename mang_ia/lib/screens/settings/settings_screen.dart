import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../models/models.dart';
import '../../providers/app_providers.dart';
import '../../widgets/shared_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydrationSettings = ref.watch(hydrationSettingsProvider);

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
            const SizedBox(height: 24),
            Text(
              'Impostazioni',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.green,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Personalizza profilo, notifiche e preferenze nutrizionali.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 22),
            SoftCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.softBlue,
                  child: Icon(
                    Icons.water_drop_outlined,
                    color: Color(0xFF1689B5),
                  ),
                ),
                title: const Text(
                  'Idratazione',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  'Unita: ${hydrationSettings.unit.label} - Bicchiere: ${hydrationSettings.glassMl} ml',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.muted,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const HydrationSettingsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const SettingsGroup(
              title: 'Profilo',
              items: [
                SettingsItem(
                  Icons.person_outline,
                  'Dati personali',
                  'Eta, altezza, obiettivi',
                ),
                SettingsItem(
                  Icons.health_and_safety_outlined,
                  'Allergie e intolleranze',
                  'Lattosio, glutine, frutta secca',
                ),
                SettingsItem(
                  Icons.restaurant_menu,
                  'Preferenze alimentari',
                  'Cucine, ingredienti, esclusioni',
                ),
              ],
            ),
            SizedBox(height: 16),
            const SettingsGroup(
              title: 'Esperienza',
              items: [
                SettingsItem(
                  Icons.notifications_outlined,
                  'Promemoria',
                  'Acqua, pasti e check settimanali',
                ),
                SettingsItem(
                  Icons.mic_none,
                  'Voce e assistente AI',
                  'Input vocale e stile risposte',
                ),
                SettingsItem(
                  Icons.lock_outline,
                  'Privacy',
                  'Dati salvati e consenso AI',
                ),
              ],
            ),
            SizedBox(height: 16),
            const SettingsGroup(
              title: 'Supporto',
              items: [
                SettingsItem(
                  Icons.help_outline,
                  'Aiuto',
                  'Domande frequenti e contatti',
                ),
                SettingsItem(
                  Icons.info_outline,
                  'Informazioni app',
                  'Versione 1.0.0',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HydrationSettingsScreen extends ConsumerWidget {
  const HydrationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(hydrationSettingsProvider);

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
            const SizedBox(height: 24),
            Text(
              'Idratazione',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.green,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Scegli come visualizzare l acqua e quanto vale un bicchiere.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 22),
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Unita di misura',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<HydrationUnit>(
                    segments: [
                      for (final unit in HydrationUnit.values)
                        ButtonSegment(value: unit, label: Text(unit.label)),
                    ],
                    selected: {settings.unit},
                    onSelectionChanged: (value) {
                      ref
                          .read(hydrationSettingsProvider.notifier)
                          .setUnit(value.first);
                    },
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
                    'Quantita bicchiere',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${settings.glassMl} ml per bicchiere',
                    style: const TextStyle(color: AppColors.muted),
                  ),
                  Slider(
                    value: settings.glassMl.toDouble(),
                    min: 100,
                    max: 500,
                    divisions: 16,
                    label: '${settings.glassMl} ml',
                    activeColor: AppColors.green,
                    onChanged: (value) {
                      ref
                          .read(hydrationSettingsProvider.notifier)
                          .setGlassMl(value.round());
                    },
                  ),
                  Text(
                    'Obiettivo giornaliero: ${settings.targetLabel()}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({required this.title, required this.items, super.key});

  final String title;
  final List<SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 10),
          for (final item in items) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFEFFAF2),
                child: Icon(item.icon, color: AppColors.green),
              ),
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
              onTap: () {},
            ),
            if (item != items.last) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
