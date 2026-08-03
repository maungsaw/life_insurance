import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_injection.dart' show AppInjection;
import 'package:life_insurance/features/features.dart';

class BlocDependencies extends StatelessWidget {
  final Widget child;

  const BlocDependencies({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppearanceBloc>(
          create: (context) =>
              AppInjection.sl<AppearanceBloc>()
                ..add(LoadSavedAppearanceEvent()),
        ),
      ],
      child: child,
    );
  }
}
