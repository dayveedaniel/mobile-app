import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/pages/start_page/store/start_store.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';

class StartPage extends StatelessWidget {
  final CarouselController carouselController;

  static const String routeName = '/startPage';

  StartPage() : this.carouselController = new CarouselController();

  @override
  Widget build(BuildContext context) {
    final store = StartStore();
    final mq = MediaQuery.of(context);

    return Scaffold(
      body: Observer(
        builder: (_) => SizedBox(
          height: mq.size.height,
          child: SafeArea(
            top: false,
            bottom: false,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0083C7),
                    Color(0xFF103D7C),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    items: <Widget>[
                      page(
                        image: "assets/start_page_1.png",
                        context: context,
                      ),
                      page(
                        image: "assets/start_page_2.png",
                        context: context,
                      ),
                      page(
                        image: "assets/start_page_3.png",
                        context: context,
                      ),
                    ],
                    options: CarouselOptions(
                        enableInfiniteScroll: true,
                        height: mq.size.height * 0.85,
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          store.setCurrentPos(index);
                        }),
                    carouselController: carouselController,
                  ),
                  buttonRow(
                    currentPos: store.currentPos,
                    store: store,
                    onPressedNext: () {
                      store.currentPos < 2
                          ? carouselController.nextPage()
                          : Navigator.pushNamed(context, SignInPage.routeName);
                    },
                    onPressedSkip: () {
                      Navigator.pushNamed(context, SignInPage.routeName);
                    },
                    context: context,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget page({
    required String image,
    required BuildContext context,
  }) =>
      Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ShaderMask(
            shaderCallback: (rectangle) {
              return LinearGradient(
                colors: [Colors.black, Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(
                Rect.fromLTRB(
                  0,
                  0,
                  rectangle.width,
                  rectangle.height,
                ),
              );
            },
            blendMode: BlendMode.dstIn,
            child: Container(
              height: double.infinity,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "startPage.welcome".tr(),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "startPage.workQuest".tr(),
                  style: TextStyle(
                      fontSize: 34.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    "startPage.title".tr(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget buttonRow({
    required int currentPos,
    required StartStore store,
    required void onPressedSkip()?,
    required void onPressedNext()?,
    required BuildContext context,
  }) =>
      Padding(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 45.0,
              width: 70.0,
              child: OutlinedButton(
                onPressed: onPressedSkip,
                child: Text(
                  "startPage.skip".tr(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1.0,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Observer(
                builder: (_) => DotsIndicator(
                  dotsCount: 3,
                  position: store.currentPos * 1.0,
                  decorator: DotsDecorator(
                    activeColor: Colors.white,
                    color: Colors.white.withOpacity(0.75),
                    activeSize: Size(13, 13),
                    spacing: EdgeInsets.symmetric(horizontal: 2),
                    size: Size(10, 10),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 45.0,
              width: 70.0,
              child: OutlinedButton(
                onPressed: onPressedNext,
                child: Text(
                  "startPage.next".tr(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1.0,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
