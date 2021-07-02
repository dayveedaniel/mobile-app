import 'dart:async';

import 'package:app/log_service.dart';
import 'package:app/ui/pages/main_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/my_quests_page/my_quests_item.dart';
import 'package:app/ui/pages/main_page/quest_page/store/quests_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/work_quest_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import "package:provider/provider.dart";

import '../../../../enums.dart';

class QuestPage extends StatefulWidget {
  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  Location _location = Location();

  late GoogleMapController _controller;
  CameraPosition? _initialCameraPosition;
  QuestsStore? questsStore;
  ProfileMeStore? profileMeStore;
  final QuestItemPriorityType questItemPriorityType =
      QuestItemPriorityType.Starred;

  @override
  void initState() {
    questsStore = context.read<QuestsStore>();
    profileMeStore = context.read<ProfileMeStore>();
    profileMeStore!.getProfileMe();
    questsStore!.getQuests();
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        body: _initialCameraPosition == null
            ? getBody()
            : questsStore!.isMapOpened()
                ? GoogleMap(
                    mapType: MapType.normal,
                    rotateGesturesEnabled: false,
                    initialCameraPosition: _initialCameraPosition!,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    },
                  )
                : getBody(),
        floatingActionButton: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: GestureDetector(
                onTap: () {
                  print("value should be changed");
                  setState(() {
                    questsStore!.changeValue();
                  });
                },
                child: Container(
                  // onPressed: _onMyLocationPressed,
                  padding: const EdgeInsets.only(
                      top: 11, bottom: 11, left: 17, right: 15),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(44),
                  ),
                  child: Row(
                    children: [
                      questsStore!.isMapOpened()
                          ? Icon(
                              Icons.list,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.map_outlined,
                              color: Colors.white,
                            ),
                      SizedBox(
                        width: 12,
                      ),
                      questsStore!.isMapOpened()
                          ? Text(
                              "List",
                              style: TextStyle(color: Colors.white),
                            )
                          : Text(
                              "Map",
                              style: TextStyle(color: Colors.white),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            Opacity(
              opacity: questsStore!.isMapOpened() ? 0 : 1,
              child: FloatingActionButton(
                onPressed: _onMyLocationPressed,
                child: Icon(
                  Icons.location_on,
                ),
              ),
            )
            //: Container(),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    // if(profileMeStore!.userData.role == UserRole.Worker){
    //
    // }

    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        _getDivider(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateQuestPage.routeName);
            },
            child: Text("Create quest"),
          ),
        ),
        _getDivider(),
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: questsStore!.questsList!.length,
              itemBuilder: (_, index) {
                return MyQuestsItem(
                  title: questsStore!.questsList![index].title,
                  itemType: this.questItemPriorityType,
                  price: questsStore!.questsList![index].price,
                  priority: questsStore!.questsList![index].priority,
                  creatorName: questsStore!.questsList![index].user.firstName +
                      questsStore!.questsList![index].user.lastName,
                  description: questsStore!.questsList![index].description,
                );
              }),
        )
      ],
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

  Future<void> _onMyLocationPressed() async {
    // final _permissionGranted = await _location.requestPermission();
    // println("Location permission => $_permissionGranted");
    // if (_permissionGranted == PermissionStatus.deniedForever) {
    //   showCupertinoDialog(
    //     context: context,
    //     builder: (context) {
    //       return CupertinoAlertDialog(
    //         title: Text("Access to geolocation is prohibited"),
    //         content: Text(
    //           "Please open settings and allow WorkQuest to use your location",
    //         ),
    //         actions: [
    //           CupertinoDialogAction(
    //             child: Text("Close"),
    //             onPressed: Navigator.of(context).pop,
    //           ),
    //           CupertinoDialogAction(
    //             child: Text("Settings"),
    //             onPressed: () {},
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return;
    // }

    final myLocation = await _location.getLocation();

    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(myLocation.latitude!, myLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  Future<void> _getCurrentLocation() async {
    final _permissionGranted = await _location.requestPermission();
    println("Location permission => $_permissionGranted");
    if (_permissionGranted == PermissionStatus.deniedForever) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Access to geolocation is prohibited"),
            content: Text(
              "Please open settings and allow WorkQuest to use your location",
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("Close"),
                onPressed: Navigator.of(context).pop,
              ),
              CupertinoDialogAction(
                child: Text("Settings"),
                onPressed: () {},
              ),
            ],
          );
        },
      );

      _initialCameraPosition = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(37.43296265331129, -122.08832357078792),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414,
      );

      this.setState(() {});
      return;
    }

    final myLocation = await _location.getLocation();

    _initialCameraPosition = CameraPosition(
      bearing: 0,
      target: LatLng(myLocation.latitude!, myLocation.longitude!),
      zoom: 17.0,
    );

    this.setState(() {});
    return;
  }
}
