import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holidrive/core/controllers/storage_controller.dart';
import 'package:holidrive/features/Map/models/report_info_model.dart';
import 'package:holidrive/features/Map/presentation/profile_screen.dart';
import 'package:holidrive/features/Map/presentation/publication_screen.dart';
import 'package:location/location.dart';

class MapController extends GetxController {
  MapController() {
    _navActions = [
      () => '',
      () => '',
      () => '',
      () async {
        try {
          _isLoading(true);
          _bottomSheet(PublicationScreen());
          _currentLocationAdress.value = await _getCurrentLocationAdress();
        } finally {
          _isLoading(false);
        }
      },
      () => _bottomSheet(ProfileScreen()),
    ];
  }

  static final instance = Get.find<MapController>();

  final _storage = StorageRepository.instance;
  final _location = Location();

  final _deviceLocation = const LatLng(0, 0).obs;
  LatLng get deviceLocation => _deviceLocation.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _navIndex = 1.obs;
  int get navIndex => _navIndex.value;

  final windowController = CustomInfoWindowController();

  var _reportType = ReportType.hole;

  final _reportTypeIndex = 0.obs;
  int get reporTypeIndex => _reportTypeIndex.value;
  set reporTypeIndex(int value) {
    _reportTypeIndex(value);
    _reportType = [
      ReportType.hole,
      ReportType.roadWork,
      ReportType.dangerZone,
    ][_reportTypeIndex.value];
  }

  late LatLng _reportLocation;

  void setReportLocation(LatLng location) => _reportLocation = location;

  final Rx<String?> _currentLocationAdress = ''.obs;
  String? get currentLocationAdress => _currentLocationAdress.value;

  Future<String?> _getCurrentLocationAdress() async {
    final adresses = await Geocoder.local.findAddressesFromCoordinates(
      Coordinates(
        _deviceLocation.value.latitude,
        _deviceLocation.value.longitude,
      ),
    );
    final first = adresses.first;

    return first.addressLine;
  }

  RxList<Address> reportQueryResults = <Address>[].obs;

  void searchFromQuery(String query) async {
    reportQueryResults(await Geocoder.local.findAddressesFromQuery(query));
  }

  @override
  void onReady() async {
    super.onReady();
    await _activateInitialCameraPosition();
  }

  Future<void> _activateInitialCameraPosition() async {
    _isLoading(true);
    var serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        _deviceLocation.value = const LatLng(0, 0);
        return;
      }
    }

    var permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _deviceLocation.value = const LatLng(0, 0);
        return;
      }
    }

    final deviceLocationData = await _location.getLocation();
    _deviceLocation.value = LatLng(
      deviceLocationData.latitude!,
      deviceLocationData.longitude!,
    );
    _reportLocation = _deviceLocation.value;

    _isLoading(false);
  }

  void _bottomSheet(Widget content) {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) => content,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(45),
        ),
      ),
    );
  }

  late final List<void Function()> _navActions;

  void handleNavBarTap(int index) {
    _navIndex(index);
    _navActions[index]();
  }

  Future<void> uploadProfilePicture(String filePath, String fileName) async {
    await _storage.uploadFile(fileName, filePath, 'profilePictures');
  }
}
