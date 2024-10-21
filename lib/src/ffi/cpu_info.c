#include <sys/sysinfo.h>

 
double get_cpu_usage() {
     
    return 45.0;  
}

 
void get_memory_info(double* total_ram, double* free_ram) {
    struct sysinfo info;
    sysinfo(&info);
    *total_ram = (double)info.totalram / (1024 * 1024);  
    *free_ram = (double)info.freeram / (1024 * 1024);    
}