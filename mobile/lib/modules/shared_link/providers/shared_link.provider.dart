import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/shared_link/models/shared_link.dart';
import 'package:immich_mobile/modules/shared_link/services/shared_link.service.dart';

class SharedLinksNotifier extends StateNotifier<AsyncValue<List<SharedLink>>> {
  final SharedLinkService _sharedLinkService;

  SharedLinksNotifier(this._sharedLinkService) : super(const AsyncLoading()) {
    fetchLinks();
  }

  Future<void> fetchLinks() async {
    state = await _sharedLinkService.getAllSharedLinks();
  }

  Future<void> deleteLink(String id) async {
    await _sharedLinkService.deleteSharedLink(id);
    state = const AsyncLoading();
    fetchLinks();
  }
}

final sharedLinksStateProvider =
    StateNotifierProvider<SharedLinksNotifier, AsyncValue<List<SharedLink>>>(
        (ref) {
  return SharedLinksNotifier(
    ref.watch(sharedLinkServiceProvider),
  );
});
