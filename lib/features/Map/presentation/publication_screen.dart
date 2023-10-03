import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';
import 'package:holidrive/features/Map/widgets/custom_search_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:holidrive/features/Map/widgets/report_options.dart';

class PublicationScreen extends StatelessWidget {
  PublicationScreen({super.key});

  final _authController = Get.put(AuthController());
  final _mapController = MapController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                            SizedBox(
                              width: 220,
                              child: Text(
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
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              Messages.publishReportTit.tr,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                              image:
                                  _authController.user!.profilePicture == null
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
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        )
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Messages.whatToReport.tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontFamily: 'Poppins',
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 21,
                              ),
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => _mapController.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : CustomSearchBar(
                                  controller:
                                      _mapController.reportLocationController,
                                  locator: true,
                                  onChanged: (value) async {
                                    await _mapController.searchFromQuery(value);
                                  },
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 21,
                              ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.background,
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17)),
                            ),
                          ),
                          minLines: 3,
                          maxLines: 4,
                          controller: _mapController.reportDesciptionController,
                        ),
                        const SizedBox(height: 25),
                        Text(
                          Messages.evidence.tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontFamily: 'Poppins',
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 21,
                              ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: DottedBorder(
                            strokeWidth: 2,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 50,
                            ),
                            color: Theme.of(context).colorScheme.primary,
                            child: Obx(
                              () => _mapController.reportImages.isEmpty
                                  ? _mapController.reportImagesLoading
                                      ? const CircularProgressIndicator()
                                      : Center(
                                          child: GestureDetector(
                                            onTap: () async =>
                                                await _mapController
                                                    .uploadReportImage(),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.camera_alt,
                                                  color:
                                                      _mapController
                                                                  .reportImages
                                                                  .length >=
                                                              4
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .tertiary
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                  size: 100,
                                                ),
                                                Text(
                                                  Messages.addPictures.tr,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.copyWith(
                                                        color: _mapController
                                                                    .reportImages
                                                                    .length >=
                                                                4
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .tertiary
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                  : _mapController.reportImagesLoading
                                      ? const CircularProgressIndicator()
                                      : Column(
                                          children: [
                                            Wrap(
                                              children: <Widget>[
                                                for (var image in _mapController
                                                    .reportImages)
                                                  SizedBox(
                                                    height: 110,
                                                    width: 110,
                                                    child: Stack(
                                                      children: [
                                                        Image.file(
                                                          height: 110,
                                                          width: 110,
                                                          image,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: IconButton(
                                                            onPressed: () =>
                                                                _mapController
                                                                    .deleteSlectedImage(
                                                                        image),
                                                            icon: const Icon(
                                                              Icons.remove,
                                                            ),
                                                            style: IconButton
                                                                .styleFrom(
                                                              backgroundColor:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            Obx(
                                              () => ElevatedButton.icon(
                                                onPressed: _mapController
                                                            .reportImages
                                                            .length <
                                                        4
                                                    ? () async =>
                                                        await _mapController
                                                            .addMoreImages()
                                                    : () => '',
                                                label: Text(
                                                    Messages.addMoreImgs.tr),
                                                icon: const Icon(Icons.add),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      _mapController
                                                                  .reportImages
                                                                  .length >=
                                                              4
                                                          ? Colors.grey
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                ),
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
                            onPressed: () => _mapController.uploadReport(),
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                    Positioned(
                      top: 335,
                      left: 30,
                      height: 200,
                      width: 280,
                      child: Obx(
                        () => !_mapController.isSearchBarFocused
                            ? const SizedBox.shrink()
                            : Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: Obx(
                                  () => _mapController.isQueryLoading
                                      ? const Center(
                                          child: SizedBox(
                                            height: 60,
                                            width: 60,
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : ListView.separated(
                                          itemCount: _mapController
                                              .reportQueryResults.length,
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              thickness: 1.5,
                                            );
                                          },
                                          itemBuilder: (context, index) {
                                            if (index == 0) {
                                              return GestureDetector(
                                                onTap: _mapController
                                                    .selectCurrentLocation,
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.location_history,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                    size: 30,
                                                  ),
                                                  title: Text(
                                                    Messages
                                                        .curretLocationLabel.tr,
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                      fontSize: 20,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            final addressQuery = _mapController
                                                .reportQueryResults[index];
                                            final address = addressQuery[
                                                'formatted_address'] as String;
                                            final name =
                                                addressQuery['name'] as String?;
                                            final coords = LatLng(
                                              addressQuery['geometry']
                                                  ['location']['lat'],
                                              addressQuery['geometry']
                                                  ['location']['lng'],
                                            );
                                            return GestureDetector(
                                              onTap: () {
                                                if (name == null) {
                                                  _mapController
                                                      .setReportLocation(
                                                    address,
                                                    coords,
                                                  );
                                                } else {
                                                  _mapController
                                                      .setReportLocation(
                                                    name,
                                                    coords,
                                                  );
                                                }
                                              },
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.location_on,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                ),
                                                title: name == null
                                                    ? Text(address)
                                                    : Text(name),
                                                subtitle: name == null
                                                    ? null
                                                    : Text(address),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
