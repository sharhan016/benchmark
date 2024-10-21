import 'package:better_cpu_reader/cpu_reader.dart';
import 'package:better_cpu_reader/cpuinfo.dart';

class CpuService {
  Future<CpuInfo> getCpuInfo() async {
    CpuInfo cpuInfo = await CpuReader.cpuInfo;
    return cpuInfo;
  }

  Future<int> getCoreFrequency(int coreNumber) async {
    try {
      int frequency = await CpuReader.getCurrentFrequency(coreNumber);
      return frequency;
    } catch (e) {
      print("Error fetching frequency for core $coreNumber: $e");
      return 0;
    }
  }

  Stream<CpuInfo> getCpuInfoStream() {
    return CpuReader.asStream(Duration(milliseconds: 1000));
  }
}
