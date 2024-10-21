import 'package:benchmark/src/services/imei_info_service.dart';
import 'package:flutter/material.dart';

class ImeiBlock extends StatefulWidget {
  const ImeiBlock({Key? key}) : super(key: key);

  @override
  _ImeiBlockState createState() => _ImeiBlockState();
}

class _ImeiBlockState extends State<ImeiBlock> {
  String imeiNumber = 'Loading...';
  final ImeiService _imeiService = ImeiService();

  @override
  void initState() {
    super.initState();
    _fetchImei();
  }

  Future<void> _fetchImei() async {
    String? fetchedImei = await _imeiService.getImei(context);
    if (fetchedImei != null && mounted) {
      setState(() {
        imeiNumber = fetchedImei;
      });
    } else {
      setState(() {
        imeiNumber = 'Failed to get IMEI';
      });
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("IMEI Info")),
  //     body: Center(
  //       child: ImeiBlock(imeiNumber: imeiNumber),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'IMEI: $imeiNumber',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
