import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/screens/main/home.dart';
import 'package:phluowise/screens/main/schedule_pickup.dart';
import 'package:phluowise/screens/main/service.dart';
import 'package:phluowise/utils/hexColor.dart';

class Tabs extends StatefulWidget {
  final int? initPage;

  const Tabs({super.key, this.initPage});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  late PersistentTabController controller;

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: widget.initPage ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    
    return PersistentTabView(
      controller: controller,
      tabs: [
        PersistentTabConfig(
          screen: Home(),
          item: ItemConfig(
            icon: SvgPicture.asset(AppImages.homeActive),
            inactiveIcon: SvgPicture.asset(AppImages.home),
            title: "Home",
            activeForegroundColor: HexColor('#3B74FF'),
            inactiveForegroundColor: Colors.white,
            textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        PersistentTabConfig(
          screen: Service(),
          item: ItemConfig(
            icon: SvgPicture.asset(AppImages.truckActive),
            inactiveIcon: SvgPicture.asset(AppImages.truck),
            title: "Services",
            activeForegroundColor: HexColor('#3B74FF'),
            inactiveForegroundColor: Colors.white,
            textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        PersistentTabConfig(
          screen: SchedulePickup(),
          item: ItemConfig(
            icon: SvgPicture.asset(AppImages.calendarsearchActive),
            inactiveIcon: SvgPicture.asset(AppImages.calendarsearch),
            title: "Schedule Pickups",
            activeForegroundColor: HexColor('#3B74FF'),
            inactiveForegroundColor: Colors.white,
            textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color:Theme.of(context).appBarTheme.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        ),
        // itemAnimationProperties: ItemAnimation(
        //   duration: const Duration(milliseconds: 400),
        //   curve: Curves.easeInOut,
        // ),
      ),
    );
  }
}
