import 'dart:math';

import 'package:flutter/services.dart';
import 'package:immich_mobile/modules/map/models/map_marker.dart';
import 'package:immich_mobile/modules/map/utils/map_utils.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

extension MapMarkers on MaplibreMapController {
  Future<void> addGeoJSONSourceForMarkers(List<MapMarker> markers) async {
    return addSource(
      MapUtils.defaultSourceId,
      GeojsonSourceProperties(
        data: MapUtils.generateGeoJsonForMarkers(markers.toList()),
      ),
    );
  }

  Future<void> reloadAllLayersForMarkers(List<MapMarker> markers) async {
    // !! Make sure to remove layers before sources else the native
    // maplibre library would crash when removing the source saying that
    // the source is still in use
    final existingLayers = await getLayerIds();
    if (existingLayers.contains(MapUtils.defaultHeatMapLayerId)) {
      await removeLayer(MapUtils.defaultHeatMapLayerId);
    }

    final existingSources = await getSourceIds();
    if (existingSources.contains(MapUtils.defaultSourceId)) {
      await removeSource(MapUtils.defaultSourceId);
    }

    await addGeoJSONSourceForMarkers(markers);

    await addHeatmapLayer(
      MapUtils.defaultSourceId,
      MapUtils.defaultHeatMapLayerId,
      MapUtils.defaultHeatMapLayerProperties,
    );
  }

  Future<Symbol?> addMarkerAtLatLng(LatLng centre) async {
    // no marker is displayed if asset-path is incorrect
    try {
      final ByteData bytes = await rootBundle.load("assets/location-pin.png");
      await addImage("mapMarker", bytes.buffer.asUint8List());
      return addSymbol(
        SymbolOptions(
          geometry: centre,
          iconImage: "mapMarker",
          iconSize: 0.15,
          iconAnchor: "bottom",
        ),
      );
    } finally {
      // no-op
    }
  }

  Future<LatLngBounds> getBoundsFromPoint(
    Point<double> point,
    double distance,
  ) async {
    final southWestPx = Point(point.x - distance, point.y + distance);
    final northEastPx = Point(point.x + distance, point.y - distance);

    final southWest = await toLatLng(southWestPx);
    final northEast = await toLatLng(northEastPx);

    return LatLngBounds(southwest: southWest, northeast: northEast);
  }
}
