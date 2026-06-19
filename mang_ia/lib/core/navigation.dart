import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

void goBackOrHome(BuildContext context, WidgetRef ref) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
    return;
  }
  ref.read(selectedTabProvider.notifier).select(0);
}
