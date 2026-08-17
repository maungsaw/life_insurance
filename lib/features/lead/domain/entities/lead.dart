import 'package:flutter/material.dart';

class LeadEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String status; // 'New', 'Contacted', 'Qualified', etc.
  final String timeAgo;
  final Color avatarColor;

  const LeadEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.timeAgo,
    required this.avatarColor,
  });

  // Initials generator for the avatar circle (e.g. "Michael Clark" -> "MC")
  String get initials {
    List<String> parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }
}
