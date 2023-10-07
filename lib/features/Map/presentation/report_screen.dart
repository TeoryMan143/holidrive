import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';
import 'package:holidrive/features/Authentication/models/user_model.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';
import 'package:holidrive/features/Map/models/report_info_model.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen(
    this.reportInfo, {
    super.key,
  });

  final ReportInfoModel reportInfo;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _mapController = MapController.instance;
  final _authController = AuthController.instance;

  late final Future<List<String>> _loaded;
  late final Future<UserModel?> _reportUser;

  @override
  void initState() {
    super.initState();
    _loaded = _mapController.getReportImages(widget.reportInfo.id);
    _reportUser = _authController.getUserDataFromId(widget.reportInfo.userId);
  }

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
            const SizedBox(height: 50),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onTertiary,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: FutureBuilder(
                future: _loaded,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final imageUrls = snapshot.data!;

                  return CarouselSlider.builder(
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index, realIndex) {
                      return Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        width: 170,
                      );
                    },
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      height: 200,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                widget.reportInfo.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 1.5,
            ),
            SingleChildScrollView(
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                color: Theme.of(context).colorScheme.onTertiary,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Obx(
                        () => _authController.isLoading
                            ? const Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : FutureBuilder(
                                future: _reportUser,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 65,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff7c94b6),
                                          image: DecorationImage(
                                            image: snapshot
                                                        .data!.profilePicture ==
                                                    null
                                                ? const AssetImage(
                                                        Constants.defaultPfp)
                                                    as ImageProvider
                                                : NetworkImage(
                                                    snapshot
                                                        .data!.profilePicture!,
                                                  ),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50.0)),
                                          border: Border.all(
                                            width: 3.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data!.fullName,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              Text(
                                                '${widget.reportInfo.time.day}-${widget.reportInfo.time.month}-${widget.reportInfo.time.year}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.reportInfo.description,
                          style: const TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
