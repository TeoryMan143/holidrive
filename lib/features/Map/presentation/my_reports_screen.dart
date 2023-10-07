import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';
import 'package:holidrive/features/Map/models/report_info_model.dart';
import 'package:holidrive/features/Map/presentation/report_screen.dart';

class MyReportsScreen extends StatelessWidget {
  MyReportsScreen({super.key});

  final _authController = AuthController.instance;
  final _mapController = MapController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Messages.myReports.tr,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Obx(
            () => _authController.isLoading
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _authController.user?.profilePicture == null
                            ? FaIcon(
                                FontAwesomeIcons.userLarge,
                                size: 60,
                                color: Theme.of(context).colorScheme.background,
                              )
                            : Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      _authController.user!.profilePicture!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0)),
                                  border: Border.all(
                                    width: 3.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ),
                        Expanded(
                          child: Center(
                            child: Text(
                              _authController.user!.fullName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontFamily: 'Poppins',
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.secondary,
            thickness: 2,
          ),
          Expanded(
            child: Obx(
              () => ListView.separated(
                itemCount: _mapController.reports
                    .where(
                        (report) => report.userId == _authController.user?.uid)
                    .length,
                itemBuilder: (context, index) {
                  final report = _mapController.reports
                      .where(
                        (report) => report.userId == _authController.user?.uid,
                      )
                      .toList()[index];

                  return GestureDetector(
                    onTap: () {
                      bottomSheet(ReportScreen(report));
                    },
                    child: ListTile(
                      leading: SvgPicture.asset(
                        {
                          ReportType.hole: Constants.holeIcon,
                          ReportType.roadWork: Constants.roadWorkIcon,
                          ReportType.dangerZone: Constants.dangerIcon,
                        }[report.type]!,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.surface,
                          BlendMode.srcIn,
                        ),
                        height: 40,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              report.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${report.time.day}-${report.time.month}-${report.time.year}',
                          )
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          Get.dialog(
                            AlertDialog.adaptive(
                              title: Text(
                                Messages.deleteReportTit.tr,
                                style: Theme.of(Get.context!)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Theme.of(Get.context!)
                                          .colorScheme
                                          .surface,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                              ),
                              content: Text(Messages.deleteReportCont.tr),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () async {
                                    await _mapController.deleteReport(report);
                                    Get.back;
                                  },
                                  child: Text(Messages.confirm.tr),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    return;
                                  },
                                  child: Text(Messages.cancel.tr),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Theme.of(context).colorScheme.surface,
                    thickness: 1.5,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
