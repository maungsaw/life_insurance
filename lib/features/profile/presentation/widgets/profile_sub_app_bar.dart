import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

/// Back + title bar for Profile sub-screens (docs/50).
class ProfileSubAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileSubAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: AppColors.surface(context),
      foregroundColor: AppColors.onSurface(context),
    );
  }
}
