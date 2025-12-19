import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    hide LocaleType;
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:phluowise/contants/app_color.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/controllers/appwrite_controller.dart';
import 'package:phluowise/controllers/theme_controller.dart';
import 'package:phluowise/extensions/context_extension.dart';
import 'package:phluowise/models/branch_model.dart';
import 'package:phluowise/models/product_model.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:phluowise/widgets/button.dart';
import 'package:phluowise/widgets/dropdown.dart';
import 'package:phluowise/widgets/expandable_text.dart';
import 'package:phluowise/widgets/input_field.dart';
import 'package:phluowise/widgets/product_list_card.dart';
import 'package:provider/provider.dart';

List<String> daysOfWeek = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

List<String> momoOptions = ['MTN Mobile Money', 'Telecel Cash', 'AT Cash'];

class BranchDetails extends StatefulWidget {
  final Branch branch;
  const BranchDetails({super.key, required this.branch});

  @override
  State<BranchDetails> createState() => _BranchDetailsState();
}

class _BranchDetailsState extends State<BranchDetails> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = true;

  String? selectDay = 'Monday';
  String? selectMono;
  String? openTime = 'Not set';
  String? closeTime = 'Not set';

  int view = 1;

  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  List<String> items = [AppImages.image1, AppImages.image2];
  List<Product>? staticProduct;

  List<TextEditingController> productControllers = [];
  List<bool> productSwitches = [];
  List<double> totals = [];

  double get grandTotal => totals.fold(0.0, (sum, element) => sum + element);

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < productControllers.length; i++) {
      productControllers[i].addListener(() {
        _updateTotalForIndex(i);
      });
    }
  }

  void _updateTotalForIndex(int index) {
    if (index >= staticProduct!.length) return;

    final qtyText = productControllers[index].text;
    final quantity = double.tryParse(qtyText) ?? 0.0;

    if (productSwitches[index]) {
      totals[index] = quantity * staticProduct![index].price;
    } else {
      totals[index] = 0.0;
    }

    setState(() {}); // Rebuild UI to update total
  }

  // MARK: Models

  void showProduct() {
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

                SizedBox(height: 60),

                CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                    height: 600,
                    viewportFraction: 1.0,
                    aspectRatio: 16 / 2,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),

                  items: items.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 500,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              image: AssetImage(i),
                              fit: BoxFit.cover,
                            ),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                        );
                      },
                    );
                  }).toList(),
                ),

                SizedBox(height: 60),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: items.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller?.animateToPage(entry.key),
                      child: Container(
                        width: 13,
                        height: 13,
                        margin: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: _current == entry.key
                              ? AppColors.primary
                              : HexColor('#33F5F5F5'),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void payCashModel() {
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
            child: Center(
              child: Container(
                height: 500,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: HexColor('#40444B'),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.cash),

                    SizedBox(height: 11),

                    Text(
                      'Paying with cash...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 11),

                    Text(
                      'Please make sure you submit payment to the driver on delivery.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'Thank You',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 25),

                    SizedBox(
                      width: 200,
                      child: Button(
                        buttonText: 'Done',
                        borderRadius: 20,
                        onPressed: () {
                          Navigator.of(context).pop();
                          pickUpSent();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void pickUpSent() {
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
            child: Center(
              child: Container(
                height: 400,
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: HexColor('#40444B'),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.pickup),

                    SizedBox(height: 24),

                    Text(
                      'Schedule pickup Sent',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 25),

                    SizedBox(
                      width: 200,
                      child: Button(
                        buttonText: 'Done',
                        borderRadius: 20,
                        onPressed: () {
                          Navigator.of(context).pop();
                          selfRecipient();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // MARK: Bottom sheet
  void showConsent(BuildContext context) {
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
                  maxHeight: MediaQuery.of(context).size.height * .23,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  ),
                  color: HexColor('#40444B'),
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
                            width: 200,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        SizedBox(height: 25),

                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text:
                                  'You are about to place an order. By\nconfirming, you agree to our ',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'terms and\nconditions.',

                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print("Terms and Conditions clicked");
                                      ;
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 11),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 20,
                          children: [
                            Expanded(
                              child: Button(
                                buttonText: 'Cancel',
                                fontSize: 14,
                                borderRadius: 100,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),

                            Expanded(
                              child: Button(
                                buttonText: 'Confirm',
                                fontSize: 14,
                                borderRadius: 100,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showProductList();
                                },
                              ),
                            ),
                          ],
                        ),
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

  void showProductList() {
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
                  maxHeight: MediaQuery.of(context).size.height * .8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  ),
                  color: HexColor('#40444B'),
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
                            width: 200,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        SizedBox(height: 25),

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: HexColor('#292B2F'),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Text(
                                'Total Price counter:',
                                style: TextStyle(
                                  color: HexColor('#808080'),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              Text(
                                'GH₵ ${grandTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: HexColor('#F5F5F5F5'),
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),

                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: staticProduct?.length ?? 0,
                            itemBuilder: (context, index) {
                              final product = staticProduct![index];
                              return ProductListCard(
                                product: product,
                                controller: productControllers[index],
                                switchValue: productSwitches[index],
                                onChanged: (value) {
                                  if (productSwitches[index] == true) {
                                    setModalState(() {
                                      _updateTotalForIndex(index);
                                    });
                                  }
                                },

                                onSwitchChanged: (value) {
                                  setModalState(() {
                                    productSwitches[index] = value;
                                    _updateTotalForIndex(index);
                                  });
                                },
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                          ),
                        ),

                        SizedBox(height: 11),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Button(
                            buttonText: 'Continue',
                            fontSize: 18,
                            borderRadius: 20,
                            onPressed: () {
                              Navigator.of(context).pop();
                              deliveryDateTime();
                            },
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

  void deliveryDateTime() {
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
                  maxHeight: MediaQuery.of(context).size.height * .5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  ),
                  color: HexColor('#40444B'),
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
                            width: 200,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        SizedBox(height: 25),

                        InkWell(
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime(
                                DateTime.now().year + 2,
                                DateTime.now().month,
                                DateTime.now().day,
                              ),
                              onChanged: (date) {
                                print('change $date');
                              },
                              onConfirm: (date) {
                                print('confirm $date');
                              },
                              currentTime: DateTime.now(),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: HexColor('#292B2F'),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 8,
                                    children: [
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                          color: HexColor('#80FFFFFF'),
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      Text(
                                        '3 June 2022',
                                        style: TextStyle(
                                          color: HexColor('#80FFFFFF'),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SvgPicture.asset(
                                  AppImages.arrowright2,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 25),

                        InkWell(
                          onTap: () {
                            DatePicker.showTimePicker(
                              context,
                              showTitleActions: true,

                              onChanged: (date) {
                                print('change $date');
                              },
                              onConfirm: (date) {
                                print('confirm $date');
                              },
                              currentTime: DateTime.now(),
                            );
                          },

                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: HexColor('#292B2F'),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 8,
                                    children: [
                                      Text(
                                        'Time',
                                        style: TextStyle(
                                          color: HexColor('#80FFFFFF'),
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      Text(
                                        '15:36',
                                        style: TextStyle(
                                          color: HexColor('#80FFFFFF'),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SvgPicture.asset(
                                  AppImages.arrowright2,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 25),

                        InputField(
                          controller: TextEditingController(),
                          hintText: 'Add additional Information',
                          fillColor: HexColor('#292B2F'),
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            color: HexColor('#99FFFFFF'),
                          ),
                        ),

                        SizedBox(height: 15),

                        Button(
                          buttonText: 'Continue',
                          fontSize: 18,
                          borderRadius: 20,
                          onPressed: () {
                            Navigator.of(context).pop();
                            agreeTCPayment();
                          },
                        ),
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

  void agreeTCPayment() {
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
                  maxHeight: MediaQuery.of(context).size.height * .2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  ),
                  color: HexColor('#40444B'),
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
                            width: 200,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        SizedBox(height: 30),

                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text:
                                  'You are paying on delivery. By confirming,\nyou agree to our',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'terms and conditions.',

                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print("Terms and Conditions clicked");
                                      ;
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                        Button(
                          buttonText: 'Confirm',
                          fontSize: 14,
                          borderRadius: 100,
                          onPressed: () {
                            Navigator.of(context).pop();
                            showPaymentOption();
                          },
                        ),
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

  void showPaymentOption() {
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
                  maxHeight: MediaQuery.of(context).size.height * .2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  ),
                  color: HexColor('#40444B'),
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
                            width: 200,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 20,
                          children: [
                            Button(
                              buttonText: 'Pay with Mobile money',
                              fontSize: 14,
                              borderRadius: 100,
                              onPressed: () {
                                Navigator.of(context).pop();
                                momoPayment();
                              },
                            ),

                            Button(
                              buttonText: 'Pay with cash',
                              fontSize: 14,
                              borderRadius: 100,
                              onPressed: () {
                                Navigator.of(context).pop();
                                payCashModel();
                              },
                            ),
                          ],
                        ),
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

  void momoPayment() {
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
                  maxHeight: MediaQuery.of(context).size.height * .5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  ),
                  color: HexColor('#40444B'),
                ),
                child: Center(
                  child: SizedBox(
                    width: context.screenWidth * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 11),

                        Center(
                          child: Container(
                            width: 200,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        SizedBox(height: 19),

                        Center(
                          child: Text(
                            'Pay with Mobile money',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        SizedBox(height: 25),

                        CustomDropdown(
                          items: momoOptions,
                          backgroundColor: HexColor('#292B2F'),
                          radius: 16,
                          height: 55,
                          selectedItem: selectMono,
                          borderColor: HexColor('#40444BF5'),
                          hintText: 'Choose mobile money network',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          onChanged: (value) {
                            setModalState(() {
                              selectMono = value;
                            });
                          },
                        ),

                        SizedBox(height: 25),

                        InputField(
                          controller: TextEditingController(),
                          hintText: 'Phone Number',
                          fillColor: HexColor('#292B2F'),
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            color: HexColor('#99FFFFFF'),
                          ),
                        ),

                        SizedBox(height: 25),

                        Container(
                          height: 57,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: HexColor('#292B2F'),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'GHS10',
                            style: TextStyle(
                              color: HexColor('#4DFFFFFF'),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        SizedBox(height: 25),

                        SizedBox(height: 15),

                        Button(
                          buttonText: 'Continue',
                          fontSize: 18,
                          borderRadius: 20,
                          onPressed: () {
                            Navigator.of(context).pop();
                            agreeTCPayment();
                          },
                        ),
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

  void selfRecipient() {
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
                  maxHeight: MediaQuery.of(context).size.height * .75,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  ),
                  color: HexColor('#40444B'),
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
                            width: 200,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Center(
                          child: Text(
                            'Order Recipient',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              'Delivery Audience',
                              style: TextStyle(
                                color: HexColor('#CCFFFFFF'),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 11,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: Button(
                                    buttonText: 'My self',
                                    fontSize: 13,
                                    borderRadius: 8,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Button(
                                    type: 'secondary',
                                    buttonText: 'Someone',
                                    fontSize: 13,
                                    borderRadius: 8,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      someOneRecipient();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Button(
                                    type: 'secondary',
                                    buttonText: 'Organization',
                                    fontSize: 13,
                                    borderRadius: 8,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      organizationRecipient();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 40),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              'Delivery Audience',
                              style: TextStyle(
                                color: HexColor('#CCFFFFFF'),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // No profile found
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: HexColor('#303030'),
                                  width: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No Saved Profiles Found.',
                                    style: TextStyle(
                                      color: HexColor('#80FFFFFF'),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Text(
                                    'Create a profile and check the ‘Save’ box to add one!',
                                    style: TextStyle(
                                      color: HexColor('#80FFFFFF'),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              'Current Recipient Details',
                              style: TextStyle(
                                color: HexColor('#CCFFFFFF'),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            // No profile found
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: HexColor('#303030'),
                                  width: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 12,
                                children: [
                                  Text(
                                    'Delivery Address *',
                                    style: TextStyle(
                                      color: HexColor('#80FFFFFF'),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  InputField(
                                    controller: TextEditingController(),
                                    maxLines: 5,
                                    borderColor: HexColor('#F540444B'),
                                    fillColor: HexColor('292B2F'),
                                    hintText:
                                        'Full address or detailed location\n(e.g: 5th Floor, Block B, Ring Road)',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Save this for future orders',
                              style: TextStyle(
                                color: HexColor('#FFFFFF'),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 50),

                        Center(
                          child: SizedBox(
                            height: 44,
                            width: 300,
                            child: Button(
                              buttonText: 'Confirm',
                              fontSize: 14,
                              borderRadius: 100,
                              onPressed: () {
                                Navigator.of(context).pop();
                                showPaymentOption();
                              },
                            ),
                          ),
                        ),
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

  void someOneRecipient() {
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
                  maxHeight: MediaQuery.of(context).size.height * .88,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  ),
                  color: HexColor('#40444B'),
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
                            width: 200,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Center(
                          child: Text(
                            'Order Recipient',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              'Delivery Audience',
                              style: TextStyle(
                                color: HexColor('#CCFFFFFF'),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 11,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: Button(
                                    type: 'secondary',
                                    buttonText: 'My self',
                                    fontSize: 13,
                                    borderRadius: 8,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      selfRecipient();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Button(
                                    buttonText: 'Someone',
                                    fontSize: 13,
                                    borderRadius: 8,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Button(
                                    type: 'secondary',
                                    buttonText: 'Organization',
                                    fontSize: 13,
                                    borderRadius: 8,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      organizationRecipient();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 40),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              'Delivery Audience',
                              style: TextStyle(
                                color: HexColor('#CCFFFFFF'),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // No profile found
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: HexColor('#303030'),
                                  width: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No Saved Profiles Found.',
                                    style: TextStyle(
                                      color: HexColor('#80FFFFFF'),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Text(
                                    'Create a profile and check the ‘Save’ box to add one!',
                                    style: TextStyle(
                                      color: HexColor('#80FFFFFF'),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              'Current Recipient Details',
                              style: TextStyle(
                                color: HexColor('#CCFFFFFF'),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: HexColor('#303030'),
                                  width: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name *',
                                    style: TextStyle(
                                      color: HexColor('#80FFFFFF'),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  SizedBox(height: 12),

                                  InputField(
                                    controller: TextEditingController(),
                                    borderColor: HexColor('#F540444B'),
                                    fillColor: HexColor('292B2F'),
                                    hintText: 'Full Name',
                                  ),

                                  SizedBox(height: 30),

                                  Text(
                                    'Delivery Address *',
                                    style: TextStyle(
                                      color: HexColor('#80FFFFFF'),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  SizedBox(height: 12),

                                  InputField(
                                    controller: TextEditingController(),
                                    maxLines: 5,
                                    borderColor: HexColor('#F540444B'),
                                    fillColor: HexColor('292B2F'),
                                    hintText:
                                        'Full address or detailed location\n(e.g: 5th Floor, Block B, Ring Road)',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Save this for future orders',
                              style: TextStyle(
                                color: HexColor('#FFFFFF'),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 50),

                        Center(
                          child: SizedBox(
                            height: 44,
                            width: 300,
                            child: Button(
                              buttonText: 'Confirm',
                              fontSize: 14,
                              borderRadius: 100,
                              onPressed: () {
                                Navigator.of(context).pop();
                                showPaymentOption();
                              },
                            ),
                          ),
                        ),
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

  void organizationRecipient() {
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
                  maxHeight: MediaQuery.of(context).size.height,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  ),
                  color: HexColor('#40444B'),
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
                            width: 200,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Center(
                          child: Text(
                            'Order Recipient',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              'Delivery Audience',
                              style: TextStyle(
                                color: HexColor('#CCFFFFFF'),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 11,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: Button(
                                    type: 'secondary',
                                    buttonText: 'My self',
                                    fontSize: 13,
                                    borderRadius: 8,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      selfRecipient();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Button(
                                    type: 'secondary',

                                    buttonText: 'Someone',
                                    fontSize: 13,
                                    borderRadius: 8,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      someOneRecipient();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Button(
                                    buttonText: 'Organization',
                                    fontSize: 13,
                                    borderRadius: 8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 40),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              'Delivery Audience',
                              style: TextStyle(
                                color: HexColor('#CCFFFFFF'),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // No profile found
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: HexColor('#303030'),
                                  width: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No Saved Profiles Found.',
                                    style: TextStyle(
                                      color: HexColor('#80FFFFFF'),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Text(
                                    'Create a profile and check the ‘Save’ box to add one!',
                                    style: TextStyle(
                                      color: HexColor('#80FFFFFF'),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              'Current Recipient Details',
                              style: TextStyle(
                                color: HexColor('#CCFFFFFF'),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            // No profile found
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: HexColor('#303030'),
                                  width: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Organization Name *',
                                    style: TextStyle(
                                      color: HexColor('#80FFFFFF'),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  SizedBox(height: 12),

                                  InputField(
                                    controller: TextEditingController(),
                                    borderColor: HexColor('#F540444B'),
                                    hintText: 'Eg. Grand Hotel',
                                    fillColor: HexColor('#292B2F'),
                                  ),

                                  SizedBox(height: 30),

                                  Text(
                                    'Select Organization Type*',
                                    style: TextStyle(
                                      color: HexColor('#80FFFFFF'),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  SizedBox(height: 12),

                                  CustomDropdown(
                                    items: ['items'],
                                    onChanged: (value) {},
                                    borderColor: HexColor('#F540444B'),
                                    backgroundColor: HexColor('#292B2F'),
                                  ),

                                  SizedBox(height: 30),

                                  Text(
                                    'Delivery Address *',
                                    style: TextStyle(
                                      color: HexColor('#80FFFFFF'),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  SizedBox(height: 12),

                                  InputField(
                                    controller: TextEditingController(),
                                    maxLines: 5,
                                    borderColor: HexColor('#F540444B'),
                                    fillColor: HexColor('#292B2F'),
                                    hintText:
                                        'Full address or detailed location\n(e.g: 5th Floor, Block B, Ring Road)',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Save this for future orders',
                              style: TextStyle(
                                color: HexColor('#FFFFFF'),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 50),

                        Center(
                          child: SizedBox(
                            height: 44,
                            width: 300,
                            child: Button(
                              buttonText: 'Confirm',
                              fontSize: 14,
                              borderRadius: 100,
                              onPressed: () {
                                Navigator.of(context).pop();
                                showPaymentOption();
                              },
                            ),
                          ),
                        ),
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
    final themeController = context.read<ThemeController>();
    final appWrite = context.watch<AppwriteAuthProvider>();

    return Scaffold(
      body: Builder(
        builder: (scaffoldContext) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: _pinned,
                snap: _snap,
                floating: _floating,
                expandedHeight: 175,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: SvgPicture.asset(AppImages.back),
                ),

                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  Container(
                    width: 45,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: themeController.isDarkMode
                          ? HexColor('#4D40444B')
                          : HexColor('#40444B'),
                      border: Border.all(
                        color: themeController.isDarkMode
                            ? HexColor('#808080')
                            : HexColor('#40444B'),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ),

                  SizedBox(width: 10),
                ],

                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final appBarHeight = constraints.biggest.height;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  widget.branch.headerImage != null &&
                                      widget.branch.headerImage!.isNotEmpty
                                  ? CachedNetworkImageProvider(
                                      widget.branch.headerImage!,
                                    )
                                  : const AssetImage(
                                          "assets/images/default_header.jpg",
                                        )
                                        as ImageProvider,
                            ),
                          ),
                        ),

                        Positioned(
                          left: context.screenWidth * 0.075,
                          bottom: -45,
                          child: Container(
                            width: 92,
                            height: 92,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: HexColor('#40444B'),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  widget.branch.profileImage != null &&
                                      widget.branch.profileImage!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: widget.branch.profileImage!,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) =>
                                          Container(color: Colors.grey[300]),
                                      errorWidget: (_, __, ___) => Image.asset(
                                        AppImages.image1,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      AppImages.image1,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: context.screenWidth * .90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpandableGradientText(
                                text:
                                    "asfljfjasfsljfdlasfdjlsdaflksdfljkdfsafddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
                                trimLines: 3,
                              ),

                              SizedBox(height: 5),

                              workingDayFilter(),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 5),

                      workingDays(),

                      SizedBox(height: 5),

                      socialMedia(),

                      SizedBox(height: 15),

                      details(scaffoldContext),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget workingDayFilter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 22,
      children: [
        Text(
          'Working Days:',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: SizedBox(
            width: 150,
            child: CustomDropdown(
              items: daysOfWeek,
              backgroundColor: HexColor('#202225'),

              selectedItem: selectDay,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  selectDay = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget workingDays() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(color: HexColor('#292B2F')),
      child: Row(
        spacing: 35,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Opening time:',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  openTime ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Closing time:',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  closeTime ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget socialMedia() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(color: HexColor('#40444B')),
      child: Row(
        children: [
          Text(
            'Social media',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          Spacer(),

          Row(
            spacing: 8,
            children: [1, 2, 3, 4]
                .map(
                  (ele) => InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(4.7),
                    child: Container(
                      height: 32,
                      width: 32,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: HexColor('#333333'),
                        borderRadius: BorderRadius.circular(4.7),
                        border: Border.all(color: HexColor('#40444B')),
                      ),
                      child: SvgPicture.asset(AppImages.discord),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget details(BuildContext scaffoldContext) {
    return SizedBox(
      height: 450, // Choose appropriate height
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 17,
              children: [
                IntrinsicHeight(
                  child: Button(
                    buttonText: 'Schedule Order',
                    type: view == 0 ? 'Primary' : 'transparent',
                    borderRadius: 100,
                    onPressed: () {
                      setState(() {
                        view = 0;
                      });
                    },
                  ),
                ),
                IntrinsicHeight(
                  child: Button(
                    buttonText: 'Products',
                    borderRadius: 100,
                    type: view == 1 ? 'Primary' : 'transparent',
                    onPressed: () {
                      setState(() {
                        view = 1;
                      });
                    },
                  ),
                ),
                IntrinsicHeight(
                  child: Button(
                    buttonText: 'Rating',
                    borderRadius: 100,
                    type: view == 2 ? 'Primary' : 'transparent',
                    onPressed: () {
                      setState(() {
                        view = 2;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          Expanded(child: buildSlideContent(view, scaffoldContext)),
        ],
      ),
    );
  }

  Widget buildSlideContent(int index, BuildContext scaffoldContext) {
    switch (index) {
      case 0:
        return pickUp(scaffoldContext);
      case 1:
        return products(branchId: widget.branch.branchId);
      case 2:
        return rating();
      default:
        return SizedBox.shrink();
    }
  }

  Widget pickUp(BuildContext scaffoldContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 25,
      children: [
        Container(
          height: 255,
          decoration: BoxDecoration(color: Colors.grey.shade100),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
          child: Button(
            buttonText: 'Schedule Pickup',
            borderRadius: 30,
            fontSize: 16,
            onPressed: () {
              showConsent(scaffoldContext);
            },
          ),
        ),
      ],
    );
  }

  Widget products({required String branchId}) {
    final appWrite = context.read<AppwriteAuthProvider>();

    return FutureBuilder<List<Product>>(
      future: appWrite.loadBranchProducts(branchId: branchId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Failed to load products"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No products available"));
        }

        final products = snapshot.data!;

        staticProduct = products;

        productControllers = List.generate(
          staticProduct?.length ?? 0,
          (_) => TextEditingController(),
        );

        productSwitches = List.generate(
          staticProduct?.length ?? 0,
          (_) => false,
        );

        totals = List.generate(staticProduct?.length ?? 0, (_) => 0);

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return InkWell(
              onTap: showProduct,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        product.productImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(AppImages.image1, fit: BoxFit.cover),
                      ),
                    ),

                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                          child: Container(
                            height: 35,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${product.currency} ${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SvgPicture.asset(AppImages.clipboard),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.size,
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: HexColor('#3A3C40'),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        product.discount?.isNotEmpty == true
                                            ? product.discount!
                                            : '-less',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget rating() {
    return Container();
  }
}
