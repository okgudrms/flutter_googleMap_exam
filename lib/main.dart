import 'package:flutter/material.dart';
import 'package:lio_geolocation/google_map_page.dart';
import 'package:lio_geolocation/location_page.dart';
import 'package:lio_geolocation/marker_page.dart';
import 'package:lio_geolocation/request_permission_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Lio's Geolocation"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RequestPermissionPage(),
                  ),
                );
              },
              child: const Text(
                "위치권한 상태 및 요청 페이지",
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LocationPage(),
                  ),
                );
              },
              child: const Text(
                "위치값 확인 페이지",
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const GoogleMapPage(),
                  ),
                );
              },
              child: const Text(
                "구글맵 페이지",
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MarkerPage(),
                  ),
                );
              },
              child: const Text(
                "마커 페이지",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
