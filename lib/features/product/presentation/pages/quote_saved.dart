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
      backgroundColor: AppColors.surface(context),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Linked to ${quote.party.name} · ${quote.party.kindLabel}',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceSecondary(context)),
            ),
            const SizedBox(height: 20),
            _row(context, 'Product', quote.productName),
            _row(context, 'Sum insured', '${quote.sumInsured} MMK'),
            _row(context, 'Premium', '${quote.monthlyPremium} MMK · ${quote.frequency}'),
            _row(context, 'Term', quote.term),
            if (quote.totalAmount != '0.00')
              _row(context, 'Total', '${quote.totalAmount} MMK'),
            _row(context, 'Saved', ProductFormat.dob(quote.savedAt)),
            const Spacer(),
            SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'View saved quotes',
                      variant: AppButtonVariant.secondary,
                      fontSize: 14,
                      onPressed: () => context.push(AppRoute.productQuotes),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: 'Start e-App',
                      fontSize: 14,
                      onPressed: () {
                        final draft = ProductSession.startEapp(quote);
                        context.push(AppRoute.productEapp, extra: draft);
                      },
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

  Widget _row(BuildContext context, String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(k, style: TextStyle(color: AppColors.onSurfaceSecondary(context))),
          ),
          Flexible(
            child: Text(
              v,
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
