import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RequestPermissionPage extends StatefulWidget {
  const RequestPermissionPage({super.key});

  @override
  State<RequestPermissionPage> createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage> {
  LocationPermission? _permission;
  bool? _locationEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("위치권한 요청 페이지"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                await checkLocationEnabled();
              },
              child: const Text("위치 권한 서비스 가능여부 체크"),
            ),
            Text("위치 서비스 가능여부: $_locationEnabled"),
            const Divider(),
            TextButton(
              onPressed: () async {
                await checkPermission();
              },
              child: const Text("현재 위치권한 체크"),
            ),
            Text("현재 위치 권한 : $_permission"),
            const Divider(),
            TextButton(
              onPressed: () async {
                await requestLocationPermission();
              },
              child: const Text("현재 위치권한 요청"),
            ),
            const Divider(),
            TextButton(
              onPressed: () async {
                await openAppSetting();
              },
              child: const Text("앱 설정 열기"),
            ),
          ],
        ),
      ),
    );
  }

  ///위치권한 상태를 확인하는 함수
  ///- enum 타입으로, 위치권한 상태를 알려준다.
  ///- denied : 기본 default 상태, 위치권한 요청에서 [한 번 허용]을 선택한 상태
  ///- deniedForever : 위치권한 요청에서 거절을 한 상태
  ///- always : 백그라운드 상태에서도 위치를 사용하는 상태
  ///- whileInUse : 위치권한 요청에서 [앱을 사용하는 동안 허용]을 선택한 상태
  Future<void> checkPermission() async {
    final LocationPermission permission = await Geolocator.checkPermission();

    setState(() {
      _permission = permission;
    });
  }

  ///위치 서비스를 사용할 수 있는지 확인하는 함수.
  ///위치 서비스 가능 -> true, 위치 서비스 불가능 -> false.
  Future<void> checkLocationEnabled() async {
    final bool locationEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _locationEnabled = locationEnabled;
    });
  }

  ///위치권한 요청 함수.
  ///위치권한 다이얼로그가 각 플랫폼에 맞게 열림.
  Future<void> requestLocationPermission() async {
    final LocationPermission permission = await Geolocator.requestPermission();
    setState(() {
      _permission = permission;
    });
  }

  ///앱 설정을 실행시키는 함수.
  ///실행 완료 -> true, 실행 불가 -> false.
  Future<void> openAppSetting() async {
    final a = await Geolocator.openLocationSettings();
    print(a);
  }
}
