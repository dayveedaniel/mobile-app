import 'package:app/enums.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/create_portfolio_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/choose_quest.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_worker_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class WorkerProfile extends UserProfile {
  WorkerProfile(ProfileMeResponse? info) : super(info);

  @override
  _WorkerProfileState createState() => _WorkerProfileState();
}

class _WorkerProfileState extends UserProfileState<UserProfile> {
  final String tabTitle = "profiler.portfolio".tr();

  final store = UserProfileWorkerStore();

  List<Widget> questPortfolio() => [
        ///Add new portfolio
        if (widget.info == null)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: OutlinedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                CreatePortfolioPage.routeName,
                arguments: false,
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Colors.blueAccent.withOpacity(0.3),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "quests.addNew".tr(),
                  ),
                  const SizedBox(width: 5.0),
                  const Icon(Icons.add),
                ],
              ),
            ),
          ),

        Observer(
          builder: (_) => portfolioStore!.portfolioList.isEmpty
              ? Center(
                  child: Text(
                    "profiler.dontHavePortfolioOtherUser".tr(),
                  ),
                )
              : Column(
                  children: [
                    for (int index = 0;
                        index < portfolioStore!.portfolioList.length;
                        index++)
                      PortfolioWidget(
                        index: index,
                        imageUrl: portfolioStore!
                                .portfolioList[index].medias.isEmpty
                            ? "https://app-ver1.workquest.co/_nuxt/img/logo.1baae1e.svg"
                            : portfolioStore!
                                .portfolioList[index].medias.first.url,
                        title: portfolioStore!.portfolioList[index].title,
                        isProfileYour: widget.info == null ? true : false,
                      ),
                  ],
                ),
        ),
      ];

  @override
  List<Widget> listWidgets() => [
//_____________Skills______________/
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            widget.info == null
                ? "skills.yourSkills".tr()
                : "skills.title".tr(),
            textAlign: TextAlign.start,
            style: style,
          ),
        ),
        widget.info == null
            ? (userStore!.userData!.userSpecializations.isEmpty)
                ? Text(
                    "skills.noSkills".tr(),
                    style: style.copyWith(
                      color: Color(0xFF7C838D),
                      fontWeight: FontWeight.normal,
                    ),
                  )
                : skills(
                    skills:
                        store.parser(userStore!.userData!.userSpecializations),
                    context: context,
                    isProfileMy: true,
                  )
            : (widget.info!.userSpecializations.isEmpty)
                ? Text(
                    "skills.noSkills".tr(),
                    style: style.copyWith(
                      color: Color(0xFF7C838D),
                      fontWeight: FontWeight.normal,
                    ),
                  )
                : skills(
                    skills: store.parser(widget.info!.userSpecializations),
                    context: context,
                    isProfileMy: false,
                  ),

        spacer,

//_____________About______________/
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            "about.about".tr(),
            style: style,
          ),
        ),
        Text(
          widget.info == null
              ? userStore!.userData?.additionalInfo?.description ??
                  "modals.noDescription".tr()
              : widget.info!.additionalInfo?.description ??
                  "modals.noDescription".tr(),
        ),

        spacer,

//_____________Education______________/
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            "settings.educations".tr(),
            style: style.copyWith(
              fontSize: 14,
            ),
          ),
        ),
        widget.info == null
            ? (userStore!.userData!.additionalInfo!.educations.isNotEmpty)
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        userStore!.userData!.additionalInfo!.educations.length,
                    itemBuilder: (_, index) {
                      final education = userStore!
                          .userData!.additionalInfo!.educations[index];
                      return experience(
                          place: education["place"] ?? "--",
                          from: education["from"] ?? "--",
                          to: education["to"] ?? "--");
                    })
                : Text(
                    "profiler.noInformation".tr(),
                  )
            : (widget.info!.additionalInfo!.educations.isNotEmpty)
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.info!.additionalInfo!.educations.length,
                    itemBuilder: (_, index) {
                      final education =
                          widget.info!.additionalInfo!.educations[index];
                      return experience(
                          place: education["place"] ?? "--",
                          from: education["from"] ?? "--",
                          to: education["to"] ?? "--");
                    },
                  )
                : Text(
                    "profiler.noInformation".tr(),
                  ),

        spacer,

//_____________Work Experience______________/
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            "settings.workExp".tr(),
            style: style.copyWith(
              fontSize: 14,
            ),
          ),
        ),
        widget.info == null
            ? (userStore!.userData!.additionalInfo!.workExperiences.isNotEmpty)
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: userStore!
                        .userData!.additionalInfo!.workExperiences.length,
                    itemBuilder: (_, index) {
                      final userExperience = userStore!
                          .userData!.additionalInfo!.workExperiences[index];
                      return experience(
                          place: userExperience["place"] ?? "--",
                          from: userExperience["from"] ?? "--",
                          to: userExperience["to"] ?? "--");
                    })
                : Text(
                    "profiler.noInformation".tr(),
                    style: style.copyWith(
                      color: Color(0xFF7C838D),
                      fontWeight: FontWeight.normal,
                    ),
                  )
            : (widget.info!.additionalInfo!.workExperiences.isNotEmpty)
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        widget.info!.additionalInfo!.workExperiences.length,
                    itemBuilder: (_, index) {
                      final userExperience =
                          widget.info!.additionalInfo!.workExperiences[index];
                      return experience(
                          place: userExperience["place"] ?? "--",
                          from: userExperience["from"] ?? "--",
                          to: userExperience["to"] ?? "--");
                    })
                : Text(
                    "profiler.noInformation".tr(),
                    style: style.copyWith(
                      color: Color(0xFF7C838D),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
      ];

  List<Widget> addToQuest() => [
        if (widget.info != null &&
            userStore!.userData!.role == UserRole.Employer)
          Column(
            children: [
              spacer,
              ElevatedButton(
                onPressed: () async {
                  viewOtherUser!.offset = 0;
                  viewOtherUser!.questForWorker.clear();
                  viewOtherUser!.questId = "";
                  viewOtherUser!.workerId = widget.info!.id;
                  viewOtherUser!
                      .getQuests(userStore!.userData!.id, widget.info!.role);
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    ChooseQuest.routeName,
                    arguments: widget.info!.id,
                  );
                },
                child: Text(
                  "quests.addToQuest".tr(),
                ),
              ),
            ],
          ),
      ];

  List<Widget> workerRateWidgets() => [
        workerRating(
          completedQuests: widget.info == null
              ? userStore!.userData!.questsStatistic!.completed.toString()
              : widget.info!.questsStatistic!.completed.toString(),
          activeQuests: widget.info == null
              ? userStore!.userData!.questsStatistic!.opened.toString()
              : widget.info!.questsStatistic!.opened.toString(),
          averageRating: widget.info == null
              ? userStore!.userData!.ratingStatistic!.averageMark.toString()
              : widget.info!.ratingStatistic!.averageMark.toString(),
          reviews: widget.info == null
              ? userStore!.userData!.ratingStatistic!.reviewCount.toString()
              : widget.info!.ratingStatistic!.reviewCount.toString(),
        ),
      ];
}
