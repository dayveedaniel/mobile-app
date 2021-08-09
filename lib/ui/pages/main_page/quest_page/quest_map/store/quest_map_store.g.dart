// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_map_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestMapStore on _QuestMapStore, Store {
  final _$iconsMarkerAtom = Atom(name: '_QuestMapStore.iconsMarker');

  @override
  List<BitmapDescriptor> get iconsMarker {
    _$iconsMarkerAtom.reportRead();
    return super.iconsMarker;
  }

  @override
  set iconsMarker(List<BitmapDescriptor> value) {
    _$iconsMarkerAtom.reportWrite(value, super.iconsMarker, () {
      super.iconsMarker = value;
    });
  }

  final _$getQuestsAsyncAction = AsyncAction('_QuestMapStore.getQuests');

  @override
  Future<dynamic> getQuests(String userId) {
    return _$getQuestsAsyncAction.run(() => super.getQuests(userId));
  }

  @override
  String toString() {
    return '''
iconsMarker: ${iconsMarker}
    ''';
  }
}
