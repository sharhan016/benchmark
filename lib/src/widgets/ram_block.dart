import 'dart:async';

import 'package:benchmark/src/services/system_monitor_ffi.dart';
import 'package:flutter/material.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

class RamBlock extends StatefulWidget {
  const RamBlock({super.key});

  @override
  State<RamBlock> createState() => _RamBlockState();
}

class _RamBlockState extends State<RamBlock> {
  final SystemMonitorFFI _monitorFFI = SystemMonitorFFI();
  double _totalRam = 0.0;
  double _freeRam = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchSystemData();
    _startTimer();
  }

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchSystemData();
    });
  }

  void _fetchSystemData() {
    setState(() {
      final memoryInfo = _monitorFFI.getMemoryInfo();
      _totalRam = memoryInfo['totalRam']!;
      _freeRam = memoryInfo['freeRam']!;
    });
  }

  String formatRam(double ramInMb) {
    if (ramInMb >= 1024) {
      return '${(ramInMb / 1024).ceil() + 1} GB';
    } else {
      return '${ramInMb.toStringAsFixed(0)} MB';
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final double usedRamPercentage = ((_totalRam - _freeRam) / _totalRam);
    final theme = Theme.of(context);

    return Container(
      height: 350,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.primaryColor),
      ),
      child: Stack(
        children: [
          Transform.translate(
            offset: const Offset(-65, 100),
            child: Transform.rotate(
              angle: 1.5708,
              child: SemicircularIndicator(
                progress: usedRamPercentage,
                strokeCap: StrokeCap.square,
                color: theme.colorScheme.secondary,
                backgroundColor: theme.colorScheme.primary,
                radius: 150,
                bottomPadding: 0,
                child: Transform.rotate(
                  angle: -1.57,
                  child: Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text('RAM',
                          style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold)),
                      Text(
                        '${(usedRamPercentage * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      Text('Used', style: TextStyle(color: theme.primaryColor)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total RAM: ${formatRam(_totalRam)}',
                  style: TextStyle(fontSize: 18, color: theme.primaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  'Available RAM: ${formatRam(_freeRam)}',
                  style: TextStyle(fontSize: 18, color: theme.primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
