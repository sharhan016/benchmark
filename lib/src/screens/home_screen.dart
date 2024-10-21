import 'dart:io';

import 'package:benchmark/src/controllers/home_controller.dart';
import 'package:benchmark/src/services/device_info_service.dart';
import 'package:benchmark/src/settings/settings_controller.dart';
import 'package:benchmark/src/widgets/cpu_block.dart';
import 'package:benchmark/src/widgets/imei_block.dart';
import 'package:benchmark/src/widgets/network_block.dart';
import 'package:benchmark/src/widgets/platform_block.dart';
import 'package:benchmark/src/widgets/ram_block.dart';
import 'package:benchmark/src/widgets/storage_block.dart';
import 'package:benchmark/src/widgets/title_block.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home-screen';
  final SettingsController settingsController;
  const HomeScreen({super.key, required this.settingsController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController _homeController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final homeController = HomeController();
        homeController.loadDeviceInfo();
        homeController.fetchStorageInfo(context);
        return homeController;
      },
      child: Consumer<HomeController>(
        builder: (context, controller, _) {
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      TitleBlock(
                        title:
                            "${controller.deviceInfo['manufacturer'] ?? ""} ${controller.deviceInfo['model'] ?? "Unknown Model"}",
                        controller: widget.settingsController,
                      ),
                      const SizedBox(height: 8),
                      Stack(
                        children: [RamBlock(), NetworkBlock()],
                      ),
                      const SizedBox(height: 8),
                      if (controller.storageInfoLoaded)
                        StorageBlock()
                      else
                        const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 8),
                      CpuBlock(),
                      const SizedBox(height: 8),
                      PlatformBlock(deviceInfo: controller.deviceInfo),
                      const SizedBox(height: 8),
                      ImeiBlock(),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
