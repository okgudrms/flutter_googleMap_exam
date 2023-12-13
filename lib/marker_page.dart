import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lio_geolocation/custom_marker.dart';
import 'package:lio_geolocation/custom_marker_2.dart';

List<Map<String, dynamic>> data = [
  {
    'id': '1',
    'position': const LatLng(37.572621471425286, 126.99864596128465),
    'price': 1000.0,
  },
  {
    'id': '2',
    'position': const LatLng(38.572621471425286, 126.99864596128465),
    'price': 2000.0,
    'widget': const CustomMarker(price: 200),
  },
  {
    'id': '3',
    'position': const LatLng(37.572621471425286, 125.99864596128465),
    'price': 3000.0,
  }
];

class MarkerPage extends StatefulWidget {
  const MarkerPage({super.key});

  @override
  State<MarkerPage> createState() => _MarkerPageState();
}

class _MarkerPageState extends State<MarkerPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kAllMyTour = CameraPosition(
    target: LatLng(37.572621498212285, 126.99864593451068),
    zoom: 15.4746,
  );

  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              for (int i = 0; i < data.length; i++)
                Transform.translate(
                  offset: Offset(
                    -MediaQuery.of(context).size.width * 2,
                    -MediaQuery.of(context).size.width * 2,
                  ),
                  child: CustomMarker2(
                    onFinishRendering:
                        (GlobalKey<State<StatefulWidget>> globalKey) async {
                      await _createMarkers(globalKey, data[i]);
                      setState(() {});
                    },
                    price: data[i]['price'] as double,
                  ),
                )
            ],
          ),
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kAllMyTour,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            onTap: (LatLng argument) {},
            onCameraMoveStarted: () {
              print("카메라 이동 스타트");
            },
            onCameraMove: (CameraPosition position) {
              print("카메라 이동 : $position");
            },
            onCameraIdle: () {
              print("카메라 이동 ended");
            },
            markers: _markers.values.toSet(),
          ),
        ],
      ),
      // : ListView(
      //     children: [
      //       for (int i = 0; i < data.length; i++)
      //         Transform.translate(
      //           offset: Offset(
      //             -MediaQuery.of(context).size.width * 2,
      //             -MediaQuery.of(context).size.width * 2,
      //           ),
      //           child: RepaintBoundary(
      //             key: data[i]['globalKey'],
      //             child: data[i]['widget'],
      //           ),
      //         )
      //     ],
      //   ),
    );
  }

  // 위젯을 이미지로 변환하는 함수
  Future<Uint8List> _convertWidgetToImage(GlobalKey key) async {
    RenderRepaintBoundary boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // 구글 맵 마커 생성
  Future<void> _createMarkers(GlobalKey key, Map<String, dynamic> data) async {
    Uint8List markerImage = await _convertWidgetToImage(key);
    BitmapDescriptor widgetBitmapDescriptor =
        BitmapDescriptor.fromBytes(markerImage);
    Marker marker = Marker(
      markerId: MarkerId(data['id']),
      position: data['position'],
      icon: widgetBitmapDescriptor,
    );
    // 마커를 맵에 추가하는 로직
    _markers[marker.markerId.value] = marker;
  }
}
