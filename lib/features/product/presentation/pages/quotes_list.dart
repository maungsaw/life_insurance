import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

class ProductQuotesPage extends StatelessWidget {
  const ProductQuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final list = ProductSession.quotes;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ProductSubAppBar(title: 'Saved quotes'),
      body: list.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Save a quote from GET A QUOTE first.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.lightTextSecondary),
                ),
              ),
            )
          : ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final q = list[i];
                return ListTile(
                  title: Text(q.productName),
                  subtitle: Text(
                    '${q.party.name} · ${q.monthlyPremium} MMK · ${q.id}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoute.productQuoteSaved, extra: q),
                );
              },
            ),
    );
  }
}
