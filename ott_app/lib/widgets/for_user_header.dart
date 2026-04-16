import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ForUserHeader extends StatelessWidget {
  const ForUserHeader({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Text(
      'For $userName',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
    );
  }
}

