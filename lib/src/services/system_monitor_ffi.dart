import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef GetCpuUsageNative = ffi.Double Function();
typedef GetCpuUsage = double Function();

typedef GetMemoryInfoNative = ffi.Void Function(
    ffi.Pointer<ffi.Double>, ffi.Pointer<ffi.Double>);
typedef GetMemoryInfo = void Function(
    ffi.Pointer<ffi.Double>, ffi.Pointer<ffi.Double>);

class SystemMonitorFFI {
  late ffi.DynamicLibrary _lib;

  SystemMonitorFFI() {
    if (Platform.isAndroid) {
      _lib = ffi.DynamicLibrary.open('libcpu_info.so');
    } else if (Platform.isLinux) {
      _lib = ffi.DynamicLibrary.open('./src/ffi/cpu_info.so');
    }
  }

  double getCpuUsage() {
    final GetCpuUsage getCpuUsage = _lib
        .lookup<ffi.NativeFunction<GetCpuUsageNative>>('get_cpu_usage')
        .asFunction();

    double usage = getCpuUsage();

    if (usage < 0) {
      print('Error retrieving CPU usage, invalid value: $usage');

      usage = 0.0;
    }

    return usage;
  }

  Map<String, double> getMemoryInfo() {
    final GetMemoryInfo getMemoryInfo = _lib
        .lookup<ffi.NativeFunction<GetMemoryInfoNative>>('get_memory_info')
        .asFunction();

    final ffi.Pointer<ffi.Double> totalRam = malloc<ffi.Double>();
    final ffi.Pointer<ffi.Double> freeRam = malloc<ffi.Double>();

    getMemoryInfo(totalRam, freeRam);

    final result = {
      'totalRam': totalRam.value,
      'freeRam': freeRam.value,
    };

    malloc.free(totalRam);
    malloc.free(freeRam);

    return result;
  }
}
