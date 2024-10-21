#include <sys/sysinfo.h>

// Function to get CPU usage (placeholder implementation for now)
double get_cpu_usage() {
    // Calculate CPU usage using system APIs (adjust this logic based on platform)
    return 45.0; // Placeholder value, replace with actual logic
}

// Function to get total and free RAM
void get_memory_info(double* total_ram, double* free_ram) {
    struct sysinfo info;
    sysinfo(&info);
    *total_ram = (double)info.totalram / (1024 * 1024); // Convert to MB
    *free_ram = (double)info.freeram / (1024 * 1024);   // Convert to MB
}