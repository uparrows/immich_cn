import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/home/ui/asset_grid/asset_grid_data_structure.dart';
import 'package:immich_mobile/modules/trash/services/trash.service.dart';
import 'package:immich_mobile/shared/models/asset.dart';
import 'package:immich_mobile/shared/providers/asset.provider.dart';
import 'package:immich_mobile/shared/providers/db.provider.dart';
import 'package:immich_mobile/shared/providers/user.provider.dart';
import 'package:immich_mobile/shared/services/sync.service.dart';
import 'package:immich_mobile/utils/renderlist_generator.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';

class TrashNotifier extends StateNotifier<bool> {
  final Isar _db;
  final Ref _ref;
  final TrashService _trashService;
  final _log = Logger('TrashNotifier');

  TrashNotifier(
    this._trashService,
    this._db,
    this._ref,
  ) : super(false);

  Future<void> emptyTrash() async {
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        return;
      }
      await _trashService.emptyTrash();

      final idsToRemove = await _db.assets
          .where()
          .remoteIdIsNotNull()
          .filter()
          .ownerIdEqualTo(user.isarId)
          .isTrashedEqualTo(true)
          .remoteIdProperty()
          .findAll();

      // TODO: handle local asset removal on emptyTrash
      _ref
          .read(syncServiceProvider)
          .handleRemoteAssetRemoval(idsToRemove.cast<String>().toList());
    } catch (error, stack) {
      _log.severe("Cannot empty trash ${error.toString()}", error, stack);
    }
  }

  Future<bool> removeAssets(Iterable<Asset> assetList) async {
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        return false;
      }

      final isRemoved = await _ref
          .read(assetProvider.notifier)
          .deleteRemoteOnlyAssets(assetList, force: true);

      if (isRemoved) {
        final idsToRemove =
            assetList.where((a) => a.isRemote).map((a) => a.remoteId!).toList();

        _ref
            .read(syncServiceProvider)
            .handleRemoteAssetRemoval(idsToRemove.cast<String>().toList());
      }

      return isRemoved;
    } catch (error, stack) {
      _log.severe("Cannot empty trash ${error.toString()}", error, stack);
    }
    return false;
  }

  Future<bool> restoreAssets(Iterable<Asset> assetList) async {
    try {
      final result = await _trashService.restoreAssets(assetList);

      if (result) {
        final remoteAssets = assetList.where((a) => a.isRemote).toList();

        final updatedAssets = remoteAssets.map((e) {
          e.isTrashed = false;
          return e;
        }).toList();

        await _db.writeTxn(() async {
          await _db.assets.putAll(updatedAssets);
        });
        return true;
      }
    } catch (error, stack) {
      _log.severe("Cannot restore trash ${error.toString()}", error, stack);
    }
    return false;
  }

  Future<void> restoreTrash() async {
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        return;
      }
      await _trashService.restoreTrash();

      final assets = await _db.assets
          .where()
          .remoteIdIsNotNull()
          .filter()
          .ownerIdEqualTo(user.isarId)
          .isTrashedEqualTo(true)
          .findAll();

      final updatedAssets = assets.map((e) {
        e.isTrashed = false;
        return e;
      }).toList();

      await _db.writeTxn(() async {
        await _db.assets.putAll(updatedAssets);
      });
    } catch (error, stack) {
      _log.severe("Cannot restore trash ${error.toString()}", error, stack);
    }
  }
}

final trashProvider = StateNotifierProvider<TrashNotifier, bool>((ref) {
  return TrashNotifier(
    ref.watch(trashServiceProvider),
    ref.watch(dbProvider),
    ref,
  );
});

final trashedAssetsProvider = StreamProvider<RenderList>((ref) {
  final user = ref.read(currentUserProvider);
  if (user == null) return const Stream.empty();
  final query = ref
      .watch(dbProvider)
      .assets
      .filter()
      .ownerIdEqualTo(user.isarId)
      .isTrashedEqualTo(true)
      .sortByFileCreatedAt();
  return renderListGeneratorWithGroupBy(query, GroupAssetsBy.none);
});
