import 'dart:io';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/2FA_page/2FA_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/alert_dialog.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:provider/provider.dart";
import 'package:url_launcher/url_launcher.dart';

final _spacer = Spacer();

class TwoFAPage extends StatelessWidget {
  static const String routeName = "/2FAPage";

  @override
  Widget build(BuildContext context) {
    final store = context.read<TwoFAStore>();
    final userStore = context.read<ProfileMeStore>();

    return ObserverListener<TwoFAStore>(
      onSuccess: () {},
      child: Observer(
        builder: (_) => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CupertinoNavigationBar(
            automaticallyImplyLeading: true,
            middle: Text("2FA"),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: userStore.twoFAStatus!
                  ? _disable2FA(
                      store,
                      context,
                      userStore,
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20.0,
                          alignment: AlignmentDirectional.centerStart,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFF7F8FA),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) => Observer(
                              builder: (_) => AnimatedContainer(
                                width: constraints.maxWidth *
                                    (store.index + 1) /
                                    4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                ),
                                duration: const Duration(
                                  milliseconds: 150,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Step ${store.index + 1}",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 23.0,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: Confirm2FAPages(
                              store: store, userStore: userStore),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  ///Disable 2FA
  Widget _disable2FA(
    TwoFAStore store,
    BuildContext context,
    ProfileMeStore userStore,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Enter code from Google Authenticator app to disable 2FA"),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            onChanged: store.setCodeFromAuthenticator,
            decoration: InputDecoration(hintText: "*****"),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: store.codeFromAuthenticator.isNotEmpty
                ? () async {
                    await store.disable2FA();
                    await userStore.get2FAStatus();
                    Navigator.pop(context);
                  }
                : null,
            child: store.isLoading
                ? PlatformActivityIndicator()
                : Text(
                    "Submit",
                  ),
          )
        ],
      );

  ///Bottom row buttons
  Widget buttonRow(
    TwoFAStore store, {
    required String forward,
    required String back,
    ProfileMeStore? userStore,
    required BuildContext context,
  }) =>
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45.0,
              child: OutlinedButton(
                onPressed: () {
                  if (store.index == 0)
                    dialog(
                      context,
                      title: "2FA Activation",
                      message:
                          "Are you sure you want to cancel 2A activation ?",
                      confirmAction: () {
                        Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        );
                      },
                    );
                  if (store.index > 0) store.index--;
                },
                child: Text(back),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1.0,
                    color: Color(0xFF0083C7).withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: store.index < 3
                  ? () async {
                      if (store.index == 0) await store.enable2FA();
                      if (store.index < 3) store.index++;
                      //if (store.index == 2)
                      //   await LaunchApp.openApp(
                      //     androidPackageName: 'com.google.android.apps.authenticator2',
                      //     iosUrlScheme: 'otpauth://',
                      //     appStoreLink:
                      //         'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                      //     openStore: true
                      // );
                    }
                  : store.canFinish
                      ? () async {
                          await store.confirm2FA();
                          if (store.isSuccess) {
                            Navigator.pop(context);
                            await userStore!.get2FAStatus();
                          }
                        }
                      : null,
              child: store.isLoading
                  ? Center(
                      child: PlatformActivityIndicator(),
                    )
                  : Text(forward),
            ),
          ),
        ],
      );
}

class Confirm2FAPages extends StatelessWidget {
  final TwoFAStore store;
  final ProfileMeStore userStore;

