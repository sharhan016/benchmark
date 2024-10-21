import 'package:benchmark/src/services/network_info_service.dart';
import 'package:benchmark/src/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:benchmark/src/services/device_info_service.dart';

class HomeController with ChangeNotifier {
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  final StorageService _storageService = StorageService();

  bool storageInfoLoaded = false;

  final NetworkInfoService _networkInfoService = NetworkInfoService();

  Map<String, dynamic> _deviceInfo = {};
  Map<String, dynamic> get deviceInfo => _deviceInfo;
  Map<String, String> get networkInfo => _networkInfo;

  Map<String, double> storageInfo = {
    'totalSpace': 0.0,
    'freeSpace': 0.0,
    'usedSpace': 0.0,
  };

  Map<String, String> _networkInfo = {
    'connectionType': 'Unknown',
    'wifiName': 'Unknown',
    'wifiBSSID': 'Unknown',
    'ipAddress': 'Unknown',
  };

  HomeController() {
    _networkInfoService.networkInfoStream.listen((networkInfoData) {
      _networkInfo = networkInfoData;
      notifyListeners();
    });
  }

  Future<void> loadDeviceInfo() async {
    _deviceInfo = await _deviceInfoService.getDeviceInfo();
    notifyListeners();
  }

  Future<void> fetchStorageInfo(BuildContext context) async {
    storageInfoLoaded = false;
    storageInfo = await _storageService.getStorageInfo(context);
    storageInfoLoaded = true;
    print(storageInfo);
    notifyListeners();
  }

  @override
  void dispose() {
    _networkInfoService.dispose();
    super.dispose();
  }
}
