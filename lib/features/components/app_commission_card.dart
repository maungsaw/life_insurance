import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

/// Phase-1 commission **display** card (wireframe balance look · no payout).
class AppCommissionCard extends StatefulWidget {
  const AppCommissionCard({
    super.key,
    required this.amountLabel,
    this.title = 'Commission',
    this.deltaLabel,
    this.onDetails,
    this.showDetailsChevron = true,
  });

  final String amountLabel;
  final String title;
  final String? deltaLabel;
  final VoidCallback? onDetails;
  /// Home shows chevron; history screen hides it.
  final bool showDetailsChevron;

  @override
  State<AppCommissionCard> createState() => _AppCommissionCardState();
}

class _AppCommissionCardState extends State<AppCommissionCard> {
  bool _hidden = false;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF006494), Color(0xFF00A6FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightPrimary.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (widget.deltaLabel != null)
                      Text(
                        widget.deltaLabel!,
                        style: const TextStyle(
                          color: Color(0xFFBBF7D0),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  _hidden ? '•••••••• MMK' : widget.amountLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _hidden = !_hidden),
                icon: Icon(
                  _hidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white,
                ),
              ),
              if (widget.onDetails != null && widget.showDetailsChevron)
                IconButton(
                  onPressed: widget.onDetails,
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
            ],
          ),
        ],
      ),
    );

    if (widget.onDetails == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onDetails,
        borderRadius: BorderRadius.circular(20),
        child: card,
      ),
    );
  }
}
