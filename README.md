# Benchmark

Benchmark is a real-time system monitoring application that helps you track various device metrics, such as CPU usage, memory utilization, storage, and network information.

## Getting Started

To set up this app locally on your machine for development or testing, please follow the steps below:

### Prerequisites

- **Flutter SDK**: Version 3.22.2 or higher.
- **Dart SDK**: Version 3.4.3 or higher.
- **Android/iOS Device**: API level 29 or higher (for Android), iOS 12.0+ for iOS devices.

### Installation

1. Clone the repository:
2. flutter pub get
3. flutter run

State Management:
  Provider

The app uses Provider for state management.

Folder Structure

	•	lib/services: Contains services responsible for fetching CPU, RAM, storage, and network data.
	•	lib/controllers: Contains controllers that handle business logic and interact with the services.
	•	lib/widgets: Custom UI widgets such as blocks for CPU, memory, storage, and network info.
	•	lib/screens: Contains all the main screens, including the Home screen.

 Packages Used

	•	provider: For state management.
	•	device_info_plus: To fetch detailed device information.
	•	connectivity_plus: To monitor network connection types.
	•	flutter_storage_info: To retrieve storage information.
	•	better_cpu_reader: For reading CPU metrics such as core frequencies and temperatures.




