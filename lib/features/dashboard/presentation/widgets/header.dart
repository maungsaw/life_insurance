import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        // 2. Avatar
        CircleAvatar(
          radius: 20,
          backgroundColor: theme.primaryColor,
          child: Text('JA', style: TextStyle(fontWeight: .bold, fontSize: 14)),
        ),

        const SizedBox(width: 12),

        // 3. Greeting & Name
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Text(
                'Good Afternoon,',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  Text(
                    'John Agent ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: .bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  Text('👋', style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),

        // 4. Dropdown Pill (Far Right)
        Container(
          padding: const .symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: .circular(20),
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.16),
          ),
          child: Row(
            mainAxisSize: .min,
            children: [
              Text(
                'This Month',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 12,
                  fontWeight: .w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Badge(
          smallSize: 8,
          backgroundColor: theme.colorScheme.error,
          offset: const Offset(-2, 2),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded, size: 26),
            color: theme.textTheme.bodyLarge?.color,
            padding: .zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }
}
