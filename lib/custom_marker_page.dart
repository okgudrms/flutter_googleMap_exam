import 'package:flutter/material.dart';
import 'package:lio_geolocation/custom_marker.dart';

class CustomMarkerPage extends StatefulWidget {
  const CustomMarkerPage({super.key});

  @override
  State<CustomMarkerPage> createState() => _CustomMarkerPageState();
}

class _CustomMarkerPageState extends State<CustomMarkerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("커스텀 마커 확인 페이지"),
      ),
      body: const CustomMarker(price: 100),
    );
  }
}
