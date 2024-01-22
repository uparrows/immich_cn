import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:immich_mobile/modules/map/models/map_marker.dart';
import 'package:immich_mobile/shared/ui/confirm_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapUtils {
  MapUtils._();

  static final Logger _log = Logger("MapUtils");
  static const defaultSourceId = 'asset-map-markers';
  static const defaultHeatMapLayerId = 'asset-heatmap-layer';

  static const defaultHeatMapLayerProperties = HeatmapLayerProperties(
    heatmapColor: [
      Expressions.interpolate,
      ["linear"],
      ["heatmap-density"],
      0.0,
      "rgba(246,239,247,0.0)",
      0.2,
      "rgb(208,209,230)",
      0.4,
      "rgb(166,189,219)",
      0.6,
      "rgb(103,169,207)",
      0.8,
      "rgb(28,144,153)",
      1.0,
      "rgb(1,108,89)",
    ],
    heatmapIntensity: [
      Expressions.interpolate, ["linear"], //
      [Expressions.zoom],
      0, 0.5,
      9, 2,
    ],
    heatmapRadius: [
      Expressions.interpolate, ["linear"], //
      [Expressions.zoom],
      0, 4,
      4, 8,
      9, 16,
    ],
  );

  static Map<String, dynamic> _addFeature(MapMarker marker) => {
        'type': 'Feature',
        'id': marker.assetRemoteId,
        'geometry': {
          'type': 'Point',
          'coordinates': [marker.latLng.longitude, marker.latLng.latitude],
        },
      };

  static Map<String, dynamic> generateGeoJsonForMarkers(
    List<MapMarker> markers,
  ) =>
      {
        'type': 'FeatureCollection',
        'features': markers.map(_addFeature).toList(),
      };

  static Future<(Position?, LocationPermission?)> checkPermAndGetLocation(
    BuildContext context,
  ) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showDialog(
          context: context,
          builder: (context) => _LocationServiceDisabledDialog(),
        );
        return (null, LocationPermission.deniedForever);
      }

      LocationPermission permission = await Geolocator.checkPermission();
      bool shouldRequestPermission = false;

      if (permission == LocationPermission.denied) {
        shouldRequestPermission = await showDialog(
          context: context,
          builder: (context) => _LocationPermissionDisabledDialog(),
        );
        if (shouldRequestPermission) {
          permission = await Geolocator.requestPermission();
        }
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Open app settings only if you did not request for permission before
        if (permission == LocationPermission.deniedForever &&
            !shouldRequestPermission) {
          await Geolocator.openAppSettings();
        }
        return (null, LocationPermission.deniedForever);
      }

      Position currentUserLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      );
      return (currentUserLocation, null);
    } catch (error) {
      _log.severe(
        "Cannot get user's current location due to ${error.toString()}",
      );
      return (null, LocationPermission.unableToDetermine);
    }
  }
}

class _LocationServiceDisabledDialog extends ConfirmDialog {
  _LocationServiceDisabledDialog()
      : super(
          title: 'map_location_service_disabled_title'.tr(),
          content: 'map_location_service_disabled_content'.tr(),
          cancel: 'map_location_dialog_cancel'.tr(),
          ok: 'map_location_dialog_yes'.tr(),
          onOk: () async {
            await Geolocator.openLocationSettings();
          },
        );
}

class _LocationPermissionDisabledDialog extends ConfirmDialog {
  _LocationPermissionDisabledDialog()
      : super(
          title: 'map_no_location_permission_title'.tr(),
          content: 'map_no_location_permission_content'.tr(),
          cancel: 'map_location_dialog_cancel'.tr(),
          ok: 'map_location_dialog_yes'.tr(),
          onOk: () {},
        );
}
