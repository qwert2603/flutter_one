import 'package:flutter/material.dart';
import 'package:flutter_one/localizations.dart';
import 'package:flutter_one/page.dart';

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
        duration: const Duration(milliseconds: 1000), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    fosi = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          QIconButton(routeName: '/fish'),
          QIconButton(routeName: '/anth'),
          QIconButton(routeName: '/qwert')
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ScaleTransition(
              alignment: Alignment.centerRight,
              scale: fosi,
              child: FadeTransition(
                opacity: curve,
                child: FlutterLogo(size: 200),
              ),
            ),
            Text(AppLocalizations.of(context).text1),
            Text(AppLocalizations.of(context).text2),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'fade',
        child: Icon(Icons.brush),
        onPressed: () {
          controller.forward();
//          if (controller.isAnimating) return;
//          if (controller.isCompleted) {
//            controller.reverse();
//          } else {
//            controller.forward();
//          }
        },
      ),
    );
  }
}
