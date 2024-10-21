import 'dart:async';
import 'package:benchmark/src/services/cpu_info_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:better_cpu_reader/cpuinfo.dart';
// import '../services/cpu_service.dart';

class CpuBlock extends StatefulWidget {
  const CpuBlock({super.key});

  @override
  State<CpuBlock> createState() => _CpuBlockState();
}

class _CpuBlockState extends State<CpuBlock> {
  late CpuService _cpuService;
  late StreamSubscription<CpuInfo> _cpuInfoSubscription;
  CpuInfo? _cpuInfo;

  @override
  void initState() {
    super.initState();
    _cpuService = CpuService();

    // Listen to the stream and update the CPU info
    _cpuInfoSubscription = _cpuService.getCpuInfoStream().listen((cpuInfo) {
      setState(() {
        _cpuInfo = cpuInfo;
      });
    });
  }

  @override
  void dispose() {
    _cpuInfoSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cpuInfo == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'CPU Information',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16.0),
          _buildCpuUsagePieChart(theme),
          const SizedBox(height: 16.0),
          _buildCoreInfo(theme),
        ],
      ),
    );
  }

  // Widget to display core information with temperature
  Widget _buildCoreInfo(ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _cpuInfo?.numberOfCores ?? 0,
      itemBuilder: (context, index) {
        return FutureBuilder<int>(
          future: _cpuService.getCoreFrequency(index),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final coreFrequency = snapshot.data ?? 0;
            return Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Core ${index + 1}',
                    style: TextStyle(color: theme.primaryColor),
                  ),
                  Text('${coreFrequency} MHz'), //Frequency:
                  Text(
                    'Temperature: ${_cpuInfo?.cpuTemperature.toStringAsFixed(1)}°C',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCpuUsagePieChart(ThemeData theme) {
    double totalFrequency = 0.0;
    double maxFrequency = 0.0;

    // Summing current frequencies and max frequencies for usage calculation
    _cpuInfo?.currentFrequencies.forEach((core, freq) {
      totalFrequency += freq;
      maxFrequency += _cpuInfo?.minMaxFrequencies[core]?.max ?? 0;
    });

    double usagePercentage =
        maxFrequency > 0 ? (totalFrequency / maxFrequency) * 100 : 0;

    return PieChart(
      dataMap: {
        'Used': usagePercentage,
        'Free': 100 - usagePercentage,
      },
      colorList: [Colors.blueAccent, Colors.grey],
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 2.5,
      centerText: 'Usage',
      legendOptions: const LegendOptions(showLegends: false),
      chartValuesOptions:
          const ChartValuesOptions(showChartValuesInPercentage: true),
    );
  }
}
