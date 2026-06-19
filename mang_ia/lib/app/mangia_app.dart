import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import 'app_shell.dart';

class MangiaApp extends StatelessWidget {
  const MangiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MangIA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AppShell(),
    );
  }
}
