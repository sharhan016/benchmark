#include <jni.h>
#include <sys/sysinfo.h>
#include <stdio.h>

// Function to get CPU usage
double get_cpu_usage() {
    FILE* file;
    unsigned long long total_user, total_user_low, total_sys, total_idle, total;
    static unsigned long long prev_total_user, prev_total_user_low, prev_total_sys, prev_total_idle;

    file = fopen("/proc/stat", "r");
    if (file == NULL) {
        perror("Error opening /proc/stat");
        return -1;
    }

    if (fscanf(file, "cpu %llu %llu %llu %llu", &total_user, &total_user_low, &total_sys, &total_idle) != 4) {
        perror("Error reading /proc/stat");
        fclose(file);
        return -1;
    }
    printf("user: %llu, user_low: %llu, sys: %llu, idle: %llu\n", total_user, total_user_low, total_sys, total_idle);
    fclose(file);

    printf("prev_user: %llu, prev_user_low: %llu, prev_sys: %llu, prev_idle: %llu\n", prev_total_user, prev_total_user_low, prev_total_sys, prev_total_idle);

    total = (total_user - prev_total_user) + (total_user_low - prev_total_user_low) +
            (total_sys - prev_total_sys);
    double percent = (double)(total) / (total + (total_idle - prev_total_idle));

    prev_total_user = total_user;
    prev_total_user_low = total_user_low;
    prev_total_sys = total_sys;
    prev_total_idle = total_idle;

    if (percent < 0 || percent > 1) {
        fprintf(stderr, "Calculated CPU usage out of range: %lf\n", percent);
        return -1;
    }

    return percent * 100; // Return CPU usage in percentage
}

// Function to get memory information (total and free RAM)
void get_memory_info(double* total_memory, double* free_memory) {
    struct sysinfo info;
    sysinfo(&info);

    *total_memory = (double)info.totalram / (1024 * 1024); // Total RAM in MB
    *free_memory = (double)info.freeram / (1024 * 1024); // Free RAM in MB
}