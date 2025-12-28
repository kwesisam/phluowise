import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:phluowise/widgets/button.dart';

class SchedulePickup extends StatefulWidget {
  const SchedulePickup({super.key});

  @override
  State<SchedulePickup> createState() => _SchedulePickupState();
}

class _SchedulePickupState extends State<SchedulePickup> {
  int currentIndex = 0;

  final GlobalKey<ContainedTabBarViewState> _tabKey =
      GlobalKey<ContainedTabBarViewState>();

  // MARK: Modes

  void showOrderStatus({required String type}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 10,
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: context.screenHeight * .95,
            width: context.screenWidth * 0.9,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: SvgPicture.asset(AppImages.back),
                    ),
                  ],
                ),

                Spacer(),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: type != 'pending' ? 70 : 50, vertical: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: HexColor('#40444B')),
                    color: HexColor('#40444B'),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 20,
                        spreadRadius: 0,
                        color: HexColor('#40000000'),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      if (type == 'denied')
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Your order is has been\n',

                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'denied',
                                style: TextStyle(color: HexColor('#F85D5D')),
                              ),
                              TextSpan(text: '.'),
                            ],
                          ),
                        ),

                      if (type == 'accepted')
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Your order is has been\n',

                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'accepted',
                                style: TextStyle(color: HexColor('#2C9043')),
                              ),
                              TextSpan(text: '.'),
                            ],
                          ),
                        ),

                      if (type == 'pending')
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Your order is has been ',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'pending',
                                style: TextStyle(color: HexColor('#F9A24B')),
                              ),
                              TextSpan(text: '.'),

                              TextSpan(
                                text:
                                    'Wait for [company name] to\naccept your order',
                              ),
                            ],
                          ),
                        ),

                      Text(
                        'See details of Order',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: HexColor('#F5F5F5F5'),
                          decoration: TextDecoration.underline,
                          decorationColor: HexColor('#F5F5F5F5'),
                        ),
                      ),

                      IntrinsicWidth(
                        child: SizedBox(
                          height: 38,
                          child: Button(buttonText: 'Okay', borderRadius: 100),
                        ),
                      ),
                    ],
                  ),
                ),

                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  // MARK: Bottom sheets
  void showReturnModel() {
    showMaterialModalBottomSheet(
      context: context,
      bounce: true,
      closeProgressThreshold: 20,
      enableDrag: false,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * .7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  ),
                  color: HexColor('#292B2F'),
                ),
                child: Center(
                  child: SizedBox(
                    width: context.screenWidth * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 11),
                        Center(
                          child: Container(
                            width: 150,
                            height: 5,
                            decoration: BoxDecoration(
                              color: HexColor('#F5F5F5F5'),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        SizedBox(height: 21),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              height: context.screenHeight * .7,
                              child: Column(
                                spacing: 10,
                                children: [returnPickupCard()],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#202225'),
        title: Text(
          'Schedule Pickups',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: HexColor('#292B2F'),
          width: double.infinity,
          child: ContainedTabBarView(
            key: _tabKey,
            tabBarProperties: TabBarProperties(),
            tabs: [
              IntrinsicWidth(
                child: Button(
                  buttonText: 'Status',
                  type: currentIndex != 0 ? 'transparent' : null,
                  onPressed: () {
                    _tabKey.currentState?.animateTo(0);
                  },
                ),
              ),
              IntrinsicWidth(
                child: Button(
                  buttonText: 'Ongoing',
                  type: currentIndex != 1 ? 'transparent' : null,
                  onPressed: () {
                    _tabKey.currentState?.animateTo(1);
                  },
                ),
              ),
              IntrinsicWidth(
                child: Button(
                  buttonText: 'Completed',
                  type: currentIndex != 2 ? 'transparent' : null,
                  onPressed: () {
                    _tabKey.currentState?.animateTo(2);
                  },
                ),
              ),
            ],
            views: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [contentCard()],
                ),
              ),
              SingleChildScrollView(child: Column(children: [contentCard()])),
              SingleChildScrollView(child: Column(children: [contentCard()])),
            ],
            onChange: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget contentCard() {
    return InkWell(
      onTap: () {
        showOrderStatus(type: "pending");
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        color: HexColor('#40444B'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 13,
          children: [
            Container(
              width: 89,
              height: 88,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(11),
              ),
            ),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 24,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Company Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      Text(
                        'location',
                        style: TextStyle(
                          color: HexColor('#F5F5F5F5'),
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 9,
                        children: [
                          Text(
                            '12:30am',
                            style: TextStyle(
                              color: HexColor('#FFFFFF'),
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          Text(
                            'July 20, 2023',
                            style: TextStyle(
                              color: HexColor('#FFFFFF'),
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          Text(
                            'Cash',
                            style: TextStyle(
                              color: HexColor('#FFFFFF'),
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 3,
                    children: [
                      Text(
                        'GH₵20',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        'Order accepted',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget returnPickupCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: HexColor('#40444B'),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                Container(
                  width: 60,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: HexColor('#333333'), width: 1.74),
                    color: Colors.white,
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        'Dispenser Bottle',
                        style: TextStyle(
                          color: HexColor('#808080'),
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Text(
                        '20L',
                        style: TextStyle(
                          color: HexColor('#B2F5F5F5'),
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(color: HexColor('#808080'), height: 2),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      '1 Disipenser bottle of  water',
                      style: TextStyle(
                        color: HexColor('#B2F5F5F5'),
                        fontFamily: 'Inter',
                        fontSize: 14,
                        height: 1.1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 7,
                      children: [
                        Text(
                          'Price:',
                          style: TextStyle(
                            color: HexColor('#808080'),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          'GH₵ 10.00',
                          style: TextStyle(
                            color: HexColor('#B2F5F5F5'),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: HexColor('#808080'), height: 2),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 15,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: HexColor('#292B2F'),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: HexColor('#40444B')),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 3,
                      children: [
                        Text(
                          'Number of purchase',
                          style: TextStyle(
                            color: HexColor('#99FFFFFF'),
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          '2',
                          style: TextStyle(
                            color: HexColor('#B2F5F5F5'),
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: 47,
                    child: Button(
                      buttonText: 'Return dispenser bottle',
                      borderRadius: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
