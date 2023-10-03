import 'dart:io';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/core/controllers/database_repository.dart';
import 'package:holidrive/core/controllers/geocode_api.dart';
import 'package:holidrive/core/controllers/storage_controller.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';
import 'package:holidrive/features/Authentication/widgets/error_dialog.dart';
import 'package:holidrive/features/Map/models/report_info_model.dart';
import 'package:holidrive/features/Map/presentation/profile_screen.dart';
import 'package:holidrive/features/Map/presentation/publication_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class MapController extends GetxController {
  static final instance = Get.find<MapController>();

  final _authInst = Get.put(AuthController());

  final _storageRepo = StorageRepository.instance;
  final _location = Location();

  var _opened = false;

  final _deviceLocation = const LatLng(0, 0).obs;
  LatLng get deviceLocation => _deviceLocation.value;

  final _isLoadingPubScreen = false.obs;
  bool get isLoadingPubScreen => _isLoadingPubScreen.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isQueryLoading = false.obs;
  bool get isQueryLoading => _isQueryLoading.value;

  final _reportImagesLoading = false.obs;
  bool get reportImagesLoading => _reportImagesLoading.value;

  final _navIndex = 1.obs;
  int get navIndex => _navIndex.value;

  final windowController = CustomInfoWindowController();

  late TextEditingController reportLocationController;
  final reportDesciptionController = TextEditingController();

  var _reportType = ReportType.hole;

  final imagePicker = ImagePicker();

  var reportImages = <File>[].obs;

  @override
  void onReady() async {
    super.onReady();
    await _activateInitialCameraPosition();
    _navActions = [
      () => '',
      () => '',
      () => '',
      () async {
        try {
          _isLoadingPubScreen(true);
          if (_opened) {
            reportLocationController = TextEditingController(
              text: _selectedtLocationAdress.value,
            );
          } else {
            _currentLocationAdress.value = await _getCurrentLocationAdress();
            _selectedtLocationAdress.value = _currentLocationAdress.value;
            reportLocationController = TextEditingController(
              text: _selectedtLocationAdress.value,
            );
            _opened = true;
          }
          _bottomSheet(PublicationScreen());
        } finally {
          _isLoadingPubScreen(false);
        }
      },
      () => _bottomSheet(ProfileScreen()),
    ];
    DatabaseRepository.getDataUpdate('reports', (event) {
      final data = event.snapshot.value;

      final reportsData = (data as Map).cast<String, dynamic>();

      reports = reportsData.entries
          .map((e) {
            final report = e.value as Map;
            return ReportInfoModel.fromJson(report);
          })
          .toList()
          .obs;
    });
  }

  var reports = <ReportInfoModel>[].obs;

  Future<void> _activateInitialCameraPosition() async {
    _isLoading(true);
    var serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        _deviceLocation.value = const LatLng(0, 0);
        _isLoading(false);
        return;
      }
    }

    var permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _deviceLocation.value = const LatLng(0, 0);
        _isLoading(false);
        return;
      }
    }

    final deviceLocationData = await _location.getLocation();
    _deviceLocation.value = LatLng(
      deviceLocationData.latitude!,
      deviceLocationData.longitude!,
    );
    _reportLocation = Rx<LatLng>(_deviceLocation.value);

    _isLoading(false);
  }

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

  late Rx<LatLng?> _reportLocation;
  LatLng get reportLocation => _reportLocation.value!;

  final Rx<String?> _selectedtLocationAdress = ''.obs;
  String? get selectedLocationAdress => _selectedtLocationAdress.value;

  final _isSearchBarFocused = false.obs;
  bool get isSearchBarFocused => _isSearchBarFocused.value;
  set isSearchBarFocused(bool value) => _isSearchBarFocused.value = value;

  final Rx<String?> _currentLocationAdress = ''.obs;
  String? get currentLocationAdress => _currentLocationAdress.value;

  void setReportLocation(String address, LatLng coords) {
    _selectedtLocationAdress(address);
    _reportLocation.value = coords;
    FocusScope.of(Get.context!).unfocus();
  }

  void selectCurrentLocation() {
    reportLocationController.text = _currentLocationAdress.value!;
    debugPrint(
        '${_currentLocationAdress.value}, ${reportLocationController.text}');
    _reportLocation = Rx<LatLng>(_deviceLocation.value);
    FocusScope.of(Get.context!).unfocus();
  }

  Future<String?> _getCurrentLocationAdress() async {
    final response =
        await GeocodingAPI.getCurrentLocationAddress(_deviceLocation.value);
    final address = response?['results'][0]['formatted_address'] as String;
    return address;
  }

  RxList<Map<String, dynamic>> reportQueryResults =
      <Map<String, dynamic>>[].obs;

  Future<void> searchFromQuery(String query) async {
    try {
      _isQueryLoading(true);
      final response = await GeocodingAPI.getLocationPlacesFromQuery(query);
      final queryList = response?['results'];
      if (queryList != null) {
        final resultList = (queryList as List).cast<Map<String, dynamic>>();
        reportQueryResults([{}, ...resultList]);
      } else {
        reportQueryResults([]);
      }
    } finally {
      _isQueryLoading(false);
    }
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
    await _storageRepo.uploadFile(fileName, filePath, 'profilePictures');
  }

  Future<void> uploadReportImage() async {
    _reportImagesLoading(true);
    final images = await imagePicker.pickMultiImage();

    if (images.isEmpty) {
      errorDialog(
        title: Messages.noImagesTit.tr,
        body: Messages.noImagesCont.tr,
      );
      _reportImagesLoading(false);
      return;
    }

    if (images.length > 4) {
      errorDialog(
        title: Messages.overImagesTit.tr,
        body: Messages.overImagesCont.tr,
      );
      _reportImagesLoading(false);
      return;
    }

    reportImages = images.map((e) => File(e.path)).toList().obs;
    reportImages.refresh();
    debugPrint(reportImages.length.toString());
    _reportImagesLoading(false);
  }

  Future<void> addMoreImages() async {
    _reportImagesLoading(true);
    final images = await imagePicker.pickMultiImage();

    if (images.isEmpty) {
      _reportImagesLoading(false);
      return;
    }

    if (images.length + reportImages.length > 4) {
      errorDialog(
        title: Messages.overImagesTit.tr,
        body: Messages.overImagesCont.tr,
      );
      _reportImagesLoading(false);
      return;
    }

    final selectedImages = images.map((e) => File(e.path)).toList().obs;

    reportImages = [...reportImages, ...selectedImages].obs;
    _reportImagesLoading(false);
  }

  void deleteSlectedImage(File image) {
    _reportImagesLoading(true);
    reportImages.remove(image);
    _reportImagesLoading(false);
  }

  void _resetFields() {
    _reportType = ReportType.hole;
    _reportTypeIndex(0);
    _reportLocation.value = _deviceLocation.value;
    _selectedtLocationAdress.value = '';
    reportImages = <File>[].obs;
    reportDesciptionController.text = '';
    _opened = false;
  }

  final _isLoadingUpload = false.obs;
  bool get isLoadingUpload => _isLoadingUpload.value;

  Future<void> _loadingDialog() async {
    Get.dialog(
      Obx(
        () => AlertDialog.adaptive(
          title: Text(
            instance.isLoadingUpload
                ? Messages.uploading.tr
                : Messages.uploadFinished.tr,
            style: Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(Get.context!).colorScheme.surface,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
          ),
          content: instance.isLoadingUpload
              ? const SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Image.asset(
                  Constants.loadingGif,
                  height: 200,
                ),
        ),
      ),
    );
  }

  Future<void> uploadReport() async {
    _isLoadingUpload(true);

    final id = const Uuid().v1();

    if (_selectedtLocationAdress.value!.isEmpty ||
        _reportLocation.value == null ||
        reportImages.isEmpty) {
      _isLoadingUpload(false);
      return;
    }

    _loadingDialog();

    final report = ReportInfoModel(
      description: reportDesciptionController.text,
      address: _selectedtLocationAdress.value!,
      type: _reportType,
      coordinates: _reportLocation.value!,
      id: id,
      userId: _authInst.user!.uid,
      time: DateTime.now(),
    );

    await DatabaseRepository.setData('reports/$id', report.toJson());

    for (var image in reportImages) {
      await _storageRepo.uploadFile(
        '${reportImages.indexOf(image).toString()}evi',
        image.path,
        'avidence/$id',
      );
    }

    _isLoadingUpload(false);
    Future.delayed(const Duration(milliseconds: 500), Get.back);
    Get.back();
    _resetFields();
  }
}
