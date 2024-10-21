import 'dart:ffi' as ffi; // For FFI
import 'dart:io'; // For Platform check
import 'package:ffi/ffi.dart'; // For memory allocation

// Typedefs to define function signatures for CPU and RAM retrieval
typedef GetCpuUsageNative = ffi.Double Function();
typedef GetCpuUsage = double Function();

typedef GetMemoryInfoNative = ffi.Void Function(
    ffi.Pointer<ffi.Double>, ffi.Pointer<ffi.Double>);
typedef GetMemoryInfo = void Function(
    ffi.Pointer<ffi.Double>, ffi.Pointer<ffi.Double>);

class SystemMonitorFFI {
  late ffi.DynamicLibrary _lib;

  // Load the dynamic library based on platform (Android or Linux for testing)
  SystemMonitorFFI() {
    if (Platform.isAndroid) {
      _lib = ffi.DynamicLibrary.open('libcpu_info.so'); // For Android
    } else if (Platform.isLinux) {
      _lib =
          ffi.DynamicLibrary.open('./src/ffi/cpu_info.so'); // For Linux testing
    }
  }

  double getCpuUsage() {
    final GetCpuUsage getCpuUsage = _lib
        .lookup<ffi.NativeFunction<GetCpuUsageNative>>('get_cpu_usage')
        .asFunction();

    double usage = getCpuUsage();

    if (usage < 0) {
      // Handle error case or log it
      print('Error retrieving CPU usage, invalid value: $usage');
      // You can set a default value or return a known error
      usage = 0.0;
    }

    return usage;
  }

  // Fetch RAM information by calling native function
  Map<String, double> getMemoryInfo() {
    final GetMemoryInfo getMemoryInfo = _lib
        .lookup<ffi.NativeFunction<GetMemoryInfoNative>>('get_memory_info')
        .asFunction();

    // Use malloc to allocate memory for the returned total and free RAM values
    final ffi.Pointer<ffi.Double> totalRam = malloc<ffi.Double>();
    final ffi.Pointer<ffi.Double> freeRam = malloc<ffi.Double>();

    getMemoryInfo(totalRam, freeRam);

    final result = {
      'totalRam': totalRam.value,
      'freeRam': freeRam.value,
    };

    // Free the allocated memory
    malloc.free(totalRam);
    malloc.free(freeRam);

    return result;
  }
}
