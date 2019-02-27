import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

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

class RedxItem {
  final String text;

  RedxItem(this.text);
}

class RedxState {
  final bool loading;

  final List<RedxItem> items;

  final bool loadError;

  final String search;

  final bool refreshError;

  RedxState(
      this.loading, this.items, this.loadError, this.search, this.refreshError);

  RedxState copy(
      {bool loading,
      List<RedxItem> items,
      bool loadError,
      String search,
      bool refreshError}) {
    return RedxState(
        loading ?? this.loading,
        items ?? this.items,
        loadError ?? this.loadError,
        search ?? this.search,
        refreshError ?? this.refreshError);
  }
}

abstract class RedxAction {}

class LoadItems implements RedxAction {}

class LoadItemsStarted implements RedxAction {}

class LoadItemsError implements RedxAction {}

class SearchItems implements RedxAction {
  final String query;

  SearchItems(this.query);
}

class RefreshItems implements RedxAction {
  final Completer<void> completer = Completer<void>();
}

class ItemsLoaded implements RedxAction {
  final List<RedxItem> items;

  ItemsLoaded(this.items);
}

class RefreshError implements RedxAction {}

class RedxReducer extends TypedReducer<RedxState, RedxAction> {
  RedxReducer()
      : super((RedxState state, RedxAction action) {
          print("RedxReducer $action");
          if (action is LoadItems) return state;
          if (action is LoadItemsStarted)
            return state.copy(loading: true, loadError: false);
          if (action is LoadItemsError)
            return state.copy(loading: false, loadError: true);
          if (action is SearchItems) return state.copy(search: action.query);
          if (action is RefreshItems) return state.copy(refreshError: false);
          if (action is ItemsLoaded)
            return state.copy(loading: false, items: action.items);
          if (action is RefreshError) return state.copy(refreshError: true);
          throw Exception("unknow action $action");
        });
}

class LoadEpic implements EpicClass<RedxState> {
  @override
  Stream call(Stream actions, EpicStore<RedxState> store) {
    var observable = Observable(actions);
    return Observable.merge([
      observable.ofType(TypeToken<LoadItems>()).map((_) => store.state.search),
      observable
          .ofType(TypeToken<SearchItems>())
          .debounce(Duration(milliseconds: 300))
          .map((a) => a.query),
    ]).switchMap((s) {
      final future = Future.delayed(
        Duration(seconds: 2, milliseconds: 0),
        () {
          if (s == "s") throw Exception("searct = s");
          return _loadThem(s);
        },
      );

      return Observable(future.asStream())
          .map<RedxAction>((items) => ItemsLoaded(items))
          .onErrorResume((e) {
        print(e);
        return Observable.just(LoadItemsError());
      }).startWith(LoadItemsStarted());
    });
  }
}

class RefreshEpic implements EpicClass<RedxState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<RedxState> store) {
    var observable = Observable(actions);

    return observable.ofType(TypeToken<RefreshItems>()).switchMap((action) {
      onFinish() {
        print("RefreshItems.completer.complete()");
        if (!action.completer.isCompleted) {
          action.completer.complete();
        }
      }

      final s = store.state.search;

      final future = Future.delayed(
        Duration(seconds: 2, milliseconds: 0),
        () {
          if (s == "th") throw Exception("searct = th");
          return _loadThem(s);
        },
      );

      return Observable(future.asStream())
          .map<RedxAction>((items) => ItemsLoaded(items))
          .onErrorResume((e) {
            print(e);
            return Observable.just(RefreshError());
          })
          .doOnDone(onFinish)
          .doOnCancel(onFinish)
          .takeUntil(
              observable.where((a) => a is LoadItems || a is SearchItems));
    });
  }
}

List<RedxItem> _loadThem(String q) {
  print("_loadThem _${q}_");
  return [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eigth",
    "nine",
    "ten"
  ]
      .where((s) => s.toLowerCase().contains(q.toLowerCase()))
      .map((s) => RedxItem(s))
      .toList();
}
