import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holidrive/core/loading_screen.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';
import 'package:holidrive/core/constants.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final _controller = Get.put(MapController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _controller.loading
          ? const LoadingScreen()
          : Scaffold(
              body: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _controller.deviceLocation,
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('sisas'),
                        position: _controller.deviceLocation,
                      )
                    },
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SearchAnchor(
                      builder: (context, controller) => SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 25,
                          ),
                          child: SearchBar(
                            controller: controller,
                            leading: Icon(
                              Icons.search_sharp,
                              color: Theme.of(context).colorScheme.onBackground,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      suggestionsBuilder: (_, __) => [Text('')],
                    ),
                  ),
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
                  currentIndex: _controller.navIndex,
                  selectedItemColor: Theme.of(context).colorScheme.surface,
                  unselectedItemColor: Theme.of(context).colorScheme.tertiary,
                  onTap: _controller.handleNavBarTap,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: const Icon(
                          Icons.house_sharp,
                          size: 32,
                        ),
                        label: Messages.navItem1.tr,
                        backgroundColor:
                            Theme.of(context).colorScheme.background),
                    BottomNavigationBarItem(
                      icon: const FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: 28,
                      ),
                      label: Messages.navItem2.tr,
                    ),
                    BottomNavigationBarItem(
                        icon: const Icon(
                          Icons.remove_red_eye,
                          size: 32,
                        ),
                        label: Messages.navItem3.tr,
                        backgroundColor:
                            Theme.of(context).colorScheme.background),
                    BottomNavigationBarItem(
                        icon: const FaIcon(
                          FontAwesomeIcons.pencil,
                          size: 28,
                        ),
                        label: Messages.navItem4.tr,
                        backgroundColor:
                            Theme.of(context).colorScheme.background),
                    BottomNavigationBarItem(
                        icon: const FaIcon(
                          FontAwesomeIcons.userLarge,
                          size: 32,
                        ),
                        label: Messages.navItem5.tr,
                        backgroundColor:
                            Theme.of(context).colorScheme.background),
                  ],
                ),
              ),
            ),
    );
  }
}
