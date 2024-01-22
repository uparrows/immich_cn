//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SystemConfigDto {
  /// Returns a new [SystemConfigDto] instance.
  SystemConfigDto({
    required this.ffmpeg,
    required this.job,
    required this.library_,
    required this.logging,
    required this.machineLearning,
    required this.map,
    required this.newVersionCheck,
    required this.oauth,
    required this.passwordLogin,
    required this.reverseGeocoding,
    required this.server,
    required this.storageTemplate,
    required this.theme,
    required this.thumbnail,
    required this.trash,
  });

  SystemConfigFFmpegDto ffmpeg;

  SystemConfigJobDto job;

  SystemConfigLibraryDto library_;

  SystemConfigLoggingDto logging;

  SystemConfigMachineLearningDto machineLearning;

  SystemConfigMapDto map;

  SystemConfigNewVersionCheckDto newVersionCheck;

  SystemConfigOAuthDto oauth;

  SystemConfigPasswordLoginDto passwordLogin;

  SystemConfigReverseGeocodingDto reverseGeocoding;

  SystemConfigServerDto server;

  SystemConfigStorageTemplateDto storageTemplate;

  SystemConfigThemeDto theme;

  SystemConfigThumbnailDto thumbnail;

  SystemConfigTrashDto trash;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SystemConfigDto &&
     other.ffmpeg == ffmpeg &&
     other.job == job &&
     other.library_ == library_ &&
     other.logging == logging &&
     other.machineLearning == machineLearning &&
     other.map == map &&
     other.newVersionCheck == newVersionCheck &&
     other.oauth == oauth &&
     other.passwordLogin == passwordLogin &&
     other.reverseGeocoding == reverseGeocoding &&
     other.server == server &&
     other.storageTemplate == storageTemplate &&
     other.theme == theme &&
     other.thumbnail == thumbnail &&
     other.trash == trash;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (ffmpeg.hashCode) +
    (job.hashCode) +
    (library_.hashCode) +
    (logging.hashCode) +
    (machineLearning.hashCode) +
    (map.hashCode) +
    (newVersionCheck.hashCode) +
    (oauth.hashCode) +
    (passwordLogin.hashCode) +
    (reverseGeocoding.hashCode) +
    (server.hashCode) +
    (storageTemplate.hashCode) +
    (theme.hashCode) +
    (thumbnail.hashCode) +
    (trash.hashCode);

  @override
  String toString() => 'SystemConfigDto[ffmpeg=$ffmpeg, job=$job, library_=$library_, logging=$logging, machineLearning=$machineLearning, map=$map, newVersionCheck=$newVersionCheck, oauth=$oauth, passwordLogin=$passwordLogin, reverseGeocoding=$reverseGeocoding, server=$server, storageTemplate=$storageTemplate, theme=$theme, thumbnail=$thumbnail, trash=$trash]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'ffmpeg'] = this.ffmpeg;
      json[r'job'] = this.job;
      json[r'library'] = this.library_;
      json[r'logging'] = this.logging;
      json[r'machineLearning'] = this.machineLearning;
      json[r'map'] = this.map;
      json[r'newVersionCheck'] = this.newVersionCheck;
      json[r'oauth'] = this.oauth;
      json[r'passwordLogin'] = this.passwordLogin;
      json[r'reverseGeocoding'] = this.reverseGeocoding;
      json[r'server'] = this.server;
      json[r'storageTemplate'] = this.storageTemplate;
      json[r'theme'] = this.theme;
      json[r'thumbnail'] = this.thumbnail;
      json[r'trash'] = this.trash;
    return json;
  }

  /// Returns a new [SystemConfigDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SystemConfigDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return SystemConfigDto(
        ffmpeg: SystemConfigFFmpegDto.fromJson(json[r'ffmpeg'])!,
        job: SystemConfigJobDto.fromJson(json[r'job'])!,
        library_: SystemConfigLibraryDto.fromJson(json[r'library'])!,
        logging: SystemConfigLoggingDto.fromJson(json[r'logging'])!,
        machineLearning: SystemConfigMachineLearningDto.fromJson(json[r'machineLearning'])!,
        map: SystemConfigMapDto.fromJson(json[r'map'])!,
        newVersionCheck: SystemConfigNewVersionCheckDto.fromJson(json[r'newVersionCheck'])!,
        oauth: SystemConfigOAuthDto.fromJson(json[r'oauth'])!,
        passwordLogin: SystemConfigPasswordLoginDto.fromJson(json[r'passwordLogin'])!,
        reverseGeocoding: SystemConfigReverseGeocodingDto.fromJson(json[r'reverseGeocoding'])!,
        server: SystemConfigServerDto.fromJson(json[r'server'])!,
        storageTemplate: SystemConfigStorageTemplateDto.fromJson(json[r'storageTemplate'])!,
        theme: SystemConfigThemeDto.fromJson(json[r'theme'])!,
        thumbnail: SystemConfigThumbnailDto.fromJson(json[r'thumbnail'])!,
        trash: SystemConfigTrashDto.fromJson(json[r'trash'])!,
      );
    }
    return null;
  }

  static List<SystemConfigDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SystemConfigDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SystemConfigDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SystemConfigDto> mapFromJson(dynamic json) {
    final map = <String, SystemConfigDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SystemConfigDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SystemConfigDto-objects as value to a dart map
  static Map<String, List<SystemConfigDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SystemConfigDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SystemConfigDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'ffmpeg',
    'job',
    'library',
    'logging',
    'machineLearning',
    'map',
    'newVersionCheck',
    'oauth',
    'passwordLogin',
    'reverseGeocoding',
    'server',
    'storageTemplate',
    'theme',
    'thumbnail',
    'trash',
  };
}

