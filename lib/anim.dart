import 'package:flutter/material.dart';

class MyFadeTest extends StatefulWidget {
  MyFadeTest({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyFadeTest createState() => _MyFadeTest();
}

class _MyFadeTest extends State<MyFadeTest> with TickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation curve;
  CurvedAnimation fosi;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    fosi = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: ScaleTransition(
          scale: fosi,
          child: FadeTransition(
            opacity: curve,
            child: FlutterLogo(size: 200),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'fade',
        child: Icon(Icons.brush),
        onPressed: () {
          if (controller.isAnimating) return;
          if (controller.isCompleted) {
            controller.reverse();
          } else {
            controller.forward();
          }
        },
      ),
    );
  }
}
