//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AssetApi {
  AssetApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Checks if assets exist by checksums
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AssetBulkUploadCheckDto] assetBulkUploadCheckDto (required):
  Future<Response> checkBulkUploadWithHttpInfo(AssetBulkUploadCheckDto assetBulkUploadCheckDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/bulk-upload-check';

    // ignore: prefer_final_locals
    Object? postBody = assetBulkUploadCheckDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Checks if assets exist by checksums
  ///
  /// Parameters:
  ///
  /// * [AssetBulkUploadCheckDto] assetBulkUploadCheckDto (required):
  Future<AssetBulkUploadCheckResponseDto?> checkBulkUpload(AssetBulkUploadCheckDto assetBulkUploadCheckDto,) async {
    final response = await checkBulkUploadWithHttpInfo(assetBulkUploadCheckDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AssetBulkUploadCheckResponseDto',) as AssetBulkUploadCheckResponseDto;
    
    }
    return null;
  }

  /// Checks if multiple assets exist on the server and returns all existing - used by background backup
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CheckExistingAssetsDto] checkExistingAssetsDto (required):
  Future<Response> checkExistingAssetsWithHttpInfo(CheckExistingAssetsDto checkExistingAssetsDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/exist';

    // ignore: prefer_final_locals
    Object? postBody = checkExistingAssetsDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Checks if multiple assets exist on the server and returns all existing - used by background backup
  ///
  /// Parameters:
  ///
  /// * [CheckExistingAssetsDto] checkExistingAssetsDto (required):
  Future<CheckExistingAssetsResponseDto?> checkExistingAssets(CheckExistingAssetsDto checkExistingAssetsDto,) async {
    final response = await checkExistingAssetsWithHttpInfo(checkExistingAssetsDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CheckExistingAssetsResponseDto',) as CheckExistingAssetsResponseDto;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /asset' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [AssetBulkDeleteDto] assetBulkDeleteDto (required):
  Future<Response> deleteAssetsWithHttpInfo(AssetBulkDeleteDto assetBulkDeleteDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/asset';

    // ignore: prefer_final_locals
    Object? postBody = assetBulkDeleteDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [AssetBulkDeleteDto] assetBulkDeleteDto (required):
  Future<void> deleteAssets(AssetBulkDeleteDto assetBulkDeleteDto,) async {
    final response = await deleteAssetsWithHttpInfo(assetBulkDeleteDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'POST /asset/download/archive' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [AssetIdsDto] assetIdsDto (required):
  ///
  /// * [String] key:
  Future<Response> downloadArchiveWithHttpInfo(AssetIdsDto assetIdsDto, { String? key, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/download/archive';

    // ignore: prefer_final_locals
    Object? postBody = assetIdsDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (key != null) {
      queryParams.addAll(_queryParams('', 'key', key));
    }

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [AssetIdsDto] assetIdsDto (required):
  ///
  /// * [String] key:
  Future<MultipartFile?> downloadArchive(AssetIdsDto assetIdsDto, { String? key, }) async {
    final response = await downloadArchiveWithHttpInfo(assetIdsDto,  key: key, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MultipartFile',) as MultipartFile;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /asset/download/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] key:
  Future<Response> downloadFileWithHttpInfo(String id, { String? key, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/download/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (key != null) {
      queryParams.addAll(_queryParams('', 'key', key));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] key:
  Future<MultipartFile?> downloadFile(String id, { String? key, }) async {
    final response = await downloadFileWithHttpInfo(id,  key: key, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MultipartFile',) as MultipartFile;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /asset/trash/empty' operation and returns the [Response].
  Future<Response> emptyTrashWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/asset/trash/empty';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  Future<void> emptyTrash() async {
    final response = await emptyTrashWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get all AssetEntity belong to the user
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] skip:
  ///
  /// * [int] take:
  ///
  /// * [String] userId:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [bool] isArchived:
  ///
  /// * [DateTime] updatedAfter:
  ///
  /// * [DateTime] updatedBefore:
  ///
  /// * [String] ifNoneMatch:
  ///   ETag of data already cached on the client
  Future<Response> getAllAssetsWithHttpInfo({ int? skip, int? take, String? userId, bool? isFavorite, bool? isArchived, DateTime? updatedAfter, DateTime? updatedBefore, String? ifNoneMatch, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (skip != null) {
      queryParams.addAll(_queryParams('', 'skip', skip));
    }
    if (take != null) {
      queryParams.addAll(_queryParams('', 'take', take));
    }
    if (userId != null) {
      queryParams.addAll(_queryParams('', 'userId', userId));
    }
    if (isFavorite != null) {
      queryParams.addAll(_queryParams('', 'isFavorite', isFavorite));
    }
    if (isArchived != null) {
      queryParams.addAll(_queryParams('', 'isArchived', isArchived));
    }
    if (updatedAfter != null) {
      queryParams.addAll(_queryParams('', 'updatedAfter', updatedAfter));
    }
    if (updatedBefore != null) {
      queryParams.addAll(_queryParams('', 'updatedBefore', updatedBefore));
    }

    if (ifNoneMatch != null) {
      headerParams[r'if-none-match'] = parameterToString(ifNoneMatch);
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get all AssetEntity belong to the user
  ///
  /// Parameters:
  ///
  /// * [int] skip:
  ///
  /// * [int] take:
  ///
  /// * [String] userId:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [bool] isArchived:
  ///
  /// * [DateTime] updatedAfter:
  ///
  /// * [DateTime] updatedBefore:
  ///
  /// * [String] ifNoneMatch:
  ///   ETag of data already cached on the client
  Future<List<AssetResponseDto>?> getAllAssets({ int? skip, int? take, String? userId, bool? isFavorite, bool? isArchived, DateTime? updatedAfter, DateTime? updatedBefore, String? ifNoneMatch, }) async {
    final response = await getAllAssetsWithHttpInfo( skip: skip, take: take, userId: userId, isFavorite: isFavorite, isArchived: isArchived, updatedAfter: updatedAfter, updatedBefore: updatedBefore, ifNoneMatch: ifNoneMatch, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AssetResponseDto>') as List)
        .cast<AssetResponseDto>()
        .toList();

    }
    return null;
  }

  /// Get all asset of a device that are in the database, ID only.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] deviceId (required):
  Future<Response> getAllUserAssetsByDeviceIdWithHttpInfo(String deviceId,) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/device/{deviceId}'
      .replaceAll('{deviceId}', deviceId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get all asset of a device that are in the database, ID only.
  ///
  /// Parameters:
  ///
  /// * [String] deviceId (required):
  Future<List<String>?> getAllUserAssetsByDeviceId(String deviceId,) async {
    final response = await getAllUserAssetsByDeviceIdWithHttpInfo(deviceId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<String>') as List)
        .cast<String>()
        .toList();

    }
    return null;
  }

  /// Get a single asset's information
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] key:
  Future<Response> getAssetByIdWithHttpInfo(String id, { String? key, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/assetById/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (key != null) {
      queryParams.addAll(_queryParams('', 'key', key));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a single asset's information
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] key:
  Future<AssetResponseDto?> getAssetById(String id, { String? key, }) async {
    final response = await getAssetByIdWithHttpInfo(id,  key: key, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AssetResponseDto',) as AssetResponseDto;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /asset/search-terms' operation and returns the [Response].
  Future<Response> getAssetSearchTermsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/asset/search-terms';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  Future<List<String>?> getAssetSearchTerms() async {
    final response = await getAssetSearchTermsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<String>') as List)
        .cast<String>()
        .toList();

    }
    return null;
  }

  /// Performs an HTTP 'GET /asset/statistics' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [bool] isArchived:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [bool] isTrashed:
  Future<Response> getAssetStatisticsWithHttpInfo({ bool? isArchived, bool? isFavorite, bool? isTrashed, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/statistics';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (isArchived != null) {
      queryParams.addAll(_queryParams('', 'isArchived', isArchived));
    }
    if (isFavorite != null) {
      queryParams.addAll(_queryParams('', 'isFavorite', isFavorite));
    }
    if (isTrashed != null) {
      queryParams.addAll(_queryParams('', 'isTrashed', isTrashed));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [bool] isArchived:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [bool] isTrashed:
  Future<AssetStatsResponseDto?> getAssetStatistics({ bool? isArchived, bool? isFavorite, bool? isTrashed, }) async {
    final response = await getAssetStatisticsWithHttpInfo( isArchived: isArchived, isFavorite: isFavorite, isTrashed: isTrashed, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AssetStatsResponseDto',) as AssetStatsResponseDto;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /asset/thumbnail/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [ThumbnailFormat] format:
  ///
  /// * [String] key:
  Future<Response> getAssetThumbnailWithHttpInfo(String id, { ThumbnailFormat? format, String? key, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/thumbnail/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (format != null) {
      queryParams.addAll(_queryParams('', 'format', format));
    }
    if (key != null) {
      queryParams.addAll(_queryParams('', 'key', key));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [ThumbnailFormat] format:
  ///
  /// * [String] key:
  Future<MultipartFile?> getAssetThumbnail(String id, { ThumbnailFormat? format, String? key, }) async {
    final response = await getAssetThumbnailWithHttpInfo(id,  format: format, key: key, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MultipartFile',) as MultipartFile;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /asset/curated-locations' operation and returns the [Response].
  Future<Response> getCuratedLocationsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/asset/curated-locations';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  Future<List<CuratedLocationsResponseDto>?> getCuratedLocations() async {
    final response = await getCuratedLocationsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<CuratedLocationsResponseDto>') as List)
        .cast<CuratedLocationsResponseDto>()
        .toList();

    }
    return null;
  }

  /// Performs an HTTP 'GET /asset/curated-objects' operation and returns the [Response].
  Future<Response> getCuratedObjectsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/asset/curated-objects';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  Future<List<CuratedObjectsResponseDto>?> getCuratedObjects() async {
    final response = await getCuratedObjectsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<CuratedObjectsResponseDto>') as List)
        .cast<CuratedObjectsResponseDto>()
        .toList();

    }
    return null;
  }

  /// Performs an HTTP 'POST /asset/download/info' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [DownloadInfoDto] downloadInfoDto (required):
  ///
  /// * [String] key:
  Future<Response> getDownloadInfoWithHttpInfo(DownloadInfoDto downloadInfoDto, { String? key, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/download/info';

    // ignore: prefer_final_locals
    Object? postBody = downloadInfoDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (key != null) {
      queryParams.addAll(_queryParams('', 'key', key));
    }

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [DownloadInfoDto] downloadInfoDto (required):
  ///
  /// * [String] key:
  Future<DownloadResponseDto?> getDownloadInfo(DownloadInfoDto downloadInfoDto, { String? key, }) async {
    final response = await getDownloadInfoWithHttpInfo(downloadInfoDto,  key: key, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DownloadResponseDto',) as DownloadResponseDto;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /asset/map-marker' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [bool] isArchived:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [DateTime] fileCreatedAfter:
  ///
  /// * [DateTime] fileCreatedBefore:
  Future<Response> getMapMarkersWithHttpInfo({ bool? isArchived, bool? isFavorite, DateTime? fileCreatedAfter, DateTime? fileCreatedBefore, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/map-marker';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (isArchived != null) {
      queryParams.addAll(_queryParams('', 'isArchived', isArchived));
    }
    if (isFavorite != null) {
      queryParams.addAll(_queryParams('', 'isFavorite', isFavorite));
    }
    if (fileCreatedAfter != null) {
      queryParams.addAll(_queryParams('', 'fileCreatedAfter', fileCreatedAfter));
    }
    if (fileCreatedBefore != null) {
      queryParams.addAll(_queryParams('', 'fileCreatedBefore', fileCreatedBefore));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [bool] isArchived:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [DateTime] fileCreatedAfter:
  ///
  /// * [DateTime] fileCreatedBefore:
  Future<List<MapMarkerResponseDto>?> getMapMarkers({ bool? isArchived, bool? isFavorite, DateTime? fileCreatedAfter, DateTime? fileCreatedBefore, }) async {
    final response = await getMapMarkersWithHttpInfo( isArchived: isArchived, isFavorite: isFavorite, fileCreatedAfter: fileCreatedAfter, fileCreatedBefore: fileCreatedBefore, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<MapMarkerResponseDto>') as List)
        .cast<MapMarkerResponseDto>()
        .toList();

    }
    return null;
  }

  /// Performs an HTTP 'GET /asset/memory-lane' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] day (required):
  ///
  /// * [int] month (required):
  Future<Response> getMemoryLaneWithHttpInfo(int day, int month,) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/memory-lane';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'day', day));
      queryParams.addAll(_queryParams('', 'month', month));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] day (required):
  ///
  /// * [int] month (required):
  Future<List<MemoryLaneResponseDto>?> getMemoryLane(int day, int month,) async {
    final response = await getMemoryLaneWithHttpInfo(day, month,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<MemoryLaneResponseDto>') as List)
        .cast<MemoryLaneResponseDto>()
        .toList();

    }
    return null;
  }

  /// Performs an HTTP 'GET /asset/random' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [num] count:
  Future<Response> getRandomWithHttpInfo({ num? count, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/random';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (count != null) {
      queryParams.addAll(_queryParams('', 'count', count));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [num] count:
  Future<List<AssetResponseDto>?> getRandom({ num? count, }) async {
    final response = await getRandomWithHttpInfo( count: count, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AssetResponseDto>') as List)
        .cast<AssetResponseDto>()
        .toList();

    }
    return null;
  }

  /// Performs an HTTP 'GET /asset/time-bucket' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [TimeBucketSize] size (required):
  ///
  /// * [String] timeBucket (required):
  ///
  /// * [String] userId:
  ///
  /// * [String] albumId:
  ///
  /// * [String] personId:
  ///
  /// * [bool] isArchived:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [bool] isTrashed:
  ///
  /// * [bool] withStacked:
  ///
  /// * [bool] withPartners:
  ///
  /// * [String] key:
  Future<Response> getTimeBucketWithHttpInfo(TimeBucketSize size, String timeBucket, { String? userId, String? albumId, String? personId, bool? isArchived, bool? isFavorite, bool? isTrashed, bool? withStacked, bool? withPartners, String? key, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/time-bucket';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'size', size));
    if (userId != null) {
      queryParams.addAll(_queryParams('', 'userId', userId));
    }
    if (albumId != null) {
      queryParams.addAll(_queryParams('', 'albumId', albumId));
    }
    if (personId != null) {
      queryParams.addAll(_queryParams('', 'personId', personId));
    }
    if (isArchived != null) {
      queryParams.addAll(_queryParams('', 'isArchived', isArchived));
    }
    if (isFavorite != null) {
      queryParams.addAll(_queryParams('', 'isFavorite', isFavorite));
    }
    if (isTrashed != null) {
      queryParams.addAll(_queryParams('', 'isTrashed', isTrashed));
    }
    if (withStacked != null) {
      queryParams.addAll(_queryParams('', 'withStacked', withStacked));
    }
    if (withPartners != null) {
      queryParams.addAll(_queryParams('', 'withPartners', withPartners));
    }
      queryParams.addAll(_queryParams('', 'timeBucket', timeBucket));
    if (key != null) {
      queryParams.addAll(_queryParams('', 'key', key));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [TimeBucketSize] size (required):
  ///
  /// * [String] timeBucket (required):
  ///
  /// * [String] userId:
  ///
  /// * [String] albumId:
  ///
  /// * [String] personId:
  ///
  /// * [bool] isArchived:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [bool] isTrashed:
  ///
  /// * [bool] withStacked:
  ///
  /// * [bool] withPartners:
  ///
  /// * [String] key:
  Future<List<AssetResponseDto>?> getTimeBucket(TimeBucketSize size, String timeBucket, { String? userId, String? albumId, String? personId, bool? isArchived, bool? isFavorite, bool? isTrashed, bool? withStacked, bool? withPartners, String? key, }) async {
    final response = await getTimeBucketWithHttpInfo(size, timeBucket,  userId: userId, albumId: albumId, personId: personId, isArchived: isArchived, isFavorite: isFavorite, isTrashed: isTrashed, withStacked: withStacked, withPartners: withPartners, key: key, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AssetResponseDto>') as List)
        .cast<AssetResponseDto>()
        .toList();

    }
    return null;
  }

  /// Performs an HTTP 'GET /asset/time-buckets' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [TimeBucketSize] size (required):
  ///
  /// * [String] userId:
  ///
  /// * [String] albumId:
  ///
  /// * [String] personId:
  ///
  /// * [bool] isArchived:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [bool] isTrashed:
  ///
  /// * [bool] withStacked:
  ///
  /// * [bool] withPartners:
  ///
  /// * [String] key:
  Future<Response> getTimeBucketsWithHttpInfo(TimeBucketSize size, { String? userId, String? albumId, String? personId, bool? isArchived, bool? isFavorite, bool? isTrashed, bool? withStacked, bool? withPartners, String? key, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/time-buckets';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'size', size));
    if (userId != null) {
      queryParams.addAll(_queryParams('', 'userId', userId));
    }
    if (albumId != null) {
      queryParams.addAll(_queryParams('', 'albumId', albumId));
    }
    if (personId != null) {
      queryParams.addAll(_queryParams('', 'personId', personId));
    }
    if (isArchived != null) {
      queryParams.addAll(_queryParams('', 'isArchived', isArchived));
    }
    if (isFavorite != null) {
      queryParams.addAll(_queryParams('', 'isFavorite', isFavorite));
    }
    if (isTrashed != null) {
      queryParams.addAll(_queryParams('', 'isTrashed', isTrashed));
    }
    if (withStacked != null) {
      queryParams.addAll(_queryParams('', 'withStacked', withStacked));
    }
    if (withPartners != null) {
      queryParams.addAll(_queryParams('', 'withPartners', withPartners));
    }
    if (key != null) {
      queryParams.addAll(_queryParams('', 'key', key));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [TimeBucketSize] size (required):
  ///
  /// * [String] userId:
  ///
  /// * [String] albumId:
  ///
  /// * [String] personId:
  ///
  /// * [bool] isArchived:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [bool] isTrashed:
  ///
  /// * [bool] withStacked:
  ///
  /// * [bool] withPartners:
  ///
  /// * [String] key:
  Future<List<TimeBucketResponseDto>?> getTimeBuckets(TimeBucketSize size, { String? userId, String? albumId, String? personId, bool? isArchived, bool? isFavorite, bool? isTrashed, bool? withStacked, bool? withPartners, String? key, }) async {
    final response = await getTimeBucketsWithHttpInfo(size,  userId: userId, albumId: albumId, personId: personId, isArchived: isArchived, isFavorite: isFavorite, isTrashed: isTrashed, withStacked: withStacked, withPartners: withPartners, key: key, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<TimeBucketResponseDto>') as List)
        .cast<TimeBucketResponseDto>()
        .toList();

    }
    return null;
  }

  /// Use /asset/device/:deviceId instead - Remove in 1.92 release
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] deviceId (required):
  Future<Response> getUserAssetsByDeviceIdWithHttpInfo(String deviceId,) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/{deviceId}'
      .replaceAll('{deviceId}', deviceId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Use /asset/device/:deviceId instead - Remove in 1.92 release
  ///
  /// Parameters:
  ///
  /// * [String] deviceId (required):
  Future<List<String>?> getUserAssetsByDeviceId(String deviceId,) async {
    final response = await getUserAssetsByDeviceIdWithHttpInfo(deviceId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<String>') as List)
        .cast<String>()
        .toList();

    }
    return null;
  }

  /// Performs an HTTP 'POST /asset/restore' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [BulkIdsDto] bulkIdsDto (required):
  Future<Response> restoreAssetsWithHttpInfo(BulkIdsDto bulkIdsDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/restore';

    // ignore: prefer_final_locals
    Object? postBody = bulkIdsDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [BulkIdsDto] bulkIdsDto (required):
  Future<void> restoreAssets(BulkIdsDto bulkIdsDto,) async {
    final response = await restoreAssetsWithHttpInfo(bulkIdsDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'POST /asset/trash/restore' operation and returns the [Response].
  Future<Response> restoreTrashWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/asset/trash/restore';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  Future<void> restoreTrash() async {
    final response = await restoreTrashWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'POST /asset/jobs' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [AssetJobsDto] assetJobsDto (required):
  Future<Response> runAssetJobsWithHttpInfo(AssetJobsDto assetJobsDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/jobs';

    // ignore: prefer_final_locals
    Object? postBody = assetJobsDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [AssetJobsDto] assetJobsDto (required):
  Future<void> runAssetJobs(AssetJobsDto assetJobsDto,) async {
    final response = await runAssetJobsWithHttpInfo(assetJobsDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'GET /assets' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] libraryId:
  ///
  /// * [AssetTypeEnum] type:
  ///
  /// * [AssetOrder] order:
  ///
  /// * [String] deviceAssetId:
  ///
  /// * [String] deviceId:
  ///
  /// * [String] checksum:
  ///
  /// * [bool] isArchived:
  ///
  /// * [bool] isEncoded:
  ///
  /// * [bool] isExternal:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [bool] isMotion:
  ///
  /// * [bool] isOffline:
  ///
  /// * [bool] isReadOnly:
  ///
  /// * [bool] isVisible:
  ///
  /// * [bool] withDeleted:
  ///
  /// * [bool] withStacked:
  ///
  /// * [bool] withExif:
  ///
  /// * [bool] withPeople:
  ///
  /// * [DateTime] createdBefore:
  ///
  /// * [DateTime] createdAfter:
  ///
  /// * [DateTime] updatedBefore:
  ///
  /// * [DateTime] updatedAfter:
  ///
  /// * [DateTime] trashedBefore:
  ///
  /// * [DateTime] trashedAfter:
  ///
  /// * [DateTime] takenBefore:
  ///
  /// * [DateTime] takenAfter:
  ///
  /// * [String] originalFileName:
  ///
  /// * [String] originalPath:
  ///
  /// * [String] resizePath:
  ///
  /// * [String] webpPath:
  ///
  /// * [String] encodedVideoPath:
  ///
  /// * [String] city:
  ///
  /// * [String] state:
  ///
  /// * [String] country:
  ///
  /// * [String] make:
  ///
  /// * [String] model:
  ///
  /// * [String] lensModel:
  ///
  /// * [num] page:
  ///
  /// * [num] size:
  Future<Response> searchAssetsWithHttpInfo({ String? id, String? libraryId, AssetTypeEnum? type, AssetOrder? order, String? deviceAssetId, String? deviceId, String? checksum, bool? isArchived, bool? isEncoded, bool? isExternal, bool? isFavorite, bool? isMotion, bool? isOffline, bool? isReadOnly, bool? isVisible, bool? withDeleted, bool? withStacked, bool? withExif, bool? withPeople, DateTime? createdBefore, DateTime? createdAfter, DateTime? updatedBefore, DateTime? updatedAfter, DateTime? trashedBefore, DateTime? trashedAfter, DateTime? takenBefore, DateTime? takenAfter, String? originalFileName, String? originalPath, String? resizePath, String? webpPath, String? encodedVideoPath, String? city, String? state, String? country, String? make, String? model, String? lensModel, num? page, num? size, }) async {
    // ignore: prefer_const_declarations
    final path = r'/assets';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (id != null) {
      queryParams.addAll(_queryParams('', 'id', id));
    }
    if (libraryId != null) {
      queryParams.addAll(_queryParams('', 'libraryId', libraryId));
    }
    if (type != null) {
      queryParams.addAll(_queryParams('', 'type', type));
    }
    if (order != null) {
      queryParams.addAll(_queryParams('', 'order', order));
    }
    if (deviceAssetId != null) {
      queryParams.addAll(_queryParams('', 'deviceAssetId', deviceAssetId));
    }
    if (deviceId != null) {
      queryParams.addAll(_queryParams('', 'deviceId', deviceId));
    }
    if (checksum != null) {
      queryParams.addAll(_queryParams('', 'checksum', checksum));
    }
    if (isArchived != null) {
      queryParams.addAll(_queryParams('', 'isArchived', isArchived));
    }
    if (isEncoded != null) {
      queryParams.addAll(_queryParams('', 'isEncoded', isEncoded));
    }
    if (isExternal != null) {
      queryParams.addAll(_queryParams('', 'isExternal', isExternal));
    }
    if (isFavorite != null) {
      queryParams.addAll(_queryParams('', 'isFavorite', isFavorite));
    }
    if (isMotion != null) {
      queryParams.addAll(_queryParams('', 'isMotion', isMotion));
    }
    if (isOffline != null) {
      queryParams.addAll(_queryParams('', 'isOffline', isOffline));
    }
    if (isReadOnly != null) {
      queryParams.addAll(_queryParams('', 'isReadOnly', isReadOnly));
    }
    if (isVisible != null) {
      queryParams.addAll(_queryParams('', 'isVisible', isVisible));
    }
    if (withDeleted != null) {
      queryParams.addAll(_queryParams('', 'withDeleted', withDeleted));
    }
    if (withStacked != null) {
      queryParams.addAll(_queryParams('', 'withStacked', withStacked));
    }
    if (withExif != null) {
      queryParams.addAll(_queryParams('', 'withExif', withExif));
    }
    if (withPeople != null) {
      queryParams.addAll(_queryParams('', 'withPeople', withPeople));
    }
    if (createdBefore != null) {
      queryParams.addAll(_queryParams('', 'createdBefore', createdBefore));
    }
    if (createdAfter != null) {
      queryParams.addAll(_queryParams('', 'createdAfter', createdAfter));
    }
    if (updatedBefore != null) {
      queryParams.addAll(_queryParams('', 'updatedBefore', updatedBefore));
    }
    if (updatedAfter != null) {
      queryParams.addAll(_queryParams('', 'updatedAfter', updatedAfter));
    }
    if (trashedBefore != null) {
      queryParams.addAll(_queryParams('', 'trashedBefore', trashedBefore));
    }
    if (trashedAfter != null) {
      queryParams.addAll(_queryParams('', 'trashedAfter', trashedAfter));
    }
    if (takenBefore != null) {
      queryParams.addAll(_queryParams('', 'takenBefore', takenBefore));
    }
    if (takenAfter != null) {
      queryParams.addAll(_queryParams('', 'takenAfter', takenAfter));
    }
    if (originalFileName != null) {
      queryParams.addAll(_queryParams('', 'originalFileName', originalFileName));
    }
    if (originalPath != null) {
      queryParams.addAll(_queryParams('', 'originalPath', originalPath));
    }
    if (resizePath != null) {
      queryParams.addAll(_queryParams('', 'resizePath', resizePath));
    }
    if (webpPath != null) {
      queryParams.addAll(_queryParams('', 'webpPath', webpPath));
    }
    if (encodedVideoPath != null) {
      queryParams.addAll(_queryParams('', 'encodedVideoPath', encodedVideoPath));
    }
    if (city != null) {
      queryParams.addAll(_queryParams('', 'city', city));
    }
    if (state != null) {
      queryParams.addAll(_queryParams('', 'state', state));
    }
    if (country != null) {
      queryParams.addAll(_queryParams('', 'country', country));
    }
    if (make != null) {
      queryParams.addAll(_queryParams('', 'make', make));
    }
    if (model != null) {
      queryParams.addAll(_queryParams('', 'model', model));
    }
    if (lensModel != null) {
      queryParams.addAll(_queryParams('', 'lensModel', lensModel));
    }
    if (page != null) {
      queryParams.addAll(_queryParams('', 'page', page));
    }
    if (size != null) {
      queryParams.addAll(_queryParams('', 'size', size));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] libraryId:
  ///
  /// * [AssetTypeEnum] type:
  ///
  /// * [AssetOrder] order:
  ///
  /// * [String] deviceAssetId:
  ///
  /// * [String] deviceId:
  ///
  /// * [String] checksum:
  ///
  /// * [bool] isArchived:
  ///
  /// * [bool] isEncoded:
  ///
  /// * [bool] isExternal:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [bool] isMotion:
  ///
  /// * [bool] isOffline:
  ///
  /// * [bool] isReadOnly:
  ///
  /// * [bool] isVisible:
  ///
  /// * [bool] withDeleted:
  ///
  /// * [bool] withStacked:
  ///
  /// * [bool] withExif:
  ///
  /// * [bool] withPeople:
  ///
  /// * [DateTime] createdBefore:
  ///
  /// * [DateTime] createdAfter:
  ///
  /// * [DateTime] updatedBefore:
  ///
  /// * [DateTime] updatedAfter:
  ///
  /// * [DateTime] trashedBefore:
  ///
  /// * [DateTime] trashedAfter:
  ///
  /// * [DateTime] takenBefore:
  ///
  /// * [DateTime] takenAfter:
  ///
  /// * [String] originalFileName:
  ///
  /// * [String] originalPath:
  ///
  /// * [String] resizePath:
  ///
  /// * [String] webpPath:
  ///
  /// * [String] encodedVideoPath:
  ///
  /// * [String] city:
  ///
  /// * [String] state:
  ///
  /// * [String] country:
  ///
  /// * [String] make:
  ///
  /// * [String] model:
  ///
  /// * [String] lensModel:
  ///
  /// * [num] page:
  ///
  /// * [num] size:
  Future<List<AssetResponseDto>?> searchAssets({ String? id, String? libraryId, AssetTypeEnum? type, AssetOrder? order, String? deviceAssetId, String? deviceId, String? checksum, bool? isArchived, bool? isEncoded, bool? isExternal, bool? isFavorite, bool? isMotion, bool? isOffline, bool? isReadOnly, bool? isVisible, bool? withDeleted, bool? withStacked, bool? withExif, bool? withPeople, DateTime? createdBefore, DateTime? createdAfter, DateTime? updatedBefore, DateTime? updatedAfter, DateTime? trashedBefore, DateTime? trashedAfter, DateTime? takenBefore, DateTime? takenAfter, String? originalFileName, String? originalPath, String? resizePath, String? webpPath, String? encodedVideoPath, String? city, String? state, String? country, String? make, String? model, String? lensModel, num? page, num? size, }) async {
    final response = await searchAssetsWithHttpInfo( id: id, libraryId: libraryId, type: type, order: order, deviceAssetId: deviceAssetId, deviceId: deviceId, checksum: checksum, isArchived: isArchived, isEncoded: isEncoded, isExternal: isExternal, isFavorite: isFavorite, isMotion: isMotion, isOffline: isOffline, isReadOnly: isReadOnly, isVisible: isVisible, withDeleted: withDeleted, withStacked: withStacked, withExif: withExif, withPeople: withPeople, createdBefore: createdBefore, createdAfter: createdAfter, updatedBefore: updatedBefore, updatedAfter: updatedAfter, trashedBefore: trashedBefore, trashedAfter: trashedAfter, takenBefore: takenBefore, takenAfter: takenAfter, originalFileName: originalFileName, originalPath: originalPath, resizePath: resizePath, webpPath: webpPath, encodedVideoPath: encodedVideoPath, city: city, state: state, country: country, make: make, model: model, lensModel: lensModel, page: page, size: size, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AssetResponseDto>') as List)
        .cast<AssetResponseDto>()
        .toList();

    }
    return null;
  }

  /// Performs an HTTP 'GET /asset/file/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [bool] isThumb:
  ///
  /// * [bool] isWeb:
  ///
  /// * [String] key:
  Future<Response> serveFileWithHttpInfo(String id, { bool? isThumb, bool? isWeb, String? key, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/file/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (isThumb != null) {
      queryParams.addAll(_queryParams('', 'isThumb', isThumb));
    }
    if (isWeb != null) {
      queryParams.addAll(_queryParams('', 'isWeb', isWeb));
    }
    if (key != null) {
      queryParams.addAll(_queryParams('', 'key', key));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [bool] isThumb:
  ///
  /// * [bool] isWeb:
  ///
  /// * [String] key:
  Future<MultipartFile?> serveFile(String id, { bool? isThumb, bool? isWeb, String? key, }) async {
    final response = await serveFileWithHttpInfo(id,  isThumb: isThumb, isWeb: isWeb, key: key, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MultipartFile',) as MultipartFile;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /asset/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateAssetDto] updateAssetDto (required):
  Future<Response> updateAssetWithHttpInfo(String id, UpdateAssetDto updateAssetDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = updateAssetDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateAssetDto] updateAssetDto (required):
  Future<AssetResponseDto?> updateAsset(String id, UpdateAssetDto updateAssetDto,) async {
    final response = await updateAssetWithHttpInfo(id, updateAssetDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AssetResponseDto',) as AssetResponseDto;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /asset' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [AssetBulkUpdateDto] assetBulkUpdateDto (required):
  Future<Response> updateAssetsWithHttpInfo(AssetBulkUpdateDto assetBulkUpdateDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/asset';

    // ignore: prefer_final_locals
    Object? postBody = assetBulkUpdateDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [AssetBulkUpdateDto] assetBulkUpdateDto (required):
  Future<void> updateAssets(AssetBulkUpdateDto assetBulkUpdateDto,) async {
    final response = await updateAssetsWithHttpInfo(assetBulkUpdateDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'PUT /asset/stack/parent' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [UpdateStackParentDto] updateStackParentDto (required):
  Future<Response> updateStackParentWithHttpInfo(UpdateStackParentDto updateStackParentDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/stack/parent';

    // ignore: prefer_final_locals
    Object? postBody = updateStackParentDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [UpdateStackParentDto] updateStackParentDto (required):
  Future<void> updateStackParent(UpdateStackParentDto updateStackParentDto,) async {
    final response = await updateStackParentWithHttpInfo(updateStackParentDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'POST /asset/upload' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [MultipartFile] assetData (required):
  ///
  /// * [String] deviceAssetId (required):
  ///
  /// * [String] deviceId (required):
  ///
  /// * [DateTime] fileCreatedAt (required):
  ///
  /// * [DateTime] fileModifiedAt (required):
  ///
  /// * [String] key:
  ///
  /// * [String] duration:
  ///
  /// * [bool] isArchived:
  ///
  /// * [bool] isExternal:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [bool] isOffline:
  ///
  /// * [bool] isReadOnly:
  ///
  /// * [bool] isVisible:
  ///
  /// * [String] libraryId:
  ///
  /// * [MultipartFile] livePhotoData:
  ///
  /// * [MultipartFile] sidecarData:
  Future<Response> uploadFileWithHttpInfo(MultipartFile assetData, String deviceAssetId, String deviceId, DateTime fileCreatedAt, DateTime fileModifiedAt, { String? key, String? duration, bool? isArchived, bool? isExternal, bool? isFavorite, bool? isOffline, bool? isReadOnly, bool? isVisible, String? libraryId, MultipartFile? livePhotoData, MultipartFile? sidecarData, }) async {
    // ignore: prefer_const_declarations
    final path = r'/asset/upload';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (key != null) {
      queryParams.addAll(_queryParams('', 'key', key));
    }

    const contentTypes = <String>['multipart/form-data'];

    bool hasFields = false;
    final mp = MultipartRequest('POST', Uri.parse(path));
    if (assetData != null) {
      hasFields = true;
      mp.fields[r'assetData'] = assetData.field;
      mp.files.add(assetData);
    }
    if (deviceAssetId != null) {
      hasFields = true;
      mp.fields[r'deviceAssetId'] = parameterToString(deviceAssetId);
    }
    if (deviceId != null) {
      hasFields = true;
      mp.fields[r'deviceId'] = parameterToString(deviceId);
    }
    if (duration != null) {
      hasFields = true;
      mp.fields[r'duration'] = parameterToString(duration);
    }
    if (fileCreatedAt != null) {
      hasFields = true;
      mp.fields[r'fileCreatedAt'] = parameterToString(fileCreatedAt);
    }
    if (fileModifiedAt != null) {
      hasFields = true;
      mp.fields[r'fileModifiedAt'] = parameterToString(fileModifiedAt);
    }
    if (isArchived != null) {
      hasFields = true;
      mp.fields[r'isArchived'] = parameterToString(isArchived);
    }
    if (isExternal != null) {
      hasFields = true;
      mp.fields[r'isExternal'] = parameterToString(isExternal);
    }
    if (isFavorite != null) {
      hasFields = true;
      mp.fields[r'isFavorite'] = parameterToString(isFavorite);
    }
    if (isOffline != null) {
      hasFields = true;
      mp.fields[r'isOffline'] = parameterToString(isOffline);
    }
    if (isReadOnly != null) {
      hasFields = true;
      mp.fields[r'isReadOnly'] = parameterToString(isReadOnly);
    }
    if (isVisible != null) {
      hasFields = true;
      mp.fields[r'isVisible'] = parameterToString(isVisible);
    }
    if (libraryId != null) {
      hasFields = true;
      mp.fields[r'libraryId'] = parameterToString(libraryId);
    }
    if (livePhotoData != null) {
      hasFields = true;
      mp.fields[r'livePhotoData'] = livePhotoData.field;
      mp.files.add(livePhotoData);
    }
    if (sidecarData != null) {
      hasFields = true;
      mp.fields[r'sidecarData'] = sidecarData.field;
      mp.files.add(sidecarData);
    }
    if (hasFields) {
      postBody = mp;
    }

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [MultipartFile] assetData (required):
  ///
  /// * [String] deviceAssetId (required):
  ///
  /// * [String] deviceId (required):
  ///
  /// * [DateTime] fileCreatedAt (required):
  ///
  /// * [DateTime] fileModifiedAt (required):
  ///
  /// * [String] key:
  ///
  /// * [String] duration:
  ///
  /// * [bool] isArchived:
  ///
  /// * [bool] isExternal:
  ///
  /// * [bool] isFavorite:
  ///
  /// * [bool] isOffline:
  ///
  /// * [bool] isReadOnly:
  ///
  /// * [bool] isVisible:
  ///
  /// * [String] libraryId:
  ///
  /// * [MultipartFile] livePhotoData:
  ///
  /// * [MultipartFile] sidecarData:
  Future<AssetFileUploadResponseDto?> uploadFile(MultipartFile assetData, String deviceAssetId, String deviceId, DateTime fileCreatedAt, DateTime fileModifiedAt, { String? key, String? duration, bool? isArchived, bool? isExternal, bool? isFavorite, bool? isOffline, bool? isReadOnly, bool? isVisible, String? libraryId, MultipartFile? livePhotoData, MultipartFile? sidecarData, }) async {
    final response = await uploadFileWithHttpInfo(assetData, deviceAssetId, deviceId, fileCreatedAt, fileModifiedAt,  key: key, duration: duration, isArchived: isArchived, isExternal: isExternal, isFavorite: isFavorite, isOffline: isOffline, isReadOnly: isReadOnly, isVisible: isVisible, libraryId: libraryId, livePhotoData: livePhotoData, sidecarData: sidecarData, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AssetFileUploadResponseDto',) as AssetFileUploadResponseDto;
    
    }
    return null;
  }
}
