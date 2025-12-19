import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/models/product_model.dart';
import 'package:phluowise/utils/hexColor.dart';
import 'package:phluowise/widgets/input_field.dart';

class ProductListCard extends StatefulWidget {
  final Product product;
  final TextEditingController controller;
  final bool switchValue;
  final ValueChanged<bool> onSwitchChanged;
  final void Function(String)? onChanged;
  const ProductListCard({
    super.key,
    required this.product,
    required this.controller,
    required this.switchValue,
    required this.onSwitchChanged, this.onChanged,
  });

  @override
  State<ProductListCard> createState() => _ProductListCardState();
}

class _ProductListCardState extends State<ProductListCard> {
  late ValueNotifier<bool> _controllerSwitch;

  @override
  void initState() {
    super.initState();
    _controllerSwitch = ValueNotifier<bool>(widget.switchValue);
    _controllerSwitch.addListener(() {
      widget.onSwitchChanged(_controllerSwitch.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  decoration: BoxDecoration(
                    color: HexColor('#292B2F'),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 47,
                        height: 60,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            imageUrl: widget.product.productImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(strokeWidth: 1),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.productType,
                            style: TextStyle(
                              color: HexColor('#808080'),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            widget.product.size,
                            style: TextStyle(
                              color: HexColor('#B2F5F5F5'),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Divider(height: 2, color: HexColor('#808080')),

                // Middle section
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  decoration: BoxDecoration(color: HexColor('#292B2F')),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '1 ${widget.product.productName.toLowerCase()}',
                          maxLines: 2,
                          style: TextStyle(
                            color: HexColor('#B2F5F5F5'),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price:',
                              style: TextStyle(
                                color: HexColor('#808080'),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'GH₵ ${widget.product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: HexColor('#B2F5F5F5'),
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

                Divider(height: 2, color: HexColor('#808080')),

                // Bottom input field
                Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: HexColor('#303030'),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  child: InputField(
                    controller: widget.controller,
                    hintText: 'Enter number of purchase',
                    fillColor: HexColor('#292B2F'),
                    borderColor: HexColor('#40444B'),
                    keyboardType: TextInputType.number,
                    onChanged: widget.onChanged,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: HexColor('#99FFFFFF'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8),

          // Switch
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: HexColor('#292B2F'),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AdvancedSwitch(
                  inactiveColor: HexColor('#808080'),
                  activeColor: HexColor('#2C9043'),
                  height: 23,
                  width: 40,
                  controller: _controllerSwitch,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
