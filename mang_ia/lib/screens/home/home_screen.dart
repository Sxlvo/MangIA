import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../models/models.dart';
import '../../providers/app_providers.dart';
import '../../screens/settings/settings_screen.dart';
import '../../widgets/shared_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPage(
      faintTitle: 'Home',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 112),
        children: [
          const AppLogo(),
          const SizedBox(height: 16),
          Row(
            children: [
              const AvatarStack(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1,
                              color: AppColors.ink,
                            ),
                        children: const [
                          TextSpan(text: 'Ciao, '),
                          TextSpan(
                            text: 'Martina',
                            style: TextStyle(color: AppColors.green),
                          ),
                          TextSpan(text: '!'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Venerdi, 22 maggio',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              CircleIconButton(
                icon: Icons.settings_outlined,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const DailyBalanceCard(),
          const SizedBox(height: 16),
          const HydrationCard(),
          const SizedBox(height: 26),
          SectionHeader(
            title: 'Pasti recenti',
            action: 'Vedi tutti',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const RecentMealsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          const RecentMealTile(
            icon: Icons.coffee,
            title: 'Colazione',
            time: '08:15',
          ),
          const SizedBox(height: 10),
          const RecentMealTile(
            icon: Icons.local_dining,
            title: 'Spuntino',
            time: '10:30',
          ),
        ],
      ),
    );
  }
}

class DailyBalanceCard extends ConsumerWidget {
  const DailyBalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(vitalityScoreProvider);

    return SoftCard(
      borderColor: AppColors.yellow.withValues(alpha: 0.55),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart, color: AppColors.yellow, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'EQUILIBRIO DELLA GIORNATA',
                  style: TextStyle(
                    color: Color(0xFF9A6700),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(selectedTabProvider.notifier).select(1);
                },
                child: const Text(
                  'Altre informazioni >',
                  style: TextStyle(fontSize: 11, color: AppColors.green),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 112,
                height: 112,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: score / 100,
                        strokeWidth: 9,
                        strokeCap: StrokeCap.round,
                        backgroundColor: AppColors.mint.withValues(alpha: 0.13),
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.mint,
                        ),
                      ),
                    ),
                    Text(
                      '$score%',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Giornata abbastanza equilibrata',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ti manca ancora ferro e qualche sorso d acqua per il tuo fabbisogno quotidiano.',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                    const SizedBox(height: 9),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        value: 0.74,
                        minHeight: 8,
                        backgroundColor: Color(0xFFFFE7A5),
                        valueColor: AlwaysStoppedAnimation(AppColors.yellow),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0%',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.muted,
                          ),
                        ),
                        Text(
                          '100%',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 14, color: Color(0xFF9A6700)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Prova ad aggiungere una fonte di ferro ai prossimi pasti.',
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecentMealsScreen extends StatelessWidget {
  const RecentMealsScreen({super.key});

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
              'Tutti i pasti recenti',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.green,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Raggruppati per giorno, senza interrompere il tuo flusso.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 24),
            const MealDayGroup(
              day: 'Oggi',
              meals: [
                MealEntry(
                  Icons.coffee,
                  'Colazione',
                  '08:15',
                  'Yogurt, avena e frutta',
                ),
                MealEntry(
                  Icons.local_dining,
                  'Spuntino',
                  '10:30',
                  'Pomodorini e crackers',
                ),
                MealEntry(
                  Icons.restaurant_menu,
                  'Pranzo',
                  '13:20',
                  'Fufu con verdure',
                ),
              ],
            ),
            const SizedBox(height: 18),
            const MealDayGroup(
              day: 'Ieri',
              meals: [
                MealEntry(
                  Icons.breakfast_dining,
                  'Colazione',
                  '08:40',
                  'Pane integrale e marmellata',
                ),
                MealEntry(
                  Icons.rice_bowl,
                  'Pranzo',
                  '13:10',
                  'Riso, ceci e spinaci',
                ),
                MealEntry(
                  Icons.soup_kitchen,
                  'Cena',
                  '20:35',
                  'Zuppa di verdure',
                ),
              ],
            ),
            const SizedBox(height: 18),
            const MealDayGroup(
              day: 'Martedi',
              meals: [
                MealEntry(
                  Icons.egg_alt,
                  'Colazione',
                  '09:00',
                  'Uova e pane tostato',
                ),
                MealEntry(
                  Icons.local_pizza,
                  'Cena',
                  '21:00',
                  'Pizza marinara e insalata',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MealDayGroup extends StatelessWidget {
  const MealDayGroup({required this.day, required this.meals, super.key});

  final String day;
  final List<MealEntry> meals;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          for (final meal in meals) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFEFFAF2),
                  child: Icon(meal.icon, color: AppColors.green, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.title,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        meal.description,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  meal.time,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
            if (meal != meals.last)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
          ],
        ],
      ),
    );
  }
}

class HydrationCard extends ConsumerWidget {
  const HydrationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final water = ref.watch(waterGlassesProvider);
    final hydrationSettings = ref.watch(hydrationSettingsProvider);

    return SoftCard(
      color: AppColors.softBlue,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFF3D82F6),
                      child: Icon(
                        Icons.water_drop,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'IDRATAZIONE',
                      style: TextStyle(
                        color: Color(0xFF3D82F6),
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: List.generate(
                    WaterController.target,
                    (index) => Expanded(
                      child: Container(
                        height: 16,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: index < water
                              ? const Color(0xFF3D82F6)
                              : const Color(0xFFD8E9FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  hydrationSettings.totalLabel(water),
                  style: const TextStyle(
                    color: Color(0xFF2272E8),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 0.9,
                  ),
                ),
                Text(
                  'obiettivo: ${hydrationSettings.targetLabel()}',
                  style: const TextStyle(
                    color: Color(0xFF3D82F6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          StepperPill(
            onMinus: () => ref.read(waterGlassesProvider.notifier).decrement(),
            onPlus: () => ref.read(waterGlassesProvider.notifier).increment(),
          ),
        ],
      ),
    );
  }
}
