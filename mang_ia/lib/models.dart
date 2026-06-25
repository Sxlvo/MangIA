import 'package:flutter/material.dart';

class UserProfile {
  const UserProfile();
}

class ScanResult {
  const ScanResult({
    required this.recognized,
    required this.title,
    required this.subtitle,
    required this.info,
    required this.warning,
    required this.suggestions,
  });

  final bool recognized;
  final String title;
  final String subtitle;
  final String info;
  final String warning;
  final List<String> suggestions;
}

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });

  final String text;
  final bool isUser;
  final DateTime time;
}

class Expert {
  const Expert({
    required this.name,
    required this.specialty,
    required this.location,
    required this.matchRate,
    required this.price,
    required this.availableToday,
    required this.tags,
    required this.reason,
    required this.imageUrl,
  });

  final String name;
  final String specialty;
  final String location;
  final int matchRate;
  final String price;
  final bool availableToday;
  final List<String> tags;
  final String reason;
  final String imageUrl;

  int get budgetValue {
    final match = RegExp(r'\d+').firstMatch(price);
    return int.tryParse(match?.group(0) ?? '') ?? 999;
  }
}

class SettingsItem {
  const SettingsItem(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;
}

class MealEntry {
  const MealEntry(this.icon, this.title, this.time, this.description);

  final IconData icon;
  final String title;
  final String time;
  final String description;
}
