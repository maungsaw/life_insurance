import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        Color,
        EdgeInsets,
        Colors,
        BorderRadius,
        Border,
        BoxDecoration,
        FontWeight,
        TextStyle,
        Text,
        Container;

class AppStatusBadge extends StatelessWidget {
  final String status;

  const AppStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    Color borderColor;

    switch (status) {
      case 'New':
        textColor = const Color(0xFF1E3A8A);
        bgColor = const Color(0xFFDBEAFE);
        borderColor = const Color(0xFFBFDBFE);
        break;
      case 'Contacted':
        textColor = const Color(0xFFD97706);
        bgColor = const Color(0xFFFEF3C7);
        borderColor = const Color(0xFFFDE68A);
        break;
      case 'Qualified':
        textColor = const Color(0xFF16A34A);
        bgColor = const Color(0xFFDCFCE7);
        borderColor = const Color(0xFFBBF7D0);
        break;
      default:
        textColor = Colors.grey;
        bgColor = Colors.grey.shade100;
        borderColor = Colors.grey.shade300;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
