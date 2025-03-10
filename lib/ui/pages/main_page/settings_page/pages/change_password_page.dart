import 'package:app/ui/pages/main_page/settings_page/store/settings_store.dart';

import 'package:app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

import '../../../../../observer_consumer.dart';

final spacer = const SizedBox(
  height: 20.0,
);

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  static const String routeName = "/changePasswordPage";

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final settingsStore = context.read<SettingsPageStore>();
    return Observer(
      builder: (_) => Form(
        key: _formKey,
        child: Scaffold(
          appBar: CupertinoNavigationBar(
            automaticallyImplyLeading: true,
            middle: Text("settings.changePass".tr()),
          ),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    titledTextField(
                      title: "modals.currentPassword".tr(),
                      hint: "modals.currentPassword".tr(),
                      onChanged: settingsStore.setPassword,
                      validator: Validators.signUpPasswordValidator,
                    ),
                    spacer,
                    titledTextField(
                      title: "modals.newPassword".tr(),
                      hint: "modals.newPassword".tr(),
                      onChanged: settingsStore.setNewPassword,
                      validator: Validators.signUpPasswordValidator,
                    ),
                    spacer,
                    titledTextField(
                      title: "modals.confirmNewPassword".tr(),
                      hint: "modals.confirmNewPassword".tr(),
                      onChanged: settingsStore.setConfirmNewPassword,
                      validator: Validators.signUpPasswordValidator,
                    ),
                    spacer,
                    SizedBox(
                      width: double.infinity,
                      child: ObserverListener<SettingsPageStore>(
                        onSuccess: () {
                          Navigator.pop(context);
                        },
                        child: Observer(
                          builder: (context) {
                            return ElevatedButton(
                              onPressed: settingsStore.canSubmit
                                  ? () async {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        await settingsStore.changePassword();
                                      }
                                    }
                                  : null,
                              child: settingsStore.isLoading
                                  ? CircularProgressIndicator.adaptive()
                                  : Text("meta.submit".tr()),
                            );
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titledTextField({
    required String title,
    required String hint,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(
            height: 5.0,
          ),
          TextFormField(
            onChanged: onChanged,
            obscureText: true,
            decoration: InputDecoration(
              hintText: hint,
            ),
            validator: validator,
          ),
        ],
      );
}
