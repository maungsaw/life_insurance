import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

class ProductQuoteSavedPage extends StatelessWidget {
  const ProductQuoteSavedPage({super.key, required this.quote});

  final SavedQuote quote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ProductSubAppBar(title: 'Quote saved'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.successGreen,
              size: 56,
            ),
            const SizedBox(height: 12),
            Text(
              quote.id,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Linked to ${quote.party.name} · ${quote.party.kindLabel}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 20),
            _row('Product', quote.productName),
            _row('Sum insured', '${quote.sumInsured} MMK'),
            _row('Premium', '${quote.monthlyPremium} MMK · ${quote.frequency}'),
            _row('Term', quote.term),
            if (quote.totalAmount != '0.00')
              _row('Total', '${quote.totalAmount} MMK'),
            _row('Saved', ProductFormat.dob(quote.savedAt)),
            const Spacer(),
            AppButton(
              label: 'Start e-App',
              onPressed: () {
                final draft = ProductSession.startEapp(quote);
                context.push(AppRoute.productEapp, extra: draft);
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'View saved quotes',
              variant: AppButtonVariant.secondary,
              onPressed: () => context.push(AppRoute.productQuotes),
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Back to Products',
              variant: AppButtonVariant.text,
              onPressed: () => popToShell(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(k, style: const TextStyle(color: AppColors.lightTextSecondary)),
          ),
          Flexible(
            child: Text(
              v,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
