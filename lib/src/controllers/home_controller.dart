import 'package:benchmark/src/services/network_info_service.dart';
import 'package:benchmark/src/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:benchmark/src/services/device_info_service.dart';

class HomeController with ChangeNotifier {
  // Initialize services inside the class
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  final StorageService _storageService = StorageService();
  // bool to check if storage info is loaded
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
    fetchStorageInfo();
  }

  // Method to load device information
  Future<void> loadDeviceInfo() async {
    _deviceInfo = await _deviceInfoService.getDeviceInfo();
    notifyListeners(); // Notify listeners when device info is loaded
  }

  // Method to fetch storage information
  Future<void> fetchStorageInfo() async {
    storageInfoLoaded = false;
    storageInfo = await _storageService.getStorageInfo();
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
