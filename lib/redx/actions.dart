import 'dart:async';

import 'package:flutter_one/redx/state.dart';

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
