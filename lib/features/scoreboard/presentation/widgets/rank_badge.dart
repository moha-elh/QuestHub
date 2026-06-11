import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class RankBadge extends StatelessWidget {
  const RankBadge({required this.rank, super.key});

  final int rank;

  @override
  Widget build(BuildContext context) {
    if (rank == 1) {
      return _badge(AppColors.warning, Icons.emoji_events, Colors.black);
    }
    if (rank == 2) {
      return _badge(const Color(0xFF9E9E9E), Icons.emoji_events, Colors.black);
    }
    if (rank == 3) {
      return _badge(const Color(0xFFCD7F32), Icons.emoji_events, Colors.black);
    }
    return _plainBadge();
  }

  Widget _badge(Color bgColor, IconData icon, Color iconColor) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16, color: iconColor),
    );
  }

  Widget _plainBadge() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$rank',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
