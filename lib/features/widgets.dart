import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show Failure, AppRoute, FailureUIExtension;

abstract class GlobalWidget {
  static Widget errorView(Failure failure, BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: .center,
        mainAxisAlignment: .center,
        children: [
          Text(
            failure.toErrorMessage(context),
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.go(AppRoute.home),
            child: const Text('Go to Home'),
          ),
        ],
      ),
    );
  }

  static Widget loadingView() {
    return const Center(child: CircularProgressIndicator());
  }
}
