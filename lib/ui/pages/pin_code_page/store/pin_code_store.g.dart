// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_code_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PinCodeStore on _PinCodeStore, Store {
  final _$pinAtom = Atom(name: '_PinCodeStore.pin');

  @override
  String get pin {
    _$pinAtom.reportRead();
    return super.pin;
  }

  @override
  set pin(String value) {
    _$pinAtom.reportWrite(value, super.pin, () {
      super.pin = value;
    });
  }

  final _$attemptsAtom = Atom(name: '_PinCodeStore.attempts');

  @override
  int get attempts {
    _$attemptsAtom.reportRead();
    return super.attempts;
  }

  @override
  set attempts(int value) {
    _$attemptsAtom.reportWrite(value, super.attempts, () {
      super.attempts = value;
    });
  }

  final _$statePinAtom = Atom(name: '_PinCodeStore.statePin');

  @override
  StatePinCode get statePin {
    _$statePinAtom.reportRead();
    return super.statePin;
  }

  @override
  set statePin(StatePinCode value) {
    _$statePinAtom.reportWrite(value, super.statePin, () {
      super.statePin = value;
    });
  }

  final _$newPinCodeAtom = Atom(name: '_PinCodeStore.newPinCode');

  @override
  String get newPinCode {
    _$newPinCodeAtom.reportRead();
    return super.newPinCode;
  }

  @override
  set newPinCode(String value) {
    _$newPinCodeAtom.reportWrite(value, super.newPinCode, () {
      super.newPinCode = value;
    });
  }

  final _$canCheckBiometricsAtom =
      Atom(name: '_PinCodeStore.canCheckBiometrics');

  @override
  bool get canCheckBiometrics {
    _$canCheckBiometricsAtom.reportRead();
    return super.canCheckBiometrics;
  }

  @override
  set canCheckBiometrics(bool value) {
    _$canCheckBiometricsAtom.reportWrite(value, super.canCheckBiometrics, () {
      super.canCheckBiometrics = value;
    });
  }

  final _$signInAsyncAction = AsyncAction('_PinCodeStore.signIn');

  @override
  Future<dynamic> signIn({bool isBiometric = false}) {
    return _$signInAsyncAction
        .run(() => super.signIn(isBiometric: isBiometric));
  }

  final _$_PinCodeStoreActionController =
      ActionController(name: '_PinCodeStore');

  @override
  dynamic initPage() {
    final _$actionInfo = _$_PinCodeStoreActionController.startAction(
        name: '_PinCodeStore.initPage');
    try {
      return super.initPage();
    } finally {
      _$_PinCodeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic inputPin(int num) {
    final _$actionInfo = _$_PinCodeStoreActionController.startAction(
        name: '_PinCodeStore.inputPin');
    try {
      return super.inputPin(num);
    } finally {
      _$_PinCodeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic popPin() {
    final _$actionInfo = _$_PinCodeStoreActionController.startAction(
        name: '_PinCodeStore.popPin');
    try {
      return super.popPin();
    } finally {
      _$_PinCodeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pin: ${pin},
attempts: ${attempts},
statePin: ${statePin},
newPinCode: ${newPinCode},
canCheckBiometrics: ${canCheckBiometrics}
    ''';
  }
}
