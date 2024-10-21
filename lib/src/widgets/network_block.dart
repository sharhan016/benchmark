import 'package:benchmark/src/services/network_info_service.dart';
import 'package:flutter/material.dart';

class NetworkBlock extends StatelessWidget {
  final NetworkInfoService _networkInfoService = NetworkInfoService();
  NetworkBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      right: 0,
      // top: 40,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        height: 150,
        width: MediaQuery.of(context).size.width / 2.5,
        child: StreamBuilder<Map<String, String>>(
          stream: _networkInfoService.networkInfoStream,
          builder: (context, snapshot) {
            print('snapshot: $snapshot');
            if (!snapshot.hasData) {
              return Text('Loading...');
            }

            final networkInfo = snapshot.data!;
            final connectionType = networkInfo['connectionType'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (connectionType == 'Wi-Fi') _buildIcon(Icons.wifi, context),
                if (connectionType == 'Mobile')
                  _buildIcon(Icons.cell_tower, context),
                if (connectionType == 'Offline')
                  _buildIcon(Icons.wifi_off, context),
                const SizedBox(height: 10),
                Text('Connection Type: ${networkInfo['connectionType']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.primaryColor)),
                if (networkInfo['wifiName'] != '-')
                  Text(
                    'Wi-Fi Name: ${networkInfo['wifiName']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.primaryColor),
                  ),
                Text(
                  'IP Address: ${networkInfo['ipAddress']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.primaryColor),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, BuildContext context) {
    return Center(
      child: Icon(
        icon,
        size: 50,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
