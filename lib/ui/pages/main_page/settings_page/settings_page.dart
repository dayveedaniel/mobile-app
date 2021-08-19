import 'package:app/ui/pages/main_page/settings_page/pages/change_language_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/change_password_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/profile_settings_page.dart';
import 'package:app/ui/pages/main_page/settings_page/settings_page_widgets.dart';
import 'package:app/ui/pages/main_page/settings_page/store/settings_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

import '../../../../constants.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = "/settingsPageEmployer";

  @override
  Widget build(context) {
    final settingStore = context.read<SettingsPageStore>();
    final userStore = context.read<ProfileMeStore>();

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Row(
              children: [
                Expanded(child: const Text("Profile")),
                InkWell(
                  onTap: () => Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileSettings(settingStore),
                    ),
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                  ),
                ),
                const SizedBox(width: 20.0)
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  myProfileImage(context, userStore),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ///Change Password
                            settingsCard(
                              icon: GradientIcon(
                                SvgPicture.asset(
                                  "assets/settings_password_icon.svg",
                                ),
                                20.0,
                              ),
                              title: "Change\nPassword",
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(
                                  ChangePasswordPage.routeName,
                                );
                              },
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),

                            ///2FA
                            settingsCard(
                              icon: CupertinoSwitch(
                                onChanged: null,
                                value: false,
                              ),
                              title: "2FA",
                              onTap: () {},
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ///SMS Verification
                              settingsCard(
                                icon: GradientIcon(
                                  SvgPicture.asset(
                                    "assets/settings_message_icon.svg",
                                  ),
                                  20.0,
                                ),
                                title: "SMS \nVerification",
                                onTap: () {},
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),

                              ///Change Role
                              settingsCard(
                                icon: GradientIcon(
                                  SvgPicture.asset(
                                    "assets/settings_role_icon.svg",
                                  ),
                                  20.0,
                                ),
                                title: "Change \nRole",
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ///Change Language
                              settingsCard(
                                icon: GradientIcon(
                                  SvgPicture.asset(
                                    "assets/settings_language_icon.svg",
                                  ),
                                  20.0,
                                ),
                                title:
                                    "Language \n${Constants.languageList.keys.firstWhere(
                                  (k) =>
                                      Constants.languageList[k] ==
                                      context.locale,
                                )}",
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => ChangeLanguage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: logOutButton(context),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 10.0,
              width: double.infinity,
              color: Color(0xFFF7F8FA),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    "Instruments",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  instrumentsCard(
                    context,
                    urlArgument: "pension",
                    iconPath: "assets/settings_pension_icon.svg",
                    title: "Retirement program",
                  ),
                  instrumentsCard(
                    context,
                    urlArgument: "referral",
                    iconPath: "assets/settings_referral_icon.svg",
                    title: "Referral Program",
                  ),
                  instrumentsCard(
                    context,
                    urlArgument: "insuring",
                    iconPath: "assets/settings_p2p_icon.svg",
                    title: "P2P insurance",
                  ),
                  instrumentsCard(
                    context,
                    urlArgument: "savings",
                    iconPath: "assets/setting_saving_product_icon.svg",
                    title: "Savings product",
                  ),
                  instrumentsCard(
                    context,
                    urlArgument: "crediting",
                    iconPath: "assets/settings_wallet.svg",
                    title: "Lending",
                  ),
                  instrumentsCard(
                    context,
                    urlArgument: "mining",
                    iconPath: "assets/setting_chart.svg",
                    title: "Liquidity mining",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
