import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holidrive/core/loading_screen.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Map/widgets/custom_search_bar.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final _mapController = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _mapController.isLoading
          ? const LoadingScreen()
          : Scaffold(
              body: Stack(
                children: <Widget>[
                  Obx(
                    () => GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _mapController.deviceLocation,
                        zoom: 16,
                      ),
                      markers: _mapController.reports
                          .map((report) => report.toMarker())
                          .toSet(),
                      onMapCreated: (controller) {
                        _mapController.windowController.googleMapController =
                            controller;
                      },
                      onCameraMove: (position) {
                        _mapController.windowController.onCameraMove!();
                      },
                      onTap: (argument) {
                        _mapController.windowController.hideInfoWindow!();
                      },
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          child: CustomSearchBar(),
                        ),
                      )),
                  CustomInfoWindow(
                    controller: _mapController.windowController,
                    height: 300,
                    width: 300,
                  )
                ],
              ),
              bottomNavigationBar: SizedBox(
                height: 80,
                child: BottomNavigationBar(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  selectedIconTheme: const IconThemeData(size: 40),
                  unselectedLabelStyle:
                      const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                  selectedLabelStyle:
                      const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                  showUnselectedLabels: true,
                  currentIndex: _mapController.navIndex,
                  selectedItemColor: Theme.of(context).colorScheme.surface,
                  unselectedItemColor: Theme.of(context).colorScheme.tertiary,
                  onTap: _mapController.handleNavBarTap,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(
                        Icons.house_sharp,
                        size: 32,
                      ),
                      label: Messages.navItem1.tr,
                      backgroundColor: Theme.of(context).colorScheme.background,
                    ),
                    BottomNavigationBarItem(
                      icon: const FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: 28,
                      ),
                      label: Messages.navItem2.tr,
                      backgroundColor: Theme.of(context).colorScheme.background,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(
                        Icons.remove_red_eye,
                        size: 32,
                      ),
                      label: Messages.navItem3.tr,
                      backgroundColor: Theme.of(context).colorScheme.background,
                    ),
                    BottomNavigationBarItem(
                      icon: const FaIcon(
                        FontAwesomeIcons.pencil,
                        size: 28,
                      ),
                      label: Messages.navItem4.tr,
                      backgroundColor: Theme.of(context).colorScheme.background,
                    ),
                    BottomNavigationBarItem(
                      icon: const FaIcon(
                        FontAwesomeIcons.userLarge,
                        size: 32,
                      ),
                      label: Messages.navItem5.tr,
                      backgroundColor: Theme.of(context).colorScheme.background,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
