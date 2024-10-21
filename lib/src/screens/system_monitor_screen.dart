import 'package:flutter/material.dart';
import 'package:benchmark/src/services/system_monitor_ffi.dart';

class SystemMonitorScreen extends StatefulWidget {
  static const routeName = '/system-monitor';

  const SystemMonitorScreen({Key? key}) : super(key: key);

  @override
  _SystemMonitorScreenState createState() => _SystemMonitorScreenState();
}

class _SystemMonitorScreenState extends State<SystemMonitorScreen> {
  final SystemMonitorFFI _monitorFFI = SystemMonitorFFI();
  double _cpuUsage = 0.0;
  double _totalRam = 0.0;
  double _freeRam = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchSystemData();
  }

  void _fetchSystemData() {
    setState(() {
      _cpuUsage = _monitorFFI.getCpuUsage();
      final memoryInfo = _monitorFFI.getMemoryInfo();
      _totalRam = memoryInfo['totalRam']!;
      _freeRam = memoryInfo['freeRam']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benchmark - System Monitor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('CPU Usage: ${_cpuUsage.toStringAsFixed(2)}%'),
            const SizedBox(height: 20),
            Text('Total RAM: ${_totalRam.toStringAsFixed(2)} MB'),
            Text('Free RAM: ${_freeRam.toStringAsFixed(2)} MB'),
          ],
        ),
      ),
    );
  }
}
