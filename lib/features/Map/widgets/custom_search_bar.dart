import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';

class CustomSearchBar extends StatelessWidget {
  CustomSearchBar({
    super.key,
    this.onChanged,
    this.controller,
    this.locator = false,
    this.onFocus,
  });

  final void Function(String value)? onChanged;
  final TextEditingController? controller;
  final bool locator;
  final void Function(bool hasFocus)? onFocus;

  final _mapController = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Focus(
          onFocusChange: (hasFocus) {
            _mapController.isSearchBarFocused = hasFocus;

            if (onFocus != null) {
              onFocus!(hasFocus);
            }
            if (locator && !hasFocus) {
              _mapController.reportLocationController.text =
                  _mapController.selectedLocationAdress!;
            }
            if (locator && hasFocus) {
              _mapController.reportLocationController.text = '';
            }
          },
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_sharp),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(17)),
              ),
            ),
            onChanged: onChanged,
            controller: controller,
            enableInteractiveSelection: true,
            onTap: () {},
          ),
        ),
        Positioned(
          top: -20,
          child: Obx(
            () => _mapController.isLoading
                ? const CircularProgressIndicator()
                : !locator ||
                        _mapController.reportLocation !=
                            _mapController.deviceLocation
                    ? const SizedBox.shrink()
                    : Text(
                        Messages.curretLocationLabel.tr,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}
