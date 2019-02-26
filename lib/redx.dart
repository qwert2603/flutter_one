import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class Redx extends StatelessWidget {
  final Store<RedxState> store;

  const Redx({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreBuilder<RedxState>(
        onInit: (store) => store.dispatch(LoadItems()),
        builder: (context, store) {
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: Text("Redx")),
              body: ScreenWidget(),
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
  final Future<void> Function() onRefresh;

  ScreenViewModel(this.state, this.onSearch, this.onRefresh);
}

class ScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<RedxState, ScreenViewModel>(
      converter: (store) => ScreenViewModel(
            store.state,
            (s) => store.dispatch(SearchItems(s)),
            () {
              var action = RefreshItems();
              store.dispatch(action);
              return action.completer.future;
            },
          ),
      builder: (context, vm) {
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
            Flexible(
              child: vm.state.items.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      child: ItemsListWidget(),
                      onRefresh: vm.onRefresh,
                    ),
            )
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

class RedxItem {
  final String text;

  RedxItem(this.text);
}

class RedxState {
  final bool loading;

  final List<RedxItem> items;

  final String search;

  RedxState(this.loading, this.items, this.search);
}

abstract class RedxAction {}

class LoadItems implements RedxAction {}

class LoadItemsStarted implements RedxAction {}

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

class RedxReducer extends TypedReducer<RedxState, RedxAction> {
  RedxReducer()
      : super((RedxState state, RedxAction action) {
          if (action is LoadItems) return state;
          if (action is LoadItemsStarted)
            return RedxState(true, state.items, state.search);
          if (action is SearchItems)
            return RedxState(state.loading, state.items, action.query);
          if (action is RefreshItems) return state;
          if (action is ItemsLoaded)
            return RedxState(false, action.items, state.search);
          throw Exception("unknow action $action");
        });
}

class LoadEpic implements EpicClass<RedxState> {
  @override
  Stream call(Stream actions, EpicStore<RedxState> store) {
    var observable = Observable(actions);
    return Observable.merge([
      observable.ofType(TypeToken<LoadItems>()).map((_) => ""),
      observable.ofType(TypeToken<SearchItems>()).map((a) => a.query),
      observable
          .ofType(TypeToken<RefreshItems>())
          .map((_) => store.state.search),
    ]).switchMap((s) async* {
      yield LoadItemsStarted();
      var items = await Future.delayed(
        Duration(seconds: 1, milliseconds: 500),
        () => _loadThem(s),
      );
      yield ItemsLoaded(items);
    });
  }
}

Middleware<RedxState> finishRefresh() {
  RefreshItems refreshItems;
  return (Store<RedxState> store, dynamic action, NextDispatcher next) {
    if (action is RefreshItems) {
      refreshItems = action;
    }
    if (action is LoadItems || action is SearchItems || action is ItemsLoaded) {
      refreshItems?.completer?.complete();
      refreshItems = null;
    }
    next(action);
  };
}

List<RedxItem> _loadThem(String q) => [
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
