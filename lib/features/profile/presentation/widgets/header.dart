// ==========================================
// 1. Modern Collapsible Parallax Header
// ==========================================
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        EdgeInsets,
        SizedBox,
        NetworkImage,
        Theme,
        kToolbarHeight,
        MediaQuery,
        FontWeight,
        Text,
        AnimatedOpacity,
        LayoutBuilder,
        Alignment,
        LinearGradient,
        BoxDecoration,
        Container,
        BoxShape,
        Positioned,
        MainAxisAlignment,
        CircleAvatar,
        Colors,
        Border,
        Stack,
        BorderRadius,
        BackdropFilter,
        ClipRRect,
        Column,
        SafeArea,
        FlexibleSpaceBar,
        SliverAppBar;

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 280.0,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16),
        title: LayoutBuilder(
          builder: (context, constraints) {
            // Show title only when app bar is collapsed
            final isCollapsed =
                constraints.maxHeight <=
                kToolbarHeight + MediaQuery.paddingOf(context).top + 10;
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isCollapsed ? 1.0 : 0.0,
              child: Text(
                'Marcus J. Reynolds',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        background: Stack(
          fit: .expand,
          children: [
            // Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Decorative Background Circles
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.onPrimary.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Main Header Details
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  // Avatar with Gradient Ring
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.onPrimary,
                              colorScheme.onPrimary.withValues(alpha: 0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 42,
                          backgroundColor: colorScheme.onPrimary.withValues(
                            alpha: 0.1,
                          ),
                          backgroundImage: const NetworkImage(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Marcus J. Reynolds',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Senior Insurance Agent',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Glassmorphic ID Chip
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.onPrimary.withValues(
                              alpha: 0.25,
                            ),
                          ),
                        ),
                        child: Text(
                          'ID: AGT-00492',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
