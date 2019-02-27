import 'package:flutter_one/redx/actions.dart';
import 'package:flutter_one/redx/state.dart';
import 'package:flutter_one/redx/repo.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

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
          return loadThem(s);
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
          return loadThem(s);
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
