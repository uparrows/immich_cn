import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/shared/models/asset.dart';
import 'package:immich_mobile/shared/providers/db.provider.dart';
import 'package:isar/isar.dart';

class AssetStackNotifier extends StateNotifier<List<Asset>> {
  final Asset _asset;
  final Ref _ref;

  AssetStackNotifier(
    this._asset,
    this._ref,
  ) : super([]) {
    fetchStackChildren();
  }

  void fetchStackChildren() async {
    if (mounted) {
      state = await _ref.read(assetStackProvider(_asset).future);
    }
  }

  void removeChild(int index) {
    if (index < state.length) {
      state.removeAt(index);
    }
  }
}

final assetStackStateProvider = StateNotifierProvider.autoDispose
    .family<AssetStackNotifier, List<Asset>, Asset>(
  (ref, asset) => AssetStackNotifier(asset, ref),
);

final assetStackProvider =
    FutureProvider.autoDispose.family<List<Asset>, Asset>((ref, asset) async {
  // Guard [local asset]
  if (asset.remoteId == null) {
    return [];
  }

  return await ref
      .watch(dbProvider)
      .assets
      .filter()
      .isArchivedEqualTo(false)
      .isTrashedEqualTo(false)
      .stackParentIdEqualTo(asset.remoteId)
      .sortByFileCreatedAtDesc()
      .findAll();
});
