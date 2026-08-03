import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/navigation/name.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('Language'),
            onTap: () => context.push(AppRoute.language),
          ),
          ListTile(
            title: Text('Theme'),
            onTap: () => context.push(AppRoute.theme),
          ),
        ],
      ),
    );
  }
}
