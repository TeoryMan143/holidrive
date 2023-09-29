import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    this.onChanged,
    this.controller,
    this.locator = false,
    this.onFocus,
  });

  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool locator;
  final void Function()? onFocus;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  var tapped = false;
  var fieldFocused = false;

  final _mapController = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              fieldFocused = hasFocus;
            });
          },
          child: TextFormField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_sharp),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(17)),
              ),
            ),
            onChanged: widget.onChanged,
            controller: widget.controller,
            onTap: () {
              setState(() {
                tapped = true;
              });
            },
          ),
        ),
        if (widget.locator)
          if (!tapped)
            Positioned(
              top: -20,
              child: Text(
                Messages.curretLocationLabel.tr,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
        Builder(
          builder: (context) {
            if (fieldFocused) {
              return Positioned(
                child: Expanded(
                    child: ListView.builder(
                  itemCount: _mapController.reportQueryResults.length,
                  itemBuilder: (context, index) {
                    final address = _mapController.reportQueryResults[index];
                    return ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      title: const Text(''),
                    );
                  },
                )),
              );
            }
            return const SizedBox.shrink();
          },
        )
      ],
    );
  }
}
