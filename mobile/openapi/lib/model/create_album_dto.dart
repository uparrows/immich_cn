//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateAlbumDto {
  /// Returns a new [CreateAlbumDto] instance.
  CreateAlbumDto({
    required this.albumName,
    this.assetIds = const [],
    this.description,
    this.sharedWithUserIds = const [],
  });

  String albumName;

  List<String> assetIds;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  List<String> sharedWithUserIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateAlbumDto &&
     other.albumName == albumName &&
     other.assetIds == assetIds &&
     other.description == description &&
     other.sharedWithUserIds == sharedWithUserIds;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (albumName.hashCode) +
    (assetIds.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (sharedWithUserIds.hashCode);

  @override
  String toString() => 'CreateAlbumDto[albumName=$albumName, assetIds=$assetIds, description=$description, sharedWithUserIds=$sharedWithUserIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'albumName'] = this.albumName;
      json[r'assetIds'] = this.assetIds;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
    //  json[r'description'] = null;
    }
      json[r'sharedWithUserIds'] = this.sharedWithUserIds;
    return json;
  }

  /// Returns a new [CreateAlbumDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateAlbumDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return CreateAlbumDto(
        albumName: mapValueOfType<String>(json, r'albumName')!,
        assetIds: json[r'assetIds'] is List
            ? (json[r'assetIds'] as List).cast<String>()
            : const [],
        description: mapValueOfType<String>(json, r'description'),
        sharedWithUserIds: json[r'sharedWithUserIds'] is List
            ? (json[r'sharedWithUserIds'] as List).cast<String>()
            : const [],
      );
    }
    return null;
  }

  static List<CreateAlbumDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateAlbumDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateAlbumDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateAlbumDto> mapFromJson(dynamic json) {
    final map = <String, CreateAlbumDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateAlbumDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateAlbumDto-objects as value to a dart map
  static Map<String, List<CreateAlbumDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateAlbumDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateAlbumDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'albumName',
  };
}

