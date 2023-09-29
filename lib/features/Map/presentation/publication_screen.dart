import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';
import 'package:holidrive/features/Map/widgets/custom_search_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:holidrive/features/Map/widgets/report_options.dart';

class PublicationScreen extends StatelessWidget {
  PublicationScreen({super.key});

  final _authController = Get.put(AuthController());
  final _mapController = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        height: MediaQuery.of(context).size.height - 120,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 3,
                indent: 90,
                endIndent: 90,
              ),
              const SizedBox(height: 10),
              Obx(
                () => _authController.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _authController.user!.fullName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontFamily: 'Poppins',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontSize: 26,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                Messages.yourProfile.tr,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: DecorationImage(
                                image: _authController.user!.profilePicture ==
                                        null
                                    ? const AssetImage(Constants.defaultPfp)
                                        as ImageProvider
                                    : NetworkImage(
                                        _authController.user!.profilePicture!,
                                      ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50.0)),
                              border: Border.all(
                                width: 3.0,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          )
                        ],
                      ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Text(
                      Messages.whatToReport.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontFamily: 'Poppins',
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 21,
                          ),
                    ),
                    const SizedBox(height: 20),
                    ReportOptions(),
                    const SizedBox(height: 25),
                    Text(
                      Messages.whereToReport.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontFamily: 'Poppins',
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 21,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => _mapController.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomSearchBar(
                              controller: TextEditingController(
                                text: _mapController.currentLocationAdress,
                              ),
                              locator: true,
                              onFocus: () => print('focus assss'),
                            ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      Messages.description.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontFamily: 'Poppins',
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 21,
                          ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                        ),
                      ),
                      minLines: 3,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      Messages.evidence.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontFamily: 'Poppins',
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 21,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        child: DottedBorder(
                          strokeWidth: 2,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 50,
                          ),
                          color: Theme.of(context).colorScheme.primary,
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                color: Theme.of(context).colorScheme.primary,
                                size: 100,
                              ),
                              Text(
                                Messages.addPictures.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => '',
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            Messages.publishButton.tr,
                            style: const TextStyle(fontSize: 23),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
