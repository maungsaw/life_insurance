import 'package:flutter/material.dart';

abstract class AppRoot {
  static final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();
  static final navigationIcons = [
    Icons.home_max,
    Icons.integration_instructions_sharp,
    Icons.person,
  ];
}
