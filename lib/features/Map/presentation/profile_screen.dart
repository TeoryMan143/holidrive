import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/core/controllers/use_case.dart';
import 'package:holidrive/features/Authentication/controller/use_cases.dart';
import 'package:holidrive/features/Map/presentation/edit_profile_screen.dart';
import 'package:holidrive/features/Map/presentation/my_reports_screen.dart';
import 'package:holidrive/features/Map/widgets/profile_option.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final _authController = Get.put(AuthController());
  final _coreController = Get.put(CoreState());

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
          children: <Widget>[
            Divider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 3,
              indent: 90,
              endIndent: 90,
            ),
            const SizedBox(height: 50),
            Obx(
              () => _authController.isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 200,
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
                            const SizedBox(height: 25),
                            Text(
                              Messages.yourProfile.tr,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
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
                              )
                      ],
                    ),
            ),
            const SizedBox(height: 80),
            ProfileOption(
              icon: FontAwesomeIcons.pencil,
              title: Messages.myReports.tr,
              onTap: () {
                Get.to(
                  () => MyReportsScreen(),
                  transition: Transition.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 400),
                );
              },
            ),
            Divider(
              color: Theme.of(context).colorScheme.surface,
              thickness: 2,
              indent: 10,
              endIndent: 10,
              height: 30,
            ),
            ProfileOption(
              icon: FontAwesomeIcons.userPen,
              title: Messages.editProfile.tr,
              onTap: () {
                Get.to(
                  () => const EditProfileScreen(),
                  transition: Transition.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 400),
                );
              },
            ),
            Divider(
              color: Theme.of(context).colorScheme.surface,
              thickness: 2,
              indent: 10,
              endIndent: 10,
              height: 30,
            ),
            ProfileOption(
              icon: FontAwesomeIcons.brush,
              title: Messages.theme.tr,
              action: Obx(
                () => DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.background,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  iconEnabledColor: Theme.of(context).colorScheme.primary,
                  onChanged: _coreController.changeThemeMode,
                  value: _coreController.themeMode,
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(
                        Messages.light.tr,
                      ),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(
                        Messages.dark.tr,
                      ),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text(
                        Messages.system.tr,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.surface,
              thickness: 2,
              indent: 10,
              endIndent: 10,
              height: 30,
            ),
            ProfileOption(
              icon: Icons.logout,
              title: Messages.logOut.tr,
              onTap: _authController.logOut,
            )
          ],
        ),
      ),
    );
  }
}
