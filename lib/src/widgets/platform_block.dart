import 'dart:io';

import 'package:flutter/material.dart';

class PlatformBlock extends StatelessWidget {
  final Map<String, dynamic> deviceInfo;
  const PlatformBlock({super.key, required this.deviceInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Image.asset(
              Platform.isAndroid
                  ? "assets/images/android-icon.png"
                  : "assets/images/ios-icon.png",
              height: 150,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Model: ${deviceInfo['model'] ?? 'Unknown'}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Manufacturer: ${deviceInfo['manufacturer'] ?? '-'}",
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Version: ${deviceInfo['version'] ?? '-'}",
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Hardware: ${deviceInfo['hardware'] ?? '-'}",
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Device Name: ${deviceInfo['name'] ?? '-'}",
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Display: ${deviceInfo['display'] ?? '-'}",
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
