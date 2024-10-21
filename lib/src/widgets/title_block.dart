import 'package:benchmark/src/settings/settings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class TitleBlock extends StatelessWidget {
//   final String title;
//   const TitleBlock({required this.title, super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Container(
//       height: 100,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//           border: Border.all(color: theme.primaryColor),
//           borderRadius: BorderRadius.circular(8)),
//       child: Center(
//         child: Text(title),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
// import 'settings_controller.dart';

class TitleBlock extends StatelessWidget {
  final String title;
  final SettingsController controller;

  const TitleBlock({required this.title, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              title,
              style: TextStyle(color: theme.primaryColor),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 16.0),
          //   child: DropdownButton<ThemeMode>(
          //     value: controller.themeMode,
          //     onChanged: controller.updateThemeMode,
          //     items: const [
          //       DropdownMenuItem(
          //         value: ThemeMode.system,
          //         child: Text('System Theme'),
          //       ),
          //       DropdownMenuItem(
          //         value: ThemeMode.light,
          //         child: Text('Light Theme'),
          //       ),
          //       DropdownMenuItem(
          //         value: ThemeMode.dark,
          //         child: Text('Dark Theme'),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoSwitch(
                  value: controller.themeMode == ThemeMode.dark,
                  activeColor: theme.primaryColor,
                  onChanged: (bool isDarkMode) {
                    if (isDarkMode) {
                      controller.updateThemeMode(ThemeMode.dark);
                    } else {
                      controller.updateThemeMode(ThemeMode.light);
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
