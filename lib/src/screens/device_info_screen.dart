import 'package:benchmark/src/services/device_info_service.dart';
import 'package:flutter/material.dart';

class DeviceInfoScreen extends StatefulWidget {
  static const route = '/device-info';
  @override
  _DeviceInfoScreenState createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  Map<String, dynamic> _deviceInfo = {};

  @override
  void initState() {
    super.initState();
    _fetchDeviceInfo();
  }

  Future<void> _fetchDeviceInfo() async {
    final info = await _deviceInfoService.getDeviceInfo();
    setState(() {
      _deviceInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device Info')),
      body: _deviceInfo.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: _deviceInfo.entries.map((entry) {
                return ListTile(
                  title: Text('${entry.key}: ${entry.value}'),
                );
              }).toList(),
            ),
    );
  }
}
