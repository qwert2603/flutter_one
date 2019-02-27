import 'package:flutter/material.dart';
import 'package:flutter_one/redx/actions.dart';
import 'package:flutter_one/redx/state.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ScreenViewModel {
  final RedxState state;
  final Function(String search) onSearch;
  final Function() onReload;
  final Future<void> Function() onRefresh;

  ScreenViewModel(this.state, this.onSearch, this.onReload, this.onRefresh);
}

class ScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<RedxState, ScreenViewModel>(
      converter: (store) => ScreenViewModel(
        store.state,
            (s) => store.dispatch(SearchItems(s)),
            () => store.dispatch(LoadItems()),
            () {
          var action = RefreshItems();
          store.dispatch(action);
          return action.completer.future;
        },
      ),
      builder: (context, vm) {
        var content;

        if (vm.state.loading) {
          content = Center(child: CircularProgressIndicator());
        } else if (vm.state.loadError) {
          content = Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("load error"),
                  SizedBox(height: 16),
                  OutlineButton(
                    highlightedBorderColor: Colors.deepOrange,
                    borderSide: BorderSide(color: Colors.amber, width: 2),
                    onPressed: vm.onReload,
                    child: Text("reload"),
                  ),
                ],
              ));
        } else {
          content = RefreshIndicator(
            child: ItemsListWidget(),
            onRefresh: vm.onRefresh,
          );
        }

        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: vm.onSearch,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "search",
                  hintText: "type here..",
                ),
              ),
            ),
            Flexible(child: content)
          ],
        );
      },
    );
  }
}

class ItemsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<RedxState, List<RedxItem>>(
      converter: (store) => store.state.items,
      builder: (context, list) {
        return Scrollbar(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(list[index].text),
              );
            },
          ),
        );
      },
    );
  }
}

