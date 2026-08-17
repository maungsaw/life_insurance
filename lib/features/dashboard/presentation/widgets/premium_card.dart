import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        EdgeInsets,
        LinearGradient,
        Color,
        Offset,
        SizedBox,
        Text,
        Row,
        Alignment,
        BorderRadius,
        BoxShadow,
        BoxDecoration,
        CrossAxisAlignment,
        TextStyle,
        MainAxisAlignment,
        FontWeight,
        Icons,
        Icon,
        Container,
        Column;
import 'package:life_insurance/core/core.dart' show AppColors;

class TotalPremiumCard extends StatelessWidget {
  const TotalPremiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Premium',
            style: TextStyle(
              color: AppColors.surface(context).withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$ 24,780.00',
                style: TextStyle(
                  color: AppColors.surface(context),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface(context).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.north_east, color: Color(0xFF4ADE80), size: 14),
                    SizedBox(width: 4),
                    Text(
                      '18.6%',
                      style: TextStyle(
                        color: Color(0xFF4ADE80),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
