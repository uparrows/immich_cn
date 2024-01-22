//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ServerFeaturesDto {
  /// Returns a new [ServerFeaturesDto] instance.
  ServerFeaturesDto({
    required this.clipEncode,
    required this.configFile,
    required this.facialRecognition,
    required this.map,
    required this.oauth,
    required this.oauthAutoLaunch,
    required this.passwordLogin,
    required this.reverseGeocoding,
    required this.search,
    required this.sidecar,
    required this.trash,
  });

  bool clipEncode;

  bool configFile;

  bool facialRecognition;

  bool map;

  bool oauth;

  bool oauthAutoLaunch;

  bool passwordLogin;

  bool reverseGeocoding;

  bool search;

  bool sidecar;

  bool trash;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ServerFeaturesDto &&
     other.clipEncode == clipEncode &&
     other.configFile == configFile &&
     other.facialRecognition == facialRecognition &&
     other.map == map &&
     other.oauth == oauth &&
     other.oauthAutoLaunch == oauthAutoLaunch &&
     other.passwordLogin == passwordLogin &&
     other.reverseGeocoding == reverseGeocoding &&
     other.search == search &&
     other.sidecar == sidecar &&
     other.trash == trash;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (clipEncode.hashCode) +
    (configFile.hashCode) +
    (facialRecognition.hashCode) +
    (map.hashCode) +
    (oauth.hashCode) +
    (oauthAutoLaunch.hashCode) +
    (passwordLogin.hashCode) +
    (reverseGeocoding.hashCode) +
    (search.hashCode) +
    (sidecar.hashCode) +
    (trash.hashCode);

  @override
  String toString() => 'ServerFeaturesDto[clipEncode=$clipEncode, configFile=$configFile, facialRecognition=$facialRecognition, map=$map, oauth=$oauth, oauthAutoLaunch=$oauthAutoLaunch, passwordLogin=$passwordLogin, reverseGeocoding=$reverseGeocoding, search=$search, sidecar=$sidecar, trash=$trash]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'clipEncode'] = this.clipEncode;
      json[r'configFile'] = this.configFile;
      json[r'facialRecognition'] = this.facialRecognition;
      json[r'map'] = this.map;
      json[r'oauth'] = this.oauth;
      json[r'oauthAutoLaunch'] = this.oauthAutoLaunch;
      json[r'passwordLogin'] = this.passwordLogin;
      json[r'reverseGeocoding'] = this.reverseGeocoding;
      json[r'search'] = this.search;
      json[r'sidecar'] = this.sidecar;
      json[r'trash'] = this.trash;
    return json;
  }

  /// Returns a new [ServerFeaturesDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ServerFeaturesDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return ServerFeaturesDto(
        clipEncode: mapValueOfType<bool>(json, r'clipEncode')!,
        configFile: mapValueOfType<bool>(json, r'configFile')!,
        facialRecognition: mapValueOfType<bool>(json, r'facialRecognition')!,
        map: mapValueOfType<bool>(json, r'map')!,
        oauth: mapValueOfType<bool>(json, r'oauth')!,
        oauthAutoLaunch: mapValueOfType<bool>(json, r'oauthAutoLaunch')!,
        passwordLogin: mapValueOfType<bool>(json, r'passwordLogin')!,
        reverseGeocoding: mapValueOfType<bool>(json, r'reverseGeocoding')!,
        search: mapValueOfType<bool>(json, r'search')!,
        sidecar: mapValueOfType<bool>(json, r'sidecar')!,
        trash: mapValueOfType<bool>(json, r'trash')!,
      );
    }
    return null;
  }

  static List<ServerFeaturesDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ServerFeaturesDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ServerFeaturesDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ServerFeaturesDto> mapFromJson(dynamic json) {
    final map = <String, ServerFeaturesDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ServerFeaturesDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ServerFeaturesDto-objects as value to a dart map
  static Map<String, List<ServerFeaturesDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ServerFeaturesDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ServerFeaturesDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'clipEncode',
    'configFile',
    'facialRecognition',
    'map',
    'oauth',
    'oauthAutoLaunch',
    'passwordLogin',
    'reverseGeocoding',
    'search',
    'sidecar',
    'trash',
  };
}

