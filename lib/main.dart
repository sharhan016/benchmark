import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'dart:io';

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();

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
