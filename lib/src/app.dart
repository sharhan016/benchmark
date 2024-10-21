import 'package:benchmark/src/controllers/home_controller.dart';
import 'package:benchmark/src/screens/device_info_screen.dart';
import 'package:benchmark/src/screens/home_screen.dart';
import 'package:benchmark/src/screens/system_monitor_screen.dart';
import 'package:benchmark/src/utils/color_theme.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/cpu_info_screen.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
      ],
      child: ListenableBuilder(
        listenable: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            restorationScopeId: 'app',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: AppColorTheme.light,
            darkTheme: AppColorTheme.dark,
            themeMode: settingsController.themeMode,
            initialRoute: HomeScreen.route,
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return SettingsView(controller: settingsController);
                    case SystemMonitorScreen.routeName:
                      return SystemMonitorScreen();
                    case DeviceInfoScreen.route:
                      return DeviceInfoScreen();
                    case HomeScreen.route:
                      return HomeScreen(
                        settingsController: settingsController,
                      );
                    default:
                      return SettingsView(controller: settingsController);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
