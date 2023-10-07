import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';
import 'package:holidrive/features/Authentication/widgets/text_field.dart';
import 'package:holidrive/features/Map/controller/use_cases.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameTextController;
  late final TextEditingController _emailTextController;

  final _authController = Get.put(AuthController());
  final _mapController = Get.put(MapController());

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController(
      text: _authController.user!.fullName,
    );
    _emailTextController = TextEditingController(
      text: _authController.user!.email,
    );
  }

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // User Header
              Column(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _fieldSender(
                                controller: _nameTextController,
                                label: Messages.name.tr,
                                buttonLabel: Messages.modify.tr,
                                onPressed: () => _authController.updateField(
                                  'fullName',
                                  _nameTextController.text.trim(),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              _fieldSender(
                                controller: _emailTextController,
                                label: Messages.email.tr,
                                isEmail: true,
                                buttonLabel: Messages.modify.tr,
                                onPressed: () => _authController.updateField(
                                  'email',
                                  _emailTextController.text.trim(),
                                ),
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

  Row _fieldSender({
    required TextEditingController controller,
    required String label,
    required String buttonLabel,
    bool isEmail = false,
    required VoidCallback onPressed,
  }) {
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
        ElevatedButton(onPressed: onPressed, child: Text(buttonLabel))
      ],
    );
  }
}
