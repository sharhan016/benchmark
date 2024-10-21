import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'dart:io';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  // checkProcStatAccess();
  runApp(MyApp(settingsController: settingsController));
}

void checkProcStatAccess() {
  try {
    File file = File('/proc/stat');
    if (file.existsSync()) {
      print("File exists and is accessible.");
    } else {
      print("File is restricted or doesn't exist.");
    }
  } catch (e) {
    print("Error accessing /proc/stat: $e");
  }
}
