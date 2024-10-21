import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CpuInfoScreen extends StatefulWidget {
  static const routeName = '/system-monitor';

  @override
  _CpuInfoScreenState createState() => _CpuInfoScreenState();
}

class _CpuInfoScreenState extends State<CpuInfoScreen> {
  static const platform = MethodChannel('cpu_info_channel');
  String _cpuTemp = 'Unknown';

  @override
  void initState() {
    super.initState();
    _getCpuTemperature();
  }

  Future<void> _getCpuTemperature() async {
    try {
      final double temp = await platform.invokeMethod('getCpuTemperatures');
      setState(() {
        _cpuTemp = '$temp °C';
      });
    } on PlatformException catch (e) {
      setState(() {
        _cpuTemp = "Failed to get CPU temperature: '${e.message}'";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CPU Info")),
      body: Center(
        child: Text("CPU Temperature: $_cpuTemp"),
      ),
    );
  }
}
