import 'package:app/model/quests_models/base_quest_response.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';

import '../../../../enums.dart';
import 'my_quests_item.dart';

class QuestsList extends StatelessWidget {
  final QuestItemPriorityType questItemPriorityType;

  ObservableList<BaseQuestResponse> questsList = ObservableList.of([]);

  final Future<dynamic>? update;

  final ScrollPhysics physics;

  final bool isLoading;


  final PageStorageKey _pageStorageKey = PageStorageKey<int>(1);

  QuestsList(this.questItemPriorityType, this.questsList,
      {this.update,
      this.physics = const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => questsList.isEmpty
          ? Center(
              child: isLoading ? getLoadingBody() : getEmptyBody(context),
            )
          : getBody(),
    );
  }

  Widget getBody() {
    return ListView.builder(
      physics: physics,
      shrinkWrap: true,
      key: new  PageStorageKey<QuestItemPriorityType>(questItemPriorityType),
      itemCount: questsList.length,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, index) {
        return Column(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Color(0xFFF7F8FA),
              ),
            ),
            MyQuestsItem(
              questsList[index],
              itemType: questItemPriorityType,
            ),
          ],
        );
      },
    );
  }

  Widget getEmptyBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/empty_quest_icon.svg",
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "quests.youDontHaveAny".tr() +
              " ${questItemPriorityType.name} " +
              "quests.questYet".tr(),
          style: TextStyle(
            color: Color(0xFFD8DFE3),
          ),
        ),
      ],
    );
  }

  Widget getLoadingBody() {
    return Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
