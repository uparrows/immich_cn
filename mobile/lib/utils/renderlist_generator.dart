import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/home/ui/asset_grid/asset_grid_data_structure.dart';
import 'package:immich_mobile/modules/settings/providers/app_settings.provider.dart';
import 'package:immich_mobile/modules/settings/services/app_settings.service.dart';
import 'package:immich_mobile/shared/models/asset.dart';
import 'package:isar/isar.dart';

Stream<RenderList> renderListGenerator(
  QueryBuilder<Asset, Asset, QAfterSortBy> query,
  StreamProviderRef<RenderList> ref,
) {
  final settings = ref.watch(appSettingsServiceProvider);
  final groupBy =
      GroupAssetsBy.values[settings.getSetting(AppSettingsEnum.groupAssetsBy)];
  return renderListGeneratorWithGroupBy(query, groupBy);
}

Stream<RenderList> renderListGeneratorWithGroupBy(
  QueryBuilder<Asset, Asset, QAfterSortBy> query,
  GroupAssetsBy groupBy,
) async* {
  yield await RenderList.fromQuery(query, groupBy);
  await for (final _ in query.watchLazy()) {
    yield await RenderList.fromQuery(query, groupBy);
  }
}
