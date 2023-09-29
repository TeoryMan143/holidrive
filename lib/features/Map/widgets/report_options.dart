import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';
import 'package:holidrive/features/Map/models/report_info_model.dart';

class ReportOptions extends StatelessWidget {
  ReportOptions({super.key});

  final _mapInst = MapController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _reportOption(
              context,
              Constants.holeIcon,
              ReportType.hole,
              Messages.holeHint.tr,
              0,
            ),
            _reportOption(
              context,
              Constants.roadWorkIcon,
              ReportType.roadWork,
              Messages.workHint.tr,
              1,
            ),
            _reportOption(
              context,
              Constants.dangerIcon,
              ReportType.dangerZone,
              Messages.dangerHint.tr,
              2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportOption(
    BuildContext context,
    String svgPath,
    ReportType type,
    String text,
    int id,
  ) {
    return GestureDetector(
      onTap: () {
        _mapInst.reporTypeIndex = id;
      },
      child: Obx(
        () => Column(
          children: <Widget>[
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(
                  width: 3.0,
                  color: _mapInst.reporTypeIndex == id
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.tertiary,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: SvgPicture.asset(
                  svgPath,
                  colorFilter: ColorFilter.mode(
                    _mapInst.reporTypeIndex == id
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.tertiary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 70),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _mapInst.reporTypeIndex == id
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
