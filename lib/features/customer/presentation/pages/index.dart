import 'package:flutter/material.dart';
import 'package:life_insurance/features/customer/domain/domain.dart'
    show CustomerEntity;

import 'item.dart' show CustomerListTile;

class CustomersPage extends StatelessWidget {
  CustomersPage({super.key});

  // Sample customer data matching the UI screenshot
  final List<CustomerEntity> _customers = [
    CustomerEntity(
      name: 'Jane Cooper',
      email: 'janecooper@gmail.com',
      phone: '+1 202-555-0145',
      policyCount: 3,
      avatarUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
    ),
    CustomerEntity(
      name: 'Robert Fox',
      email: 'robertfox@gmail.com',
      phone: '+1 202-555-0187',
      policyCount: 2,
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    ),
    CustomerEntity(
      name: 'Esther Howard',
      email: 'estherhoward@gmail.com',
      phone: '+1 202-555-0124',
      policyCount: 1,
      avatarUrl:
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150',
    ),
    CustomerEntity(
      name: 'Cody Fisher',
      email: 'codyfisher@gmail.com',
      phone: '+1 202-555-0108',
      policyCount: 4,
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    ),
    CustomerEntity(
      name: 'Brooklyn Simmons',
      email: 'brooklyns@gmail.com',
      phone: '+1 202-555-0173',
      policyCount: 2,
      avatarUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
    ),
    CustomerEntity(
      name: 'Amara Okafor',
      email: 'amara.okafor@gmail.com',
      phone: '+1 202-555-0199',
      policyCount: 1,
      avatarUrl:
          'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=150',
    ),
    CustomerEntity(
      name: 'Marcus Tanaka',
      email: 'marcus.tanaka@gmail.com',
      phone: '+1 202-555-0212',
      policyCount: 3,
      avatarUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    ),
    CustomerEntity(
      name: 'Priya Sharma',
      email: 'priya.sharma@gmail.com',
      phone: '+1 202-555-0234',
      policyCount: 2,
      avatarUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0,
          pinned: true,
          title: const Text(
            'Customers',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, size: 24),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.filter_list, size: 24),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        SliverList.separated(
          itemCount: _customers.length,
          separatorBuilder: (context, index) =>
              Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
          itemBuilder: (context, index) {
            final customer = _customers[index];
            return CustomerListTile(customer: customer);
          },
        ),
      ],
    );
  }
}
