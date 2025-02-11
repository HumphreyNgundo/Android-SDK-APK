import 'package:flutter/material.dart';
import 'EligibilityCheckCard.dart';
import 'device_info_bridge.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Info App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.contacts,
      Permission.sms,
      Permission.phone,
    ].request();

    statuses.forEach((permission, status) {
      print('$permission: $status');
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeSDK();
    _requestPermissions();
  }

  Future<void> _initializeSDK() async {
    await DeviceInfoBridge.initializeSDK('http://10.10.0.130:8083/nic_sasa_api/api/log');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Info App'),
        backgroundColor: Colors.blue,
      ),
      // Wrap the body in SingleChildScrollView and add EligibilityCheckCard
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Add the eligibility card at the top
            EligibilityCheckCard(),
            // Existing buttons wrapped in a Center widget
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                    onPressed: () async {
                      bool hasPermissions = await Permission.contacts.isGranted &&
                          await Permission.sms.isGranted &&
                          await Permission.phone.isGranted;

                      if (hasPermissions) {
                        await DeviceInfoBridge.logData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Data logged successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Permissions Required'),
                              content: Text('This app needs contacts, SMS, and phone permissions to function properly.'),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: Text('Request Permissions'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _requestPermissions();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      'Log Device Data',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                    onPressed: _requestPermissions,
                    child: Text(
                      'Request Permissions',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}