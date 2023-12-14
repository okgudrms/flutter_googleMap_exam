import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lio_geolocation/custom_marker.dart';
import 'package:lio_geolocation/custom_marker_2.dart';
import 'package:http/http.dart' as http;

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

class MarkerAutoCompletePage extends StatefulWidget {
  const MarkerAutoCompletePage({super.key});

  @override
  State<MarkerAutoCompletePage> createState() => _MarkerAutoCompletePageState();
}

class _MarkerAutoCompletePageState extends State<MarkerAutoCompletePage> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const CameraPosition _kAllMyTour = CameraPosition(
    target: LatLng(37.572621498212285, 126.99864593451068),
    zoom: 15.4746,
  );

  final Map<String, Marker> _markers = {};

  final TextEditingController _googlePlaceTextController =
      TextEditingController();

  List<dynamic> _placeList = [];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _googlePlaceTextController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                _mapController.complete(controller);
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _googlePlaceTextController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  fillColor: ui.Color.fromARGB(255, 225, 225, 225),
                  filled: true,
                  border: InputBorder.none,
                  hintText: "장소를 검색해보세요.",
                ),
                onChanged: (value) async {
                  //debounce 처리
                  if (_debounce?.isActive ?? false) _debounce?.cancel();
                  _debounce =
                      Timer(const Duration(milliseconds: 500), () async {
                    await _getGooglePlaceAutoComplete(value);
                  });
                },
              ),
            ),
          ],
        ),
      ),
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

  Future<void> _getGooglePlaceAutoComplete(String text) async {
    String key = 'AIzaSyDHL3YPSbSqlWPh7stO_56dsbhtqf2jJ1s';
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String url =
        '$baseUrl?input=$text&language=ko&types=landmark|point_of_interest&key=$key';

    final resp = await http.get(Uri.parse(url));

    print(resp.body);
    if (resp.statusCode == 200) {
      _placeList = jsonDecode(resp.body.toString());
    } else {
      print("구글플레이스 검색 실패");
      throw Exception("구글플레이스 검색 실패");
    }
  }
}
