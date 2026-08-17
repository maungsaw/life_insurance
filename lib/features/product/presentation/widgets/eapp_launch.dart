import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/lead/domain/entities/lead.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';

/// Shared doors into Get A Quote / the e-App wizard (`81`).
abstract final class EappLaunch {
  static QuoteParty partyFromCustomer(CustomerMock customer) => QuoteParty(
    id: customer.id,
    name: customer.name,
    kind: QuotePartyKind.client,
    phone: customer.phone,
    email: customer.email,
    dob: customer.dob,
    identification: customer.identification,
    gender: customer.gender,
  );

  static QuoteParty partyFromLead(LeadEntity lead) => QuoteParty(
    id: 'lead-${lead.id}',
    name: lead.name,
    kind: QuotePartyKind.lead,
    phone: lead.phone,
    email: lead.email,
  );

  static void startQuoteForParty(
    BuildContext context,
    QuoteParty party, {
    CatalogProduct? product,
  }) {
    context.push(
      AppRoute.productQuote,
      extra: QuoteLaunchArgs(
        product: product ?? ProductSession.lastOrDefaultProduct,
        party: party,
      ),
    );
  }

  static Future<void> startEappForParty(
    BuildContext context,
    QuoteParty party, {
    EappLaunchIntent intent = EappLaunchIntent.newSale,
  }) async {
    final quotes = ProductSession.quotesForParty(party.id);
    if (quotes.isEmpty) {
      final go = await AppStatusDialog.show(
        context,
        type: AppStatusType.info,
        title: 'No saved quote yet',
        message: 'Save a quote for ${party.name} first.',
        actionLabel: 'GET A QUOTE',
        secondaryLabel: 'CANCEL',
      );
      if (go == true && context.mounted) {
        startQuoteForParty(context, party);
      }
      return;
    }
    SavedQuote? quote = quotes.first;
    if (quotes.length > 1) {
      quote = await showModalBottomSheet<SavedQuote>(
        context: context,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) => ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text(
                'Choose a quote',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            for (final q in quotes)
              ListTile(
                title: Text(q.productName),
                subtitle: Text('${q.monthlyPremium} MMK · ${q.id}'),
                onTap: () => Navigator.pop(ctx, q),
              ),
            const SizedBox(height: 12),
          ],
        ),
      );
      if (quote == null || !context.mounted) return;
    }
    final draft = ProductSession.startEapp(quote, intent: intent);
    if (!context.mounted) return;
    context.push(AppRoute.productEapp, extra: draft);
  }

  static void startRenewalEapp(BuildContext context, PolicyMock policy) {
    final existing = ProductSession.openDraftForPolicy(policy.id);
    if (existing != null) {
      context.push(AppRoute.productEapp, extra: existing);
      return;
    }
    final draft = ProductSession.startEappFromPolicy(policy);
    context.push(AppRoute.productEapp, extra: draft);
  }

  static String renewalCta(PolicyMock policy) {
    return ProductSession.openDraftForPolicy(policy.id) == null
        ? 'Renew'
        : 'Continue';
  }
}

class EappRenewalPill extends StatelessWidget {
  const EappRenewalPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightPrimary),
      ),
      child: const Text(
        'Renewal',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.lightPrimary,
        ),
      ),
    );
  }
}