  const Confirm2FAPages({
    required this.store,
    required this.userStore,
  });

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: store.index,
      children: [
        ///Step 1
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Download and install the Google Authenticator app",
            ),
            CupertinoButton(
              onPressed: () {
                try {
                  Platform.isIOS
                      ? launch("market://details?id=" + "id388497605")
                      : launch(
                          "https://play.google.com/store/apps/details?id=" +
                              "com.google.android.apps.authenticator2");
                } catch (e) {
                  print(e);
                }
              },
              child: SvgPicture.asset(
                Platform.isIOS
                    ? "assets/open_ios_appstore.svg"
                    : "assets/open_google_play.svg",
              ),
            ),
            Text(
              "Continue to next step if you already have Google Authenticator app",
            ),
            _spacer,
            buttonRow(store, forward: "Next", back: "Cancel", context: context),
          ],
        ),

        ///Step 2
        Column(
          children: [
            Text("Please keep this key on paper."
                " This key will allow you to restore your "
                "Google Authenticator in case of phone loss."),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: const Color(0xFFF7F8FA), // red as border color
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SvgPicture.asset("assets/2FA_attention_icon.svg"),
                  ),
                  Expanded(
                    child: Text(
                      store.googleAuthenticatorSecretCode,
                    ),
                  ),
                  IconButton(
                    splashRadius: 20.0,
                    onPressed: () => Clipboard.setData(
                      new ClipboardData(
                        text: "email",
                      ),
                    ).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "Code copied to clipboard",
                          ),
                        ),
                      );
                    }),
                    icon: SvgPicture.asset(
                      "assets/copy_icon.svg",
                      color: Color(0xFFAAB0B9),
                    ),
                  ),
                ],
              ),
            ),
            _spacer,
            buttonRow(store, forward: "Next", back: "Back", context: context),
          ],
        ),

        /// Step 3
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Open the Google Authenticator app and paste your secret code"),
            const SizedBox(
              height: 10.0,
            ),
            _spacer,
            buttonRow(store, forward: "Next", back: "Back", context: context),
          ],
        ),

        ///Step 4
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enable Google Authenticator"),
            const SizedBox(
              height: 25.0,
            ),
            Text("Code from email"),
            const SizedBox(
              height: 5.0,
            ),
            TextFormField(
              onChanged: store.setCodeFromEmail,
              decoration: InputDecoration(
                hintText: "*****",
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "Enter the 6-digit code received at 1234***@gmail.com.",
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text("Code from Google Authenticator"),
            TextFormField(
              onChanged: store.setCodeFromAuthenticator,
              decoration: InputDecoration(
                hintText: "*****",
              ),
            ),
            Text(
              "Enter the 6-digit code from the Google Authenticator app.",
            ),
            _spacer,
            buttonRow(
              store,
              forward: "Finish",
              back: "Back",
              userStore: userStore,
              context: context,
            ),
          ],
        )
      ],
    );
  }

  ///Bottom row buttons
  Widget buttonRow(
    TwoFAStore store, {
    required String forward,
    required String back,
    ProfileMeStore? userStore,
    required BuildContext context,
  }) =>
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45.0,
              child: OutlinedButton(
                onPressed: () {
                  if (store.index == 0)
                    dialog(
                      context,
                      title: "2FA Activation",
                      message:
                          "Are you sure you want to cancel 2A activation ?",
                      confirmAction: () {
                        Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        );
                      },
                    );
                  if (store.index > 0) store.index--;
                },
                child: Text(back),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1.0,
                    color: Color(0xFF0083C7).withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: store.index < 3
                  ? () async {
                      if (store.index == 0) await store.enable2FA();
                      if (store.index < 3) store.index++;
                      //if (store.index == 2)
                      //   await LaunchApp.openApp(
                      //     androidPackageName: 'com.google.android.apps.authenticator2',
                      //     iosUrlScheme: 'otpauth://',
                      //     appStoreLink:
                      //         'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                      //     openStore: true
                      // );
                    }
                  : store.canFinish
                      ? () async {
                          await store.confirm2FA();
                          if (store.isSuccess) {
                            Navigator.pop(context);
                            await userStore!.get2FAStatus();
                          }
                        }
                      : null,
              child: store.isLoading
                  ? Center(
                      child: PlatformActivityIndicator(),
                    )
                  : Text(forward),
            ),
          ),
        ],
      );
}
