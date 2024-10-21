import 'package:benchmark/src/packages/progress_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';

class StorageBlock extends StatelessWidget {
  const StorageBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);
    final totalSpace = controller.storageInfo['totalSpace']?.ceil() ?? 0;
    final freeSpace = controller.storageInfo['freeSpace']?.ceil() ?? 0;
    final usedSpace = (totalSpace - freeSpace).ceil();
    print(
        'totalSpace: $totalSpace, freeSpace: $freeSpace, usedSpace: $usedSpace');

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      height: 150,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total Storage: ${totalSpace.toStringAsFixed(0)} GB'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProgressBarChart(
              values: [
                StatisticsItem(Colors.red, usedSpace.toDouble(),
                    title: 'Used', titleColor: Colors.white),
                StatisticsItem(Colors.green, freeSpace.toDouble(),
                    title: 'Free', titleColor: Colors.white),
              ],
              height: 30,
              borderRadius: 10,
              totalPercentage: totalSpace.toDouble(),
              unitLabel: 'GB',
              showLables: true,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Free'),
              const SizedBox(width: 8),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Used')
            ]),
          ),
        ],
      ),
    );
  }
}
