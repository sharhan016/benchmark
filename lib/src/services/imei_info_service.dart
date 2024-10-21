import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class ImeiService {
  static const platform = MethodChannel('benchmark-imei');
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<String?> getImei(BuildContext context) async {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 29) {
      return await _getDeviceSerialNumber(context);
    } else {
      return await _getImeiForOlderVersions(context);
    }
  }

  Future<String?> _getDeviceSerialNumber(BuildContext context) async {
    try {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      String serialNumber = androidInfo.serialNumber ?? 'Unknown';
      return serialNumber;
    } catch (e) {
      print('Failed to get serial number: $e');
      return null;
    }
  }

  Future<String?> _getImeiForOlderVersions(BuildContext context) async {
    PermissionStatus status = await Permission.phone.status;

    if (status != PermissionStatus.granted) {
      final bool shouldRequest = await _showPermissionDialog(context);
      if (shouldRequest) {
        status = await Permission.phone.request();
      }
    }

    if (status == PermissionStatus.granted) {
      try {
        final String? imei = await platform.invokeMethod('getImei');
        return imei;
      } catch (e) {
        print('Failed to get IMEI: $e');
        return null;
      }
    } else {
      return null;
    }
  }

  Future<bool> _showPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Permission required'),
              content: const Text(
                  'This app requires phone permission to fetch the IMEI number. Do you want to allow this permission?'),
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
