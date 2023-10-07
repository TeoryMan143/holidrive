import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holidrive/core/loading_screen.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Map/models/report_info_model.dart';
import 'package:holidrive/features/Map/presentation/report_filter.dart';
import 'package:holidrive/features/Map/widgets/custom_search_bar.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: MapController(),
      builder: (mapController) {
        return mapController.isLoading
            ? const LoadingScreen()
            : Scaffold(
                body: Stack(
                  children: <Widget>[
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: mapController.deviceLocation,
                        zoom: 16,
                      ),
                      markers: mapController.reports
                          .where((report) => mapController.activeReportTypes
                              .contains(report.type))
                          .map((report) => report.toMarker())
                          .toSet(),
                      onMapCreated: (controller) {
                        mapController.windowController.googleMapController =
                            controller;
                        mapController.googleMapController = controller;
                      },
                      onCameraMove: (position) {
                        mapController.windowController.onCameraMove!();
                      },
                      onTap: (argument) {
                        mapController.windowController.hideInfoWindow!();
                        mapController.showActiveReportsDialog = false;
                      },
                    ),
                    CustomInfoWindow(
                      controller: mapController.windowController,
                      height: 270,
                      width: 300,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          child: SizedBox(
                            height: 500,
                            width: 500,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CustomSearchBar(
                                  controller:
                                      mapController.reportsBarController,
                                  onChanged: (value) {
                                    mapController.searchReport(
                                        value.toLowerCase().trim());
                                  },
                                  onFocus: (hasFocus) {
                                    mapController.isReportsBarFocused =
                                        hasFocus;
                                  },
                                ),
                                Positioned(
                                  top: 76,
                                  left: 0,
                                  right: 0,
                                  height: 200,
                                  child: !mapController.isReportsBarFocused
                                      ? const SizedBox.shrink()
                                      : Container(
                                          width: 280,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: ListView.separated(
                                            itemCount: mapController
                                                .searchReports.length,
                                            separatorBuilder: (context, index) {
                                              return Divider(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                thickness: 1.5,
                                              );
                                            },
                                            itemBuilder: (context, index) {
                                              final report = mapController
                                                  .searchReports[index];

                                              return GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(Get.context!)
                                                      .unfocus();
                                                  mapController
                                                      .googleMapController!
                                                      .animateCamera(
                                                    CameraUpdate.newLatLng(
                                                      report.coordinates,
                                                    ),
                                                  );
                                                },
                                                child: ListTile(
                                                  leading: SvgPicture.asset(
                                                    {
                                                      ReportType.hole:
                                                          Constants.holeIcon,
                                                      ReportType.roadWork:
                                                          Constants
                                                              .roadWorkIcon,
                                                      ReportType.dangerZone:
                                                          Constants.dangerIcon,
                                                    }[report.type]!,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                      BlendMode.srcIn,
                                                    ),
                                                    height: 40,
                                                  ),
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          report.name,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Text(
                                                          '${report.time.day}-${report.time.month}-${report.time.year}')
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: !mapController.showActiveReportsDialog
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: ReportFilter(),
                            ),
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
                    currentIndex: mapController.navIndex,
                    selectedItemColor: Theme.of(context).colorScheme.surface,
                    unselectedItemColor: Theme.of(context).colorScheme.tertiary,
                    onTap: mapController.handleNavBarTap,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: const FaIcon(
                          FontAwesomeIcons.pencil,
                          size: 28,
                        ),
                        label: Messages.navItem4.tr,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(
                          Icons.remove_red_eye,
                          size: 32,
                        ),
                        label: Messages.navItem3.tr,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                      ),
                      BottomNavigationBarItem(
                        icon: const FaIcon(
                          FontAwesomeIcons.userLarge,
                          size: 32,
                        ),
                        label: Messages.navItem5.tr,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
