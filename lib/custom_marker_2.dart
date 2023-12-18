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
    // 커스텀 마커가 렌더링되면, 호출되는 함수
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

  ///RepaintBoundary에 연결된 GlobalKey를 사용해 RenderRepaintBoundary 객체에 접근.
  ///이 객체는 위젯의 RenderObject를 나타냄.
  Future<void> loadTheMarker() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onFinishRendering(_globalKey);
    });
  }
}
