import 'package:flutter/material.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
import 'package:nb_optimization_flutter/optimization_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'full_navigation_example.dart';
import 'optimize_route_provider.dart';
import 'step_info_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static const String accessKey = String.fromEnvironment("ACCESS_KEY");

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    NextBillion.initNextBillion(MyApp.accessKey);
    NextBillionOptimization.initialize(MyApp.accessKey);
    _tabController =
        TabController(length: 2, vsync: this); // Define the number of tabs
    checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OptimizeRouteProvider>.value(
            value: OptimizeRouteProvider()),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Optimize Route Example'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Map'),
                Tab(text: 'Step Info'),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: const [
              FullNavigationExample(),
              StepInfoPage(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void checkPermissions() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await [Permission.location].request();
    }
  }
}
