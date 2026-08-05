import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        TextStyle,
        TextSpan,
        Image,
        BoxFit,
        Text,
        Center,
        ClipOval,
        CircleAvatar,
        RichText,
        BoxDecoration,
        Container,
        WidgetSpan,
        Icons,
        Icon,
        Padding,
        ListTile,
        Theme;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:life_insurance/core/core.dart' show AppRoute;
import 'package:life_insurance/features/customer/domain/domain.dart'
    show CustomerEntity;

class CustomerListTile extends StatelessWidget {
  final CustomerEntity customer;

  const CustomerListTile({super.key, required this.customer});

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final int count = customer.policyCount;
    final String policyText = count == 1 ? '1 policy' : '$count policies';
    final theme = Theme.of(context);

    return ListTile(
      onTap: () => context.push(AppRoute.customerDetail, extra: customer),
      contentPadding: const .symmetric(horizontal: 16, vertical: 8),

      // 1. Avatar (Leading Widget)
      leading: CircleAvatar(
        radius: 26,
        child: ClipOval(
          child: Image.network(
            customer.avatarUrl,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  _getInitials(customer.name),
                  style: const TextStyle(fontWeight: .bold, fontSize: 16),
                ),
              );
            },
          ),
        ),
      ),

      // 2. Main Title (Customer Name)
      title: Text(
        customer.name,
        style: TextStyle(
          fontSize: 15,
          fontWeight: .bold,
          color: theme.colorScheme.onSurface,
        ),
      ),

      // 3. Subtitle (Email & Phone Block)
      subtitle: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 13,
            color: theme.shadowColor.withValues(alpha: 0.6),
          ),
          children: [
            // Email line
            TextSpan(text: customer.email),
            const TextSpan(text: '\n'),
            // Phone Number
            TextSpan(
              text: customer.phone,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),

      // 4. Trailing Action (Policy Badge + Chevron)
      trailing: RichText(
        textAlign: .right,
        text: TextSpan(
          children: [
            // 1. Policy Chip Container embedded inline
            WidgetSpan(
              alignment: .middle,
              child: Container(
                padding: const .symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: .circular(12),
                  color: theme.primaryColor.withValues(alpha: 0.15),
                ),
                child: Text(
                  policyText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: .w600,
                    color: theme.primaryColor.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),

            // Line break to stack the icon below
            const TextSpan(text: '\n'),

            // 2. Trailing Chevron Icon
            WidgetSpan(
              alignment: .middle,
              child: Padding(
                padding: const .only(top: 4.0),
                child: Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: theme.shadowColor.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
