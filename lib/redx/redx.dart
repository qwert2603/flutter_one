
import 'package:flutter/material.dart';
import 'package:flutter_one/redx/refresh_error_snackbar.dart';
import 'package:flutter_one/redx/actions.dart';
import 'package:flutter_one/redx/screen.dart';
import 'package:flutter_one/redx/state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class Redx extends StatelessWidget {
  final Store<RedxState> store;

  const Redx({Key key, @required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreBuilder<RedxState>(
        onInit: (store) => store.dispatch(LoadItems()),
        builder: (context, store) {
          return Scaffold(
            appBar: AppBar(title: Text("Redx")),
            body: Stack(
              children: <Widget>[
                ScreenWidget(),
                RefreshErrorSnackbar(),
              ],
            ),
          );
        },
      ),
    );
  }
}

