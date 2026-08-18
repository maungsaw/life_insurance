import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/core/themes/app_theme.dart';

void main() {
  test('global action feedback uses motion ripple, not sticky hover', () {
    final light = AppTheme.lightTheme;
    final dark = AppTheme.darkTheme;

    expect(light.splashFactory, InkRipple.splashFactory);
    expect(dark.splashFactory, InkRipple.splashFactory);
    expect(light.splashColor.a, lessThan(dark.splashColor.a));

    expect(light.highlightColor, Colors.transparent);
    expect(dark.highlightColor, Colors.transparent);
    expect(light.hoverColor, Colors.transparent);
    expect(dark.hoverColor, Colors.transparent);

    final lightIconOverlay = light.iconButtonTheme.style?.overlayColor?.resolve({
      WidgetState.pressed,
    });
    final darkIconOverlay = dark.iconButtonTheme.style?.overlayColor?.resolve({
      WidgetState.pressed,
    });
    expect(lightIconOverlay, isNotNull);
    expect(darkIconOverlay, isNotNull);
    expect(lightIconOverlay, isNot(Colors.transparent));
    expect(darkIconOverlay, isNot(Colors.transparent));
  });
}
