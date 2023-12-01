import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Position? _location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("위치값 확인 페이지"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                // await checkLocationEnabled();
              },
              child: const Text("현재 위치값 확인"),
            ),
            Text("현재 위치값: $_location"),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Future<void> getCurrentPostion() async {
    final position = await Geolocator.getCurrentPosition();
  }
}
