import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part '2FA_store.g.dart';

@injectable
@singleton
class TwoFAStore extends _TwoFAStore with _$TwoFAStore {
  TwoFAStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _TwoFAStore extends IStore<bool> with Store {
  final ApiProvider apiProvider;

  _TwoFAStore(this.apiProvider);

  @observable
  int index = 0;

  @observable
  String googleAuthenticatorSecretCode = '';

  @observable
  String codeFromEmail = '';

  @observable
  String codeFromAuthenticator = '';

  @computed
  String get errorText=>"";

  @action
  void setCodeFromAuthenticator(String value) {
    codeFromAuthenticator = value;
  }

  @action
  void setCodeFromEmail(String value) {
    codeFromEmail = value;
  }

  @action
  Future<void> enable2FA() async {
    try {
      this.onLoading();
      googleAuthenticatorSecretCode = await apiProvider.enable2FA();
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future disable2FA() async {
    try {
      this.onLoading();
      await apiProvider.disable2FA(
        totp: codeFromAuthenticator,
      );
      await SharedPreferences.getInstance().then(
        (value) => value.setBool(
          "2FAStatus",
          false,
        ),
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future confirm2FA() async {
    try {
      this.onLoading();
      await apiProvider.confirmEnabling2FA(
        confirmCode: codeFromEmail,
        totp: codeFromAuthenticator,
      );
      await SharedPreferences.getInstance().then(
        (sharedPrefs) => sharedPrefs.setBool(
          "2FAStatus",
          true,
        ),
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @computed
  bool get canFinish =>
      index == 3 &&
      codeFromEmail.isNotEmpty &&
      codeFromAuthenticator.isNotEmpty;
}
