import 'package:flutter_one/redx/actions.dart';
import 'package:flutter_one/redx/state.dart';
import 'package:redux/redux.dart';

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
