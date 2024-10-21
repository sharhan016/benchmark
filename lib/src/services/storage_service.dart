import 'package:flutter_storage_info/flutter_storage_info.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageService {
  Future<Map<String, double>> getStorageInfo() async {
    try {
      // Request permission to access storage
      PermissionStatus status = await Permission.manageExternalStorage.status;
      print("Permission status: $status isGranted: ${status.isGranted}");
      if (status.isDenied) {
        // If permission is denied, request permission
        status = await Permission.manageExternalStorage.request();
        print(
            "Permission status after request: $status isPermanentlyDenied: ${status.isPermanentlyDenied} isRestricted: ${status.isRestricted}");
        if (status.isPermanentlyDenied) {
          // Show a dialog asking user to go to settings and manually enable the permission
          openAppSettings();
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
}
