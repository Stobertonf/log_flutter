import 'package:flutter/material.dart';
import 'package:log_flutter/core/widgets/animations/animations.dart';

enum SnackBarType { success, error, warning }

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    required SnackBarType type,
  }) {
    final overlay = Overlay.of(context);

    Color backgroundColor = switch (type) {
      SnackBarType.success => Colors.green,
      SnackBarType.error => Colors.red,
      SnackBarType.warning => Colors.orange,
    };

    final entry = OverlayEntry(
      builder: (_) => SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Animations(
            duration: 300,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(
                        0,
                        -2,
                      ),
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(
      const Duration(seconds: 3),
      () {
        entry.remove();
      },
    );
  }
}
