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
      // color: Colors.white24,
      child: Stack(
        children: [
          // Translated and rotated SemicircularIndicator on the left side
          Transform.translate(
            offset: const Offset(
                -65, 100), // Adjust offset to move the indicator to the left
            child: Transform.rotate(
              angle: 1.5708, // 90 degrees in radians (π/2 or 1.5708 radians)
              child: SemicircularIndicator(
                progress: usedRamPercentage,
                strokeCap: StrokeCap.square,
                color: theme.colorScheme.secondary,
                backgroundColor: theme.colorScheme.primary,
                // color: Colors.blueAccent,
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
          // RAM details on the right side
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
