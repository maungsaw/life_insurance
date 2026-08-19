import 'package:flutter/material.dart';
import 'package:life_insurance/design_mockups/atelier_screens.dart';
import 'package:life_insurance/design_mockups/grove_screens.dart';
import 'package:life_insurance/design_mockups/phone_frame.dart';
import 'package:life_insurance/design_mockups/signal_screens.dart';

typedef MockupBuilder = Widget Function();

class MockupBranch {
  const MockupBranch({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.screens,
  });

  final String id;
  final String title;
  final String subtitle;
  final Map<String, MockupBuilder> screens;

  Widget sheet() => MockupSheet(
    title: title,
    subtitle: subtitle,
    phones: [
      for (final e in screens.entries) (e.key, e.value()),
    ],
  );
}

const mockupBranches = <MockupBranch>[
  MockupBranch(
    id: 'atelier',
    title: 'Branch 1 · Atelier',
    subtitle: 'Editorial planner · Flutter mockup · unlike Wireframe1/2',
    screens: {
      'Guest Home': AtelierScreens.guest,
      'Login': AtelierScreens.login,
      'OTP': AtelierScreens.otp,
      'Home': AtelierScreens.home,
      'Customer': AtelierScreens.customer,
      'Customer Detail': AtelierScreens.customerDetail,
      'Task Management': AtelierScreens.tasks,
    },
  ),
  MockupBranch(
    id: 'signal',
    title: 'Branch 2 · Signal',
    subtitle: 'Performance HUD · Flutter mockup · unlike Wireframe1/2',
    screens: {
      'Guest Home': SignalScreens.guest,
      'Login': SignalScreens.login,
      'OTP': SignalScreens.otp,
      'Home': SignalScreens.home,
      'Customer': SignalScreens.customer,
      'Customer Detail': SignalScreens.customerDetail,
      'Task Management': SignalScreens.tasks,
    },
  ),
  MockupBranch(
    id: 'grove',
    title: 'Branch 3 · Grove',
    subtitle: 'Guided trust · Flutter mockup · unlike Wireframe1/2',
    screens: {
      'Guest Home': GroveScreens.guest,
      'Login': GroveScreens.login,
      'OTP': GroveScreens.otp,
      'Home': GroveScreens.home,
      'Customer': GroveScreens.customer,
      'Customer Detail': GroveScreens.customerDetail,
      'Task Management': GroveScreens.tasks,
    },
  ),
];
