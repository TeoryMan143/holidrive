import 'package:flutter/material.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Map/models/report_info_model.dart';

class ReportPreview extends StatelessWidget {
  const ReportPreview({
    super.key,
    required this.displayImage,
    required this.location,
    required this.description,
    required this.type,
  });

  final String displayImage, location, description;
  final ReportType type;

  String _getHintIcon() {
    switch (type) {
      case ReportType.hole:
        return Constants.holeIcon;
      case ReportType.roadWork:
        return Constants.roadWorkIcon;
      case ReportType.dangerZone:
        return Constants.dangerIcon;
    }
  }

  String _getHintText() {
    switch (type) {
      case ReportType.hole:
        return Messages.holeHint.tr;
      case ReportType.roadWork:
        return Messages.workHint.tr;
      case ReportType.dangerZone:
        return Messages.dangerHint.tr;
    }
  }

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
                      child: Image.network(
                        displayImage,
                        height: 100,
                        width: 300,
                        fit: BoxFit.cover,
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
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            location,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: description,
                            ),
                            overflow: TextOverflow.ellipsis,
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
              left: 10,
              top: -25,
              child: Row(
                children: [
                  Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    color: Theme.of(context).colorScheme.background,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(_getHintIcon(), height: 24),
                          const SizedBox(width: 10),
                          Text(
                            _getHintText(),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => '',
                    icon: const Icon(Icons.open_in_new),
                    label: Text(Messages.seeMore.tr),
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Triangle.isosceles(
          edge: Edge.BOTTOM,
          child: Container(
            color: Theme.of(context).colorScheme.background,
            height: 40,
            width: 30,
          ),
        )
      ],
    );
  }
}
