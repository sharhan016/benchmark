// import 'package:better_cpu_reader/cpu_reader.dart';
// import 'package:better_cpu_reader/cpuinfo.dart';
// import 'dart:async';

// class CpuService {
//   final StreamController<CpuInfo> _cpuInfoController =
//       StreamController<CpuInfo>.broadcast();

//   Stream<CpuInfo> get cpuInfoStream => _cpuInfoController.stream;

//   void startMonitoring() {
//     CpuReader.asStream(Duration(milliseconds: 1000)).listen((cpuInfo) {
//       _cpuInfoController.add(cpuInfo);
//     });
//   }

//   void dispose() {
//     _cpuInfoController.close();
//   }
// }

import 'package:better_cpu_reader/cpu_reader.dart';
import 'package:better_cpu_reader/cpuinfo.dart';

class CpuService {
  // Fetches the CPU info such as number of cores, frequencies, and temperature.
  Future<CpuInfo> getCpuInfo() async {
    CpuInfo cpuInfo = await CpuReader.cpuInfo;
    return cpuInfo;
  }

  // This function fetches the frequency of a specific core
  Future<int> getCoreFrequency(int coreNumber) async {
    try {
      int frequency = await CpuReader.getCurrentFrequency(coreNumber);
      return frequency;
    } catch (e) {
      print("Error fetching frequency for core $coreNumber: $e");
      return 0;
    }
  }

  // Stream for continuous updates
  Stream<CpuInfo> getCpuInfoStream() {
    return CpuReader.asStream(Duration(milliseconds: 1000));
  }
}
