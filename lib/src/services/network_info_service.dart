import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:rxdart/rxdart.dart';

class NetworkInfoService {
  final Connectivity _connectivity = Connectivity();
  final NetworkInfo _networkInfo = NetworkInfo();
  final BehaviorSubject<Map<String, String>> _networkInfoSubject =
      BehaviorSubject<Map<String, String>>();

  Stream<Map<String, String>> get networkInfoStream =>
      _networkInfoSubject.stream;

  NetworkInfoService() {
    _initNetworkInfo();
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      for (ConnectivityResult result in results) {
        Map<String, String> networkInfo = await _getNetworkInfo(result);
        print("Network info: $networkInfo");
        _networkInfoSubject.add(networkInfo);
      }
    });
  }

  Future<void> _initNetworkInfo() async {
    final initialResult = await _connectivity.checkConnectivity();
    // final ConnectivityResult initialResult = initialResult.first;
    final initialNetworkInfo = await _getNetworkInfo(initialResult.first);
    _networkInfoSubject
        .add(initialNetworkInfo); // Emit the initial network info
  }

  Future<Map<String, String>> _getNetworkInfo(ConnectivityResult result) async {
    String connectionType = 'Offline';
    String wifiName = '-';
    String wifiBSSID = '-';
    String ipAddress = '-';

    if (result == ConnectivityResult.wifi) {
      connectionType = 'Wi-Fi';
      wifiName = await _networkInfo.getWifiName() ?? '-';
      wifiBSSID = await _networkInfo.getWifiBSSID() ?? '-';
      ipAddress = await _networkInfo.getWifiIP() ?? '-';
    } else if (result == ConnectivityResult.mobile) {
      connectionType = 'Mobile';
      ipAddress = await _networkInfo.getWifiIP() ?? 'Unknown';
    } else {
      connectionType = 'Offline';
    }

    return {
      'connectionType': connectionType,
      'wifiName': wifiName,
      'wifiBSSID': wifiBSSID,
      'ipAddress': ipAddress,
    };
  }

  void dispose() {
    _networkInfoSubject.close();
  }
}
/**
  NetworkInfoService() {
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      for (ConnectivityResult result in results) {
        Map<String, String> networkInfo = await _getNetworkInfo(result);
        print("Network info: $networkInfo");
        _networkInfoController.add(networkInfo);
      }
    });
  }
 */