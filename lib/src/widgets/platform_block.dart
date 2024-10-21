import 'dart:io';

import 'package:flutter/material.dart';

class PlatformBlock extends StatelessWidget {
  final Map deviceInfo;
  const PlatformBlock({super.key, required this.deviceInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 200,
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
          const SizedBox(height: 10),
          Text(
            "${deviceInfo['version'] ?? "Unknown Hardware"}",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
