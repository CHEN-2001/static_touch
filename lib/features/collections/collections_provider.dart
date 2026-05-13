import 'package:static_touch/locator.dart';
import 'package:static_touch/shared/providers/base_provider.dart';
import 'package:static_touch/shared/repositories/collection_repository.dart';
import 'package:static_touch/shared/models/collection/collection_model.dart';

class CollectionsProvider extends BaseProvider {
  final CollectionRepository _repo = locator<CollectionRepository>();

  List<CollectionItem> _items = [];
  List<CollectionItem> get items => _items;

  Future<void> fetchCollections() async {
    setLoading(true);
    clearError();

    final result = await _repo.fetchCollections();

    if (result.status && result.data != null) {
      _items = result.data!;
    } else {
      setError(result.message);
    }

    setLoading(false);
  }

  void removeItem(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
