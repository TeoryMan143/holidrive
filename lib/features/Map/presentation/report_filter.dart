import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';
import 'package:holidrive/features/Map/models/report_info_model.dart';

class ReportFilter extends StatelessWidget {
  ReportFilter({super.key});

  final _mapController = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        color: Theme.of(context).colorScheme.background,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          typeCheckbox(context, ReportType.hole),
          const SizedBox(height: 12),
          typeCheckbox(context, ReportType.roadWork),
          const SizedBox(height: 12),
          typeCheckbox(context, ReportType.dangerZone),
        ],
      ),
    );
  }

  Row typeCheckbox(BuildContext context, ReportType type) {
    return Row(
      children: [
        Obx(
          () => Checkbox(
            value: _mapController.activeReportTypes.contains(type),
            onChanged: (_) {
              _mapController.handleReportTypes(type);
            },
          ),
        ),
        Obx(
          () => SvgPicture.asset(
            height: 40,
            <ReportType, String>{
              ReportType.hole: Constants.holeIcon,
              ReportType.roadWork: Constants.roadWorkIcon,
              ReportType.dangerZone: Constants.dangerIcon,
            }[type]!,
            colorFilter: ColorFilter.mode(
              _mapController.activeReportTypes.contains(type)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.tertiary,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          <ReportType, String>{
            ReportType.hole: Messages.holeHint.tr,
            ReportType.roadWork: Messages.workHint.tr,
            ReportType.dangerZone: Messages.dangerHint.tr,
          }[type]!,
          style: const TextStyle(fontSize: 17),
        )
      ],
    );
  }
}
