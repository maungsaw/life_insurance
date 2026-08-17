import 'package:flutter/material.dart'
    show
        BuildContext,
        CircleAvatar,
        ListTile,
        RichText,
        StatelessWidget,
        Text,
        TextStyle,
        Theme,
        Widget,
        TextSpan,
        WidgetSpan;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:life_insurance/core/core.dart' show AppRoute;
import 'package:life_insurance/features/components/components.dart'
    show AppStatusBadge;

import 'package:life_insurance/features/lead/domain/domain.dart'
    show LeadEntity;

class LeadItemPage extends StatelessWidget {
  final LeadEntity lead;

  const LeadItemPage({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () => context.push(AppRoute.leadDetail, extra: lead),
      contentPadding: const .symmetric(horizontal: 16, vertical: 8),

      // 1. Avatar Circle (Leading Widget)
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: lead.avatarColor,
        child: Text(
          lead.initials,
          style: TextStyle(fontWeight: .bold, fontSize: 15),
        ),
      ),

      // 2. Name (Title Widget)
      title: Text(lead.name, style: TextStyle(fontSize: 15, fontWeight: .bold)),
      subtitle: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface),
          children: [
            TextSpan(text: lead.email),
            const TextSpan(text: '  •  '),
            WidgetSpan(child: AppStatusBadge(status: lead.status)),
          ],
        ),
      ),
      trailing: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          children: [TextSpan(text: lead.timeAgo.toString())],
        ),
      ),
    );
  }
}
