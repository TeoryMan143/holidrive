import 'package:flutter/material.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/core/controllers/storage_controller.dart';
import 'package:holidrive/features/Map/models/report_info_model.dart';
import 'package:holidrive/features/Map/presentation/report_screen.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';

class ReportPreview extends StatelessWidget {
  ReportPreview(
    this.reportInfo, {
    super.key,
  });

  final ReportInfoModel reportInfo;

  String _getHintIcon() {
    switch (reportInfo.type) {
      case ReportType.hole:
        return Constants.holeIcon;
      case ReportType.roadWork:
        return Constants.roadWorkIcon;
      case ReportType.dangerZone:
        return Constants.dangerIcon;
    }
  }

  String _getHintText() {
    switch (reportInfo.type) {
      case ReportType.hole:
        return Messages.holeHint.tr;
      case ReportType.roadWork:
        return Messages.workHint.tr;
      case ReportType.dangerZone:
        return Messages.dangerHint.tr;
    }
  }

  final _storageInst = StorageRepository.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    child: ColoredBox(
                      color: Theme.of(context).colorScheme.surface,
                      child: FutureBuilder<String>(
                        future: _storageInst.getImageUrl(
                          'avidence/${reportInfo.id}/0evi_800x800',
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Image.network(
                            snapshot.data!,
                            height: 100,
                            width: 300,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    width: 300,
                    height: 90,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Text(
                                  reportInfo.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontFamily: 'Poppins',
                                        fontSize: 17,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${reportInfo.time.day}-${reportInfo.time.month}-${reportInfo.time.year}',
                              )
                            ],
                          ),
                          Text(
                            reportInfo.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              left: 5,
              top: -25,
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        _getHintIcon(),
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onBackground,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _getHintText(),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 8,
              child: ElevatedButton.icon(
                onPressed: () => bottomSheet(ReportScreen(reportInfo)),
                icon: const Icon(Icons.open_in_new),
                label: Text(Messages.seeMore.tr),
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            )
          ],
        ),
        Triangle.isosceles(
          edge: Edge.BOTTOM,
          child: Container(
            color: Theme.of(context).colorScheme.background,
            height: 40,
            width: 30,
          ),
        ),
      ],
    );
  }
}
