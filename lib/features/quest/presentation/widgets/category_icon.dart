import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/quest.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    required this.category,
    this.size = 48,
    super.key,
  });

  final QuestCategory category;
  final double size;

  IconData get _icon => switch (category) {
    QuestCategory.physical => Icons.directions_run,
    QuestCategory.social => Icons.chat_bubble,
    QuestCategory.creative => Icons.brush,
    QuestCategory.stealth => Icons.visibility_off,
  };

  Color get _color => switch (category) {
    QuestCategory.physical => AppColors.tierEasy,
    QuestCategory.social => AppColors.tierMedium,
    QuestCategory.creative => AppColors.tierHard,
    QuestCategory.stealth => AppColors.tierLegendary,
  };

  String get _label => switch (category) {
    QuestCategory.physical => 'Physical',
    QuestCategory.social => 'Social',
    QuestCategory.creative => 'Creative',
    QuestCategory.stealth => 'Stealth',
  };

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _label,
      child: Icon(_icon, color: _color, size: size),
    );
  }
}
