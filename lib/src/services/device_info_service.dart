import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<Map<String, dynamic>> getDeviceInfo() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        deviceData = {
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'version': getAndroidVersion(androidInfo.version.sdkInt),
          'hardware': androidInfo.hardware,
          'serial': androidInfo.serialNumber,
          'name': androidInfo.device,
          'brand': androidInfo.brand,
          'display': androidInfo.display,
          'product': androidInfo.product,
          'host': androidInfo.host,
          'tags': androidInfo.tags,
          'board': androidInfo.board,
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        deviceData = {
          'model': iosInfo.utsname.machine,
          'name': iosInfo.name,
          'systemVersion': getIOSVersion(iosInfo.systemVersion),
        };
      } else {
        deviceData = {'error': 'Unsupported platform'};
      }
    } catch (e) {
      deviceData = {'error': e.toString()};
    }

    return deviceData;
  }
}

String getAndroidVersion(int sdkInt) {
  switch (sdkInt) {
    case 34:
      return 'Android 14';
    case 33:
      return 'Android 13';
    case 32:
      return 'Android 12L';
    case 31:
      return 'Android 12';
    case 30:
      return 'Android 11';
    case 29:
      return 'Android 10';
    case 28:
      return 'Android 9 Pie';
    // Add more cases for older versions if needed
    default:
      return 'Unknown Android Version';
  }
}

String getIOSVersion(String systemVersion) {
  if (systemVersion.startsWith("16")) {
    return "iOS 16";
  } else if (systemVersion.startsWith("15")) {
    return "iOS 15";
  } else if (systemVersion.startsWith("14")) {
    return "iOS 14";
  } else if (systemVersion.startsWith("13")) {
    return "iOS 13";
  }
  // Add more cases as needed
  return "Unknown iOS Version";
}
