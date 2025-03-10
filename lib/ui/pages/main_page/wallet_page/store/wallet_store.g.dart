// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WalletStore on _WalletStore, Store {
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit => (_$canSubmitComputed ??=
          Computed<bool>(() => super.canSubmit, name: '_WalletStore.canSubmit'))
      .value;

  final _$_recipientAddressAtom = Atom(name: '_WalletStore._recipientAddress');

  @override
  String get _recipientAddress {
    _$_recipientAddressAtom.reportRead();
    return super._recipientAddress;
  }

  @override
  set _recipientAddress(String value) {
    _$_recipientAddressAtom.reportWrite(value, super._recipientAddress, () {
      super._recipientAddress = value;
    });
  }

  final _$amountAtom = Atom(name: '_WalletStore.amount');

  @override
  String get amount {
    _$amountAtom.reportRead();
    return super.amount;
  }

  @override
  set amount(String value) {
    _$amountAtom.reportWrite(value, super.amount, () {
      super.amount = value;
    });
  }

  final _$_WalletStoreActionController = ActionController(name: '_WalletStore');

  @override
  void setRecipientAddress(String value) {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.setRecipientAddress');
    try {
      return super.setRecipientAddress(value);
    } finally {
      _$_WalletStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAmount(String value) {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.setAmount');
    try {
      return super.setAmount(value);
    } finally {
      _$_WalletStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getAmount() {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.getAmount');
    try {
      return super.getAmount();
    } finally {
      _$_WalletStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getAddress() {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.getAddress');
    try {
      return super.getAddress();
    } finally {
      _$_WalletStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearValues() {
    final _$actionInfo = _$_WalletStoreActionController.startAction(
        name: '_WalletStore.clearValues');
    try {
      return super.clearValues();
    } finally {
      _$_WalletStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
amount: ${amount},
canSubmit: ${canSubmit}
    ''';
  }
}
