// --- Mock Leads List (Matches Screenshot) ---
import 'dart:ui' show Color;

import 'package:life_insurance/features/lead/domain/domain.dart'
    show LeadEntity;

final List<LeadEntity> leadsData = [
  LeadEntity(
    id: '1',
    name: 'Michael Clark',
    email: 'michael@gmail.com',
    phone: '09 750 123 456',
    status: 'New',
    timeAgo: '2m ago',
    avatarColor: Color(0xFF7C4DFF),
  ),
  LeadEntity(
    id: '2',
    name: 'Sarah Parker',
    email: 'sarahparker@gmail.com',
    phone: '09 751 234 567',
    status: 'Contacted',
    timeAgo: '1h ago',
    avatarColor: Color(0xFF29B6F6),
  ),
  LeadEntity(
    id: '3',
    name: 'David Wilson',
    email: 'davidwilson@gmail.com',
    phone: '09 752 345 678',
    status: 'Quoted',
    timeAgo: '3h ago',
    avatarColor: Color(0xFFE67E22),
  ),
  LeadEntity(
    id: '4',
    name: 'Jessica Lee',
    email: 'jessicalee@gmail.com',
    phone: '09 753 456 789',
    status: 'Applied',
    timeAgo: '5h ago',
    avatarColor: Color(0xFF2ECC71),
  ),
  LeadEntity(
    id: '5',
    name: 'Richard Price',
    email: 'richardprice@gmail.com',
    phone: '09 754 567 890',
    status: 'Contacted',
    timeAgo: '1d ago',
    avatarColor: Color(0xFFE74C3C),
  ),
  LeadEntity(
    id: '6',
    name: 'Amara Nwosu',
    email: 'amara.nwosu@gmail.com',
    phone: '09 755 678 901',
    status: 'New',
    timeAgo: '1d ago',
    avatarColor: Color(0xFF2C3E50),
  ),
  LeadEntity(
    id: '7',
    name: 'Kenji Patel',
    email: 'kenji.patel@gmail.com',
    phone: '09 756 789 012',
    status: 'Quoted',
    timeAgo: '2d ago',
    avatarColor: Color(0xFF16A085),
  ),
];
