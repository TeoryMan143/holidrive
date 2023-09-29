import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';
import 'package:holidrive/features/Map/presentation/report_preview.dart';

class ReportInfoModel {
  final String description;
  final String location;
  final ReportType type;
  final LatLng coordinates;
  final String id;
  final String imagesId;

  ReportInfoModel({
    required this.description,
    required this.location,
    required this.type,
    required this.coordinates,
    required this.id,
    required this.imagesId,
  });

  final _mapInst = MapController.instance;

  factory ReportInfoModel.fromJson(Map<String, dynamic> json) {
    final ReportType type;

    switch (json['type']) {
      case 'hole':
        type = ReportType.hole;
        break;
      case 'roadWork':
        type = ReportType.roadWork;
        break;
      case 'dangerZone':
        type = ReportType.dangerZone;
        break;
      default:
        type = ReportType.hole;
    }

    final coords = LatLng(
        json['coordinates']['latitude'], json['coordinates']['longitude']);

    return ReportInfoModel(
      description: json['description'],
      location: json['location'],
      type: type,
      coordinates: coords,
      id: json['id'],
      imagesId: json['imagesId'],
    );
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Marker> toMarker() async {
    late final BitmapDescriptor icon;

    if (type == ReportType.hole) {
      icon = BitmapDescriptor.fromBytes(
        await _getBytesFromAsset(Constants.holeMarkerImg, 90),
      );
    } else if (type == ReportType.roadWork) {
      icon = BitmapDescriptor.fromBytes(
        await _getBytesFromAsset(Constants.roadWorkMarkerImg, 90),
      );
    } else if (type == ReportType.dangerZone) {
      icon = BitmapDescriptor.fromBytes(
        await _getBytesFromAsset(Constants.dangerZoneMargerImg, 90),
      );
    }

    return Marker(
      markerId: MarkerId(id),
      icon: icon,
      position: coordinates,
      onTap: () {
        _mapInst.windowController.addInfoWindow!(
          ReportPreview(
            displayImage:
                'https://www.cattipper.com/wp-content/uploads/2023/08/featured-Whats-the-Name-of-the-Cat-in-the-Smurfs.jpg',
            location: location,
            description: description,
            type: type,
          ),
          coordinates,
        );
      },
    );
  }
}

enum ReportType {
  hole,
  roadWork,
  dangerZone,
}
