import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/my_quests_page/my_quests_item.dart';
import 'package:app/ui/pages/main_page/quest_page/filter_quests_page/filter_quests_page.dart';
import 'package:app/ui/pages/main_page/quest_page/notification_page/notification_page.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/workers_item.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

class QuestList extends StatefulWidget {
  final Function() changePage;

  QuestList(this.changePage);

  @override
  _QuestListState createState() => _QuestListState();
}

class _QuestListState extends State<QuestList> {
  ScrollController? controller;

  QuestsStore? questsStore;

  ProfileMeStore? profileMeStore;

  final QuestItemPriorityType questItemPriorityType =
      QuestItemPriorityType.Starred;
  final scrollKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    questsStore = context.read<QuestsStore>();
    profileMeStore = context.read<ProfileMeStore>();
    profileMeStore!.getProfileMe().then((value) {
      context.read<ChatStore>().initialSetup(
            profileMeStore!.userData!.id,
          );
      context.read<ChatStore>().role = profileMeStore!.userData!.role;
      profileMeStore!.userData!.role == UserRole.Worker
          ? questsStore!.getQuests(true)
          : questsStore!.getWorkers(true);
    });
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: "QuestListLeftActionButton",
              onPressed: () {
                widget.changePage();
                FocusScope.of(context).unfocus();
              },
              child: Icon(
                Icons.map_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        return profileMeStore!.userData!.role == UserRole.Worker
            ? questsStore!.getQuests(true)
            : questsStore!.getWorkers(true);
      },
      displacement: 50,
      edgeOffset: 300,
      child: CustomScrollView(
        controller: controller,
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Row(
              children: [
                Expanded(
                  child: Text(
                    profileMeStore!.userData?.role == UserRole.Worker
                        ? "quests.quests".tr()
                        : "workers.workers".tr(),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(
                    NotificationPage.routeName,
                    arguments: profileMeStore!.userData!.id,
                  ),
                  child: const Icon(Icons.notifications_none_outlined),
                ),
                const SizedBox(width: 20.0)
              ],
            ),
          ),
          SliverAppBar(
            pinned: true,
            title: GestureDetector(
              onTap: () {
                questsStore!
                    .getPrediction(context, profileMeStore!.userData!.role);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                    ),
                    Icon(
                      Icons.search,
                      size: 25.0,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      child: questsStore!.locationPlaceName.isEmpty
                          ? Text(
                              "quests.ui.search".tr(),
                              style: TextStyle(
                                color: Color(
                                  0xFFD8DFE3,
                                ),
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.fade,
                            )
                          : Text(
                              questsStore!.locationPlaceName,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: Color(0xFF1D2127),
                                fontSize: 16,
                                height: 1,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 8),
                _getDivider(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: OutlinedButton(
                    onPressed: () async {
                      await Navigator.of(context, rootNavigator: true)
                          .pushNamed(FilterQuestsPage.routeName);
                      // questsStore!.offset = 0;
                      // questsStore!.getQuests(true);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/filter.svg"),
                        SizedBox(
                          width: 13,
                        ),
                        Text(
                          "quests.filter.btn".tr(),
                        ),
                      ],
                    ),
                  ),
                ),
                _getDivider(),
                Observer(
                  builder: (_) => questsStore!.emptySearch
                      ? Center(
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "assets/empty_quest_icon.svg",
                              ),
                              Text(
                                "quest.noQuest".tr(),
                              ),
                            ],
                          ),
                        )
                      : profileMeStore!.userData?.role == UserRole.Worker
                          ? ListView.separated(
                              key: scrollKey,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return _getDivider();
                              },
                              padding: EdgeInsets.zero,
                              itemCount: questsStore!.searchWord.length > 2
                                  ? questsStore!.searchResultList?.length ?? 0
                                  : questsStore!.questsList.length,
                              itemBuilder: (_, index) {
                                return Observer(
                                  builder: (_) => MyQuestsItem(
                                    questsStore!.searchWord.length > 2
                                        ? questsStore!.searchResultList![index]
                                        : questsStore!.questsList[index],
                                    itemType: this.questItemPriorityType,
                                  ),
                                );
                              },
                            )
                          : ListView.separated(
                              key: scrollKey,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return _getDivider();
                              },
                              padding: EdgeInsets.zero,
                              itemCount: questsStore!.searchWord.length > 2
                                  ? questsStore!.searchResultList?.length ?? 0
                                  : questsStore!.workersList.length,
                              itemBuilder: (_, index) {
                                return Observer(
                                  builder: (_) => WorkersItem(
                                    questsStore!.searchWord.length > 2
                                        ? questsStore!.searchWorkersList![index]
                                        : questsStore!.workersList[index],
                                    questsStore!,
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Observer(
              builder: (_) => questsStore!.isLoading
                  ? Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDivider() {
    return SizedBox(
      height: 10,
      child: Container(
        color: Color(0xFFF7F8FA),
      ),
    );
  }

  void _scrollListener() {
    if (controller!.position.extentAfter < 500) {
      if (questsStore != null) {
        if (questsStore!.isLoading) return;
        if (profileMeStore!.userData!.role == UserRole.Worker)
          questsStore!.getQuests(false);
        else
          questsStore!.getWorkers(false);
      }
    }
  }
}
