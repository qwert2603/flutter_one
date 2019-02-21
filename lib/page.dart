import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_one/localizations.dart';

class QPage extends StatelessWidget {
  final String text;

  const QPage({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w100, fontSize: 42),
            ),
            FromAndroidReceiver(),
            SizedBox(height: 12),
            Image.asset(
              "assets/images/ocv_part.png",
              width: 140,
            ),
            SizedBox(height: 12),
            MaterialButton(
              color: Colors.deepOrange,
              onPressed: () => Navigator.of(context).pop("result = 42"),
              child: Text("back", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 12),
            MaterialButton(
              color: Colors.deepOrange,
              onPressed: () => openFullPicture(context),
              child: Text("image", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  void openFullPicture(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => FullOCVPicture()),
    );
  }
}

class QIconButton extends StatelessWidget {
  final String routeName;

  const QIconButton({Key key, this.routeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.filter_tilt_shift),
        tooltip: routeName.substring(1),
        onPressed: () async {
          var result = await Navigator.of(context).pushNamed(routeName);
          Scaffold.of(context).showSnackBar(new SnackBar(
            duration: Duration(seconds: 2),
            content: new Text(result),
          ));
        });
  }
}

class FromAndroidReceiver extends StatefulWidget {
  @override
  _FromAndroidReceiverState createState() => _FromAndroidReceiverState();
}

class _FromAndroidReceiverState extends State<FromAndroidReceiver> {
  static const platform = const MethodChannel("app.channel.android.data");
  String data = 'nth';

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Text(data);
  }

  getData() async {
    var arguments = List()..add(14)..add(42);
    var sharedData = await platform.invokeMethod("getFromAndroid", arguments);
    if (sharedData != null) {
      setState(() {
        data = sharedData;
      });
    }
  }
}

class FullOCVPicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).another),
      ),
      body: Container(
        color: Colors.pink,
//        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image.asset("assets/images/ocv.jpg"),
                ),
              ),
            ),
            Text(
              "text0",
              style: TextStyle(
                color: Colors.green,
                fontSize: 32,
              ),
            ),
            Positioned(
              left: 12,
              top: 72,
              child: Text(
                "text1",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 32,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Text(
                "text2",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
