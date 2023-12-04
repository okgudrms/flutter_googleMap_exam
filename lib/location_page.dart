import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Position? _location;
  Position? _lastLocation;
  Position? _streamLocation;
  late StreamSubscription<Position> _subLocationStream;

  @override
  void initState() {
    getPositionStream();
    super.initState();
  }

  @override
  void dispose() {
    _subLocationStream.cancel();
    super.dispose();
  }

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
                await getCurrentPostion();
              },
              child: const Text("현재 위치값 확인"),
            ),
            Text("현재 위치값: $_location"),
            const Divider(),
            TextButton(
              onPressed: () async {
                await getLastKnownPosition();
              },
              child: const Text("마지막 위치값 확인"),
            ),
            Text("마지막 위치값: $_lastLocation"),
            const Divider(),
            TextButton(
              onPressed: () async {
                getPositionStream();
              },
              child: const Text("현재 위치 스트림 시작"),
            ),
            Text("스트림 위치값: $_streamLocation"),
            const Divider(),
          ],
        ),
      ),
    );
  }

  ///현재 장치의 위치값 확인 함수.
  ///
  ///desiredAccuracy : 위치의 정확도(enum)
  ///forceAndroidLocationManager : 안드로이드 위치 api 선택에 관한 파라미터, 안바꾸는게 좋음
  ///timeLimit : 위치값 수신 및 계산까지의 제한시간, 이 시간을 넘으면, 에러
  Future<void> getCurrentPostion() async {
    final Position location = await Geolocator.getCurrentPosition();
    setState(() {
      _location = location;
    });
  }

  Future<void> getLastKnownPosition() async {
    final Position? lastLocation = await Geolocator.getLastKnownPosition();
    setState(() {
      if (lastLocation != null) {
        _lastLocation = lastLocation;
      }
    });
  }

  void getPositionStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );
    _subLocationStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) {
      setState(() {
        _streamLocation = position;
      });
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
    }, onError: (error) {
      print(error);
    }, onDone: () {
      print("위치스트림 끝!");
    });
  }
}
