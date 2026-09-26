import 'package:flutter/widgets.dart';

enum FavoriteType { character, track, kart }

class FavoriteEntry {
  final String id;
  final FavoriteType type;

  const FavoriteEntry(this.id, this.type);

  @override
  bool operator ==(Object other) =>
      other is FavoriteEntry && other.id == id && other.type == type;

  @override
  int get hashCode => Object.hash(id, type);
}

/// Holds favorites (and, later, "recently viewed") for the whole app.
///
/// This is in-memory only for now — favorites will not survive an app
/// restart. See README "Known issues": persistence (e.g. shared_preferences
/// or a local database) still needs to be decided and added.
class AppState extends ChangeNotifier {
  final Set<FavoriteEntry> _favorites = {};
  final List<String> _recentlyViewedCharacterIds = [];

  Set<FavoriteEntry> get favorites => _favorites;
  List<String> get recentlyViewedCharacterIds => _recentlyViewedCharacterIds;

  bool isFavorited(String id, FavoriteType type) =>
      _favorites.contains(FavoriteEntry(id, type));

  void toggleFavorite(String id, FavoriteType type) {
    final entry = FavoriteEntry(id, type);
    if (_favorites.contains(entry)) {
      _favorites.remove(entry);
    } else {
      _favorites.add(entry);
    }
    notifyListeners();
  }

  void markCharacterViewed(String id) {
    _recentlyViewedCharacterIds.remove(id);
    _recentlyViewedCharacterIds.insert(0, id);
    if (_recentlyViewedCharacterIds.length > 4) {
      _recentlyViewedCharacterIds.removeLast();
    }
    notifyListeners();
  }
}

/// Makes [AppState] available to the widget tree and rebuilds dependents
/// when it changes.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState appState,
    required super.child,
  }) : super(notifier: appState);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found in context');
    return scope!.notifier!;
  }
}
