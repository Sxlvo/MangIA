import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../screens/chat/chat_ai_screen.dart';
import '../screens/experts/experts_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/scan/scan_flow_screen.dart';
import '../screens/stats/stats_screen.dart';
import '../widgets/shared_widgets.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  static const _pages = [
    HomeScreen(),
    StatsScreen(),
    ScanFlowScreen(),
    ChatAiScreen(),
    ExpertsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(selectedTabProvider);
    final isCameraOpen = tab == 2 && !ref.watch(scanDetailsProvider);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: IndexedStack(index: tab, children: _pages),
          ),
          if (!isCameraOpen)
            const Positioned(
              left: 28,
              right: 28,
              bottom: 20,
              child: FloatingSafeNav(),
            ),
        ],
      ),
    );
  }
}
