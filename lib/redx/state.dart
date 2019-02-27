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
