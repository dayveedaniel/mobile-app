import 'package:app/ui/pages/main_page/quest_page/quest_page.dart';
import 'package:app/ui/pages/main_page/settings_page/settings_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/wallet_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../background_observer_page.dart';
import '../../../routes.dart';
import 'chat_page/chat_page.dart';
import 'my_quests_page/my_quests_page.dart';

final firstTabNavKey = GlobalKey<NavigatorState>();
final secondTabNavKey = GlobalKey<NavigatorState>();
final thirdTabNavKey = GlobalKey<NavigatorState>();
final forthTabNavKey = GlobalKey<NavigatorState>();
final fiveTabNavKey = GlobalKey<NavigatorState>();

const _tabBarIconsData = [
  const _TabBarIconData('assets/search.svg', 'Quest'),
  const _TabBarIconData('assets/list.svg', 'My quests'),
  const _TabBarIconData('assets/message.svg', 'Chat'),
  const _TabBarIconData('assets/wallet_icon.svg', 'Wallet'),
  const _TabBarIconData('assets/more.svg', 'More'),
];

class MainPage extends StatelessWidget {
  static const String routeName = '/mainPage';

  @override
  Widget build(BuildContext context) {
    return BackgroundObserverPage(
      con: context,
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: _tabBarIconsData
              .map((item) => BottomNavigationBarItem(
                    icon: SvgPicture.asset(item.svgPath),
                    activeIcon: SvgPicture.asset(
                      item.svgPath,
                      color: CupertinoTheme.of(context).primaryColor,
                    ),
                    label: item.label,
                  ))
              .toList(),
        ),
        tabBuilder: (context, index) {
          switch (index){
            case 0 : return CupertinoTabView(
                onGenerateRoute: Routes.generateRoute,
                navigatorKey: firstTabNavKey,
                builder: (context) {
                  return QuestPage();
                });
            case 1 : return CupertinoTabView(
              onGenerateRoute: Routes.generateRoute,
              navigatorKey: secondTabNavKey,
              builder: (context) {
                return MyQuestsPage();
              },
            );
            case 2: return CupertinoTabView(
              onGenerateRoute: Routes.generateRoute,
              navigatorKey: thirdTabNavKey,
              builder: (BuildContext context) => ChatPage(),
            );
            case 3:return CupertinoTabView(
              onGenerateRoute: Routes.generateRoute,
              navigatorKey: forthTabNavKey,
              builder: (BuildContext context) {
                return WalletPage();
              },
            );
            default:return CupertinoTabView(
              onGenerateRoute: Routes.generateRoute,
              navigatorKey: fiveTabNavKey,
              builder: (context) {
                return SettingsPage();
              },
            );
          }
        },
      ),
    );
  }
}

class _TabBarIconData {
  final String svgPath;
  final String label;

  const _TabBarIconData(
    this.svgPath,
    this.label,
  );
}
