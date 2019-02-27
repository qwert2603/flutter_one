import 'package:flutter/material.dart';
import 'package:flutter_one/redx/actions.dart';
import 'package:flutter_one/redx/state.dart';
import 'package:flutter_redux/flutter_redux.dart';

class RefreshErrorSnackbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<RedxState, RefreshErrorSnackbarVM>(
      converter: (store) => RefreshErrorSnackbarVM(
        store.state.refreshError,
            () => store.dispatch(RefreshItems()),
      ),
      builder: (context, refreshError) => Container(),
      distinct: true,
      onWillChange: (vm) {
        print("RefreshErrorSnackbar onWillChange ${vm.refreshError}");
        if (vm.refreshError) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("refresh error!"),
            duration: Duration(seconds: 2),
            action: SnackBarAction(label: "retry", onPressed: vm.onRetry),
          ));
        }
      },
    );
  }
}

class RefreshErrorSnackbarVM {
  final bool refreshError;
  final Function() onRetry;

  RefreshErrorSnackbarVM(this.refreshError, this.onRetry);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RefreshErrorSnackbarVM &&
              runtimeType == other.runtimeType &&
              refreshError == other.refreshError;

  @override
  int get hashCode => refreshError.hashCode;
}


