//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'package:openapi/api.dart';
import 'package:test/test.dart';


/// tests for AssetApi
void main() {
  // final instance = AssetApi();

  group('tests for AssetApi', () {
    // Checks if assets exist by checksums
    //
    //Future<AssetBulkUploadCheckResponseDto> checkBulkUpload(AssetBulkUploadCheckDto assetBulkUploadCheckDto) async
    test('test checkBulkUpload', () async {
      // TODO
    });

    // Checks if multiple assets exist on the server and returns all existing - used by background backup
    //
    //Future<CheckExistingAssetsResponseDto> checkExistingAssets(CheckExistingAssetsDto checkExistingAssetsDto) async
    test('test checkExistingAssets', () async {
      // TODO
    });

    //Future deleteAssets(AssetBulkDeleteDto assetBulkDeleteDto) async
    test('test deleteAssets', () async {
      // TODO
    });

    //Future<MultipartFile> downloadArchive(AssetIdsDto assetIdsDto, { String key }) async
    test('test downloadArchive', () async {
      // TODO
    });

    //Future<MultipartFile> downloadFile(String id, { String key }) async
    test('test downloadFile', () async {
      // TODO
    });

    //Future emptyTrash() async
    test('test emptyTrash', () async {
      // TODO
    });

    // Get all AssetEntity belong to the user
    //
    //Future<List<AssetResponseDto>> getAllAssets({ int skip, int take, String userId, bool isFavorite, bool isArchived, DateTime updatedAfter, DateTime updatedBefore, String ifNoneMatch }) async
    test('test getAllAssets', () async {
      // TODO
    });

    // Get all asset of a device that are in the database, ID only.
    //
    //Future<List<String>> getAllUserAssetsByDeviceId(String deviceId) async
    test('test getAllUserAssetsByDeviceId', () async {
      // TODO
    });

    // Get a single asset's information
    //
    //Future<AssetResponseDto> getAssetById(String id, { String key }) async
    test('test getAssetById', () async {
      // TODO
    });

    //Future<List<String>> getAssetSearchTerms() async
    test('test getAssetSearchTerms', () async {
      // TODO
    });

    //Future<AssetStatsResponseDto> getAssetStatistics({ bool isArchived, bool isFavorite, bool isTrashed }) async
    test('test getAssetStatistics', () async {
      // TODO
    });

    //Future<MultipartFile> getAssetThumbnail(String id, { ThumbnailFormat format, String key }) async
    test('test getAssetThumbnail', () async {
      // TODO
    });

    //Future<List<CuratedLocationsResponseDto>> getCuratedLocations() async
    test('test getCuratedLocations', () async {
      // TODO
    });

    //Future<List<CuratedObjectsResponseDto>> getCuratedObjects() async
    test('test getCuratedObjects', () async {
      // TODO
    });

    //Future<DownloadResponseDto> getDownloadInfo(DownloadInfoDto downloadInfoDto, { String key }) async
    test('test getDownloadInfo', () async {
      // TODO
    });

    //Future<List<MapMarkerResponseDto>> getMapMarkers({ bool isArchived, bool isFavorite, DateTime fileCreatedAfter, DateTime fileCreatedBefore }) async
    test('test getMapMarkers', () async {
      // TODO
    });

    //Future<List<MemoryLaneResponseDto>> getMemoryLane(int day, int month) async
    test('test getMemoryLane', () async {
      // TODO
    });

    //Future<List<AssetResponseDto>> getRandom({ num count }) async
    test('test getRandom', () async {
      // TODO
    });

    //Future<List<AssetResponseDto>> getTimeBucket(TimeBucketSize size, String timeBucket, { String userId, String albumId, String personId, bool isArchived, bool isFavorite, bool isTrashed, bool withStacked, bool withPartners, String key }) async
    test('test getTimeBucket', () async {
      // TODO
    });

    //Future<List<TimeBucketResponseDto>> getTimeBuckets(TimeBucketSize size, { String userId, String albumId, String personId, bool isArchived, bool isFavorite, bool isTrashed, bool withStacked, bool withPartners, String key }) async
    test('test getTimeBuckets', () async {
      // TODO
    });

    // Use /asset/device/:deviceId instead - Remove in 1.92 release
    //
    //Future<List<String>> getUserAssetsByDeviceId(String deviceId) async
    test('test getUserAssetsByDeviceId', () async {
      // TODO
    });

    //Future restoreAssets(BulkIdsDto bulkIdsDto) async
    test('test restoreAssets', () async {
      // TODO
    });

    //Future restoreTrash() async
    test('test restoreTrash', () async {
      // TODO
    });

    //Future runAssetJobs(AssetJobsDto assetJobsDto) async
    test('test runAssetJobs', () async {
      // TODO
    });

    //Future<List<AssetResponseDto>> searchAssets({ String id, String libraryId, AssetTypeEnum type, AssetOrder order, String deviceAssetId, String deviceId, String checksum, bool isArchived, bool isEncoded, bool isExternal, bool isFavorite, bool isMotion, bool isOffline, bool isReadOnly, bool isVisible, bool withDeleted, bool withStacked, bool withExif, bool withPeople, DateTime createdBefore, DateTime createdAfter, DateTime updatedBefore, DateTime updatedAfter, DateTime trashedBefore, DateTime trashedAfter, DateTime takenBefore, DateTime takenAfter, String originalFileName, String originalPath, String resizePath, String webpPath, String encodedVideoPath, String city, String state, String country, String make, String model, String lensModel, num page, num size }) async
    test('test searchAssets', () async {
      // TODO
    });

    //Future<MultipartFile> serveFile(String id, { bool isThumb, bool isWeb, String key }) async
    test('test serveFile', () async {
      // TODO
    });

    //Future<AssetResponseDto> updateAsset(String id, UpdateAssetDto updateAssetDto) async
    test('test updateAsset', () async {
      // TODO
    });

    //Future updateAssets(AssetBulkUpdateDto assetBulkUpdateDto) async
    test('test updateAssets', () async {
      // TODO
    });

    //Future updateStackParent(UpdateStackParentDto updateStackParentDto) async
    test('test updateStackParent', () async {
      // TODO
    });

    //Future<AssetFileUploadResponseDto> uploadFile(MultipartFile assetData, String deviceAssetId, String deviceId, DateTime fileCreatedAt, DateTime fileModifiedAt, { String key, String duration, bool isArchived, bool isExternal, bool isFavorite, bool isOffline, bool isReadOnly, bool isVisible, String libraryId, MultipartFile livePhotoData, MultipartFile sidecarData }) async
    test('test uploadFile', () async {
      // TODO
    });

  });
}
