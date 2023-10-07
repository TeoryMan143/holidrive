import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holidrive/core/controllers/use_case.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';
import 'package:holidrive/features/Map/widgets/report_preview.dart';

class ReportInfoModel {
  final String description;
  final String name;
  final String address;
  final ReportType type;
  final LatLng coordinates;
  final String id;
  final String userId;
  final DateTime time;

  ReportInfoModel({
    required this.description,
    required this.address,
    required this.type,
    required this.coordinates,
    required this.id,
    required this.userId,
    required this.time,
    required this.name,
  });

  final _mapInst = MapController.instance;
  final _coreInst = CoreState.instance;

  factory ReportInfoModel.fromJson(Map<dynamic, dynamic> json) {
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

    final coords =
        LatLng(json['coordinates']['lat'], json['coordinates']['lng']);

    return ReportInfoModel(
      description: json['description'],
      name: json['name'],
      address: json['address'],
      type: type,
      coordinates: coords,
      id: json['id'],
      userId: json['userId'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'address': address,
      'type': ({
        ReportType.hole: 'hole',
        ReportType.dangerZone: 'dangerZone',
        ReportType.roadWork: 'roadWork',
      }[type]),
      'coordinates': {
        'lat': coordinates.latitude,
        'lng': coordinates.longitude
      },
      'id': id,
      'userId': userId,
      'time': time.toString(),
      'name': name,
    };
  }

  Marker toMarker() {
    late final BitmapDescriptor icon;

    if (type == ReportType.hole) {
      icon = BitmapDescriptor.fromBytes(
        _coreInst.holeMarkerIcon,
      );
    } else if (type == ReportType.roadWork) {
      icon = BitmapDescriptor.fromBytes(
        _coreInst.roadWorkMarkerIcon,
      );
    } else if (type == ReportType.dangerZone) {
      icon = BitmapDescriptor.fromBytes(
        _coreInst.dangerMarkerIcon,
      );
    }

    return Marker(
      markerId: MarkerId(id),
      icon: icon,
      position: coordinates,
      onTap: () {
        _mapInst.windowController.addInfoWindow!(
          ReportPreview(this),
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
