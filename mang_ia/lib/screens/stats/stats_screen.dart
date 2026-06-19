import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../providers/app_providers.dart';
import '../../widgets/shared_widgets.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final water = ref.watch(waterGlassesProvider);
    final hydrationSettings = ref.watch(hydrationSettingsProvider);
    final hydrationPercent = (water / WaterController.target * 100).round();

    return AppPage(
      faintTitle: 'Progressi',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 112),
        children: [
          const AppLogo(),
          const SizedBox(height: 18),
          BackEyebrow(
            label: 'IL TUO RESOCONTO SETTIMANALE',
            onBack: () => goBackOrHome(context, ref),
          ),
          Text(
            'Le tue statistiche.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 16),
          SoftCard(
            child: SizedBox(
              height: 258,
              child: CustomPaint(
                painter: StatsChartPainter(),
                child: const Padding(
                  padding: EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VITALITY SCORE',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '88',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: 42,
                                    height: 0.9,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text('/100'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'MEDIA SET.',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '82',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 8),
                          SmallTrendBadge(text: '+10%'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: MetricCard(
                  icon: Icons.restaurant,
                  title: 'Nutrition',
                  value: 'Balanced',
                  accent: AppColors.yellow,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: MetricCard(
                  icon: Icons.water_drop_outlined,
                  title: 'Hydration',
                  value: '$hydrationPercent%',
                  subtitle: hydrationSettings.totalLabel(water),
                  accent: const Color(0xFF1689B5),
                  progress: water / WaterController.target,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.accent,
    this.subtitle,
    this.progress,
    super.key,
  });

  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color accent;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      color: accent == AppColors.yellow
          ? Colors.white
          : const Color(0xFFEAF8FF),
      child: SizedBox(
        height: 128,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accent, size: 18),
                const SizedBox(width: 6),
                Text(title, style: const TextStyle(color: AppColors.muted)),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: value.length <= 3 ? 32 : 22,
                color: accent == AppColors.yellow ? AppColors.ink : accent,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: progress ?? (accent == AppColors.yellow ? 0.67 : 0.5),
                minHeight: 5,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation(accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;
    final line = Paint()
      ..color = AppColors.green
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final dot = Paint()..color = AppColors.green;
    final glow = Paint()..color = AppColors.mint.withValues(alpha: 0.25);

    final chartTop = size.height * 0.47;
    final chartBottom = size.height * 0.83;
    final left = size.width * 0.12;
    final right = size.width * 0.88;

    for (var i = 0; i < 4; i++) {
      final y = chartTop + (chartBottom - chartTop) * i / 3;
      canvas.drawLine(Offset(left, y), Offset(right, y), grid);
    }

    final points =
        [
          const Offset(0.00, 0.82),
          const Offset(0.18, 0.68),
          const Offset(0.32, 0.54),
          const Offset(0.48, 0.60),
          const Offset(0.58, 0.36),
          const Offset(0.70, 0.18),
          const Offset(0.84, 0.10),
          const Offset(1.00, 0.00),
        ].map((p) {
          return Offset(
            left + (right - left) * p.dx,
            chartTop + (chartBottom - chartTop) * p.dy,
          );
        }).toList();

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, line);

    for (final point in points.skip(1).take(6)) {
      canvas.drawCircle(point, 6, Paint()..color = Colors.white);
      canvas.drawCircle(point, 4, dot);
    }
    canvas.drawCircle(points.last, 16, glow);
    canvas.drawCircle(points.last, 8, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
