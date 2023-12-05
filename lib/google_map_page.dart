import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  String? newMapStyle;
  final GlobalKey _mapKey = GlobalKey();

  @override
  void initState() {
    DefaultAssetBundle.of(context)
        .loadString('assets/map_style1.json')
        .then((value) {
      newMapStyle = value;
    });
    super.initState();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kAllMyTour = CameraPosition(
    target: LatLng(37.572621498212285, 126.99864593451068),
    zoom: 15.4746,
  );

  static const CameraPosition _kInterNatrang = CameraPosition(
    target: LatLng(12.244911658243838, 109.19602863441287),
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: GoogleMap(
                key: _mapKey,
                mapType: MapType.normal,
                initialCameraPosition: _kAllMyTour,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                zoomControlsEnabled: false,
                onTap: (argument) {},
              ),
            ),
            Flexible(
              flex: 1,
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                children: [
                  _button(
                    title: "Controller animateCamera",
                    onPressed: _animateCamera,
                  ),
                  _button(
                    title: "Controller moveCamera",
                    onPressed: _moveCamera,
                  ),
                  _button(
                    title: "Controller setMapStyle",
                    onPressed: _setMapStyle,
                  ),
                  _button(
                    title: "Controller takeSnapshot",
                    onPressed: _takeSnapshot,
                  ),
                  _button(
                    title: "Controller getMapData",
                    onPressed: _getMapData,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _button({
    required String title,
    required void Function()? onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }

  Future<void> _animateCamera() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_kInterNatrang));
  }

  Future<void> _moveCamera() async {
    final GoogleMapController controller = await _controller.future;
    await controller.moveCamera(CameraUpdate.newCameraPosition(_kInterNatrang));
  }

  Future<void> _setMapStyle() async {
    final GoogleMapController controller = await _controller.future;
    await controller.setMapStyle(newMapStyle);
  }

  Future<void> _takeSnapshot() async {
    final GoogleMapController controller = await _controller.future;
    final snapshot = await controller.takeSnapshot();
    if (snapshot != null) {
      _showDialog(text: "스크린샷이 찍혔습니다. 데이터 형태는 Uint8List, 이미지 바이트입니다.");
    }
  }

  Future<void> _showDialog({required String text}) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: Text(text),
        );
      },
    );
  }

  Size _getMapSize() {
    final mapBox = _mapKey.currentContext?.findRenderObject() as RenderBox;
    final mapSize = mapBox.size;
    return mapSize;
  }

  Future<ScreenCoordinate> _getScreenCoordinate(
      {required LatLng latLng}) async {
    final GoogleMapController controller = await _controller.future;
    final coordinate = await controller.getScreenCoordinate(latLng);
    return coordinate;
  }

  Future<LatLng> _getLatLng(
      {required ScreenCoordinate screenCoordinate}) async {
    final GoogleMapController controller = await _controller.future;
    final latLng = controller.getLatLng(screenCoordinate);
    return latLng;
  }

  Future<void> _getMapData() async {
    final GoogleMapController controller = await _controller.future;

    final mapSize = _getMapSize();
    final screenCoordinate = ScreenCoordinate(
      x: (mapSize.width / 2).round(),
      y: (mapSize.height / 2).round(),
    );
    print(screenCoordinate);

    final latLng = await _getLatLng(screenCoordinate: screenCoordinate);
    final mapScreenCoordinate = await _getScreenCoordinate(latLng: latLng);
    final zoomLevel = await controller.getZoomLevel();
    final visibleRegion = await controller.getVisibleRegion();

    _showDialog(
        text:
            "지도 정중앙 데이터\nScreenCoordinate : $mapScreenCoordinate\nLatLng : $latLng\nZoomLevel : $zoomLevel\nVisibleRegion : $visibleRegion");
  }
}
