import 'package:flutter/material.dart';
import 'package:flutter_storage_info/flutter_storage_info.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageService {
  Future<Map<String, double>> getStorageInfo(BuildContext context) async {
    try {
      // Request permission to access storage
      PermissionStatus status = await Permission.manageExternalStorage.status;
      print("Permission status: $status isDenied: ${status.isDenied}");
      if (status.isDenied) {
        // If permission is denied, request permission
        final shouldOpenAppSettings = await _showPermissionDialog(context);
        if (shouldOpenAppSettings) {
          status = await Permission.manageExternalStorage.request();
        }

        print(
            "Permission status after request: $status isPermanentlyDenied: ${status.isPermanentlyDenied} isRestricted: ${status.isRestricted}");
        if (status.isPermanentlyDenied) {
          final shouldOpenAppSettings = await _showPermissionDialog(context);
          if (shouldOpenAppSettings) {
            openAppSettings();
          }
        }
      }

      final totalSpace =
          (await FlutterStorageInfo.getStorageTotalSpaceInGB).ceilToDouble();
      final freeSpace =
          (await FlutterStorageInfo.getStorageFreeSpaceInGB).ceilToDouble();
      final usedSpace = (totalSpace - freeSpace).ceilToDouble();

      return {
        'totalSpace': totalSpace,
        'freeSpace': freeSpace,
        'usedSpace': usedSpace,
      };
    } catch (e) {
      return {
        'error': 0.0,
      };
    }
  }

  Future<bool> _showPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Permission required'),
              content: const Text(
                  'This app requires Files permission to fetch the storage related information. Do you want to allow this permission?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Deny'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Allow'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
