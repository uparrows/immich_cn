import 'package:collection/collection.dart';
import 'package:immich_mobile/shared/models/asset.dart';

class SearchResultPageState {
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final bool isClip;
  final List<Asset> searchResult;

  SearchResultPageState({
    required this.isLoading,
    required this.isSuccess,
    required this.isError,
    required this.isClip,
    required this.searchResult,
  });

  SearchResultPageState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isError,
    bool? isClip,
    List<Asset>? searchResult,
  }) {
    return SearchResultPageState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isError: isError ?? this.isError,
      isClip: isClip ?? this.isClip,
      searchResult: searchResult ?? this.searchResult,
    );
  }

  @override
  String toString() {
    return 'SearchresultPageState(isLoading: $isLoading, isSuccess: $isSuccess, isError: $isError, isClip: $isClip, searchResult: $searchResult)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is SearchResultPageState &&
        other.isLoading == isLoading &&
        other.isSuccess == isSuccess &&
        other.isError == isError &&
        other.isClip == isClip &&
        listEquals(other.searchResult, searchResult);
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        isSuccess.hashCode ^
        isError.hashCode ^
        isClip.hashCode ^
        searchResult.hashCode;
  }
}
