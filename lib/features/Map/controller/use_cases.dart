import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holidrive/features/Map/presentation/profile_screen.dart';
import 'package:location/location.dart';

class MapController extends GetxController {
  MapController() {
    _navActions = [
      () => '',
      () => '',
      () => '',
      () => '',
      () {
        _bottomSheet(ProfileScreen());
      },
    ];
  }

  final _location = Location();

  final _deviceLocation = const LatLng(0, 0).obs;
  LatLng get deviceLocation => _deviceLocation.value;

  final _loading = false.obs;
  bool get loading => _loading.value;

  final _navIndex = 1.obs;
  int get navIndex => _navIndex.value;

  @override
  void onReady() async {
    super.onReady();
    await activateInitialCameraPosition();
  }

  Future<void> activateInitialCameraPosition() async {
    _loading(true);
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
    _loading(false);
  }

  void _bottomSheet(Widget content) {
    showModalBottomSheet(
        context: Get.context!,
        builder: (context) => content,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(45),
          ),
        ));
  }

  late final List<void Function()> _navActions;

  void handleNavBarTap(int index) {
    _navIndex(index);
    _navActions[index]();
  }
}
