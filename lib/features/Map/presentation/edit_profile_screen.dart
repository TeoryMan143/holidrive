import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';
import 'package:holidrive/features/Authentication/widgets/text_field.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _authController = Get.put(AuthController());
  final _mapController = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Messages.editProfile.tr,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // User Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.userPen,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    child: Text(
                      softWrap: true,
                      Messages.editUserInfo.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                    ),
                  ),
                ],
              ), // User Header
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  child: Obx(
                    () => _authController.isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldSender(
                                controller: TextEditingController(
                                  text: _authController.user!.fullName,
                                ),
                                label: Messages.name.tr,
                                buttonLabel: 'Place',
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              _fieldSender(
                                controller: TextEditingController(
                                  text: _authController.user!.email,
                                ),
                                label: Messages.email.tr,
                                isEmail: true,
                                buttonLabel: 'Place',
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.image,
                                  );

                                  if (result == null) return;

                                  await _mapController.uploadProfilePicture(
                                    result.files.single.path!,
                                    result.files.single.name,
                                  );
                                },
                                icon: const Icon(Icons.camera_alt_rounded),
                                label: const Text('Pro'),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _fieldSender(
      {required TextEditingController controller,
      required String label,
      required String buttonLabel,
      bool isEmail = false}) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FormTextField(
                controller: controller,
                label: label,
              ),
            ),
          ),
        ),
        ElevatedButton(onPressed: () => '', child: Text(buttonLabel))
      ],
    );
  }
}
