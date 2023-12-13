import 'package:flutter/material.dart';
import 'package:lio_geolocation/custom_marker.dart';

class CustomMarker2 extends StatefulWidget {
  const CustomMarker2(
      {super.key, required this.onFinishRendering, required this.price});
  final void Function(GlobalKey globalKey) onFinishRendering;
  final double price;

  @override
  State<CustomMarker2> createState() => _CustomMarker2State();
}

class _CustomMarker2State extends State<CustomMarker2> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTheMarker();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: CustomMarker(
        price: widget.price,
      ),
    );
  }

  Future<void> loadTheMarker() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onFinishRendering(_globalKey);
    });
  }
}
