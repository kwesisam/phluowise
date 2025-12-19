import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/utils/hexColor.dart';

class CustomDropdown extends StatelessWidget {
  final String? label;
  final FutureOr<List<String>> items;
  final String? hintText;
  final TextStyle? style;
  final String? selectedItem;
  final double? width;
  final double? height;
  final double? radius;
  final HexColor? backgroundColor;
  final HexColor? borderColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool? isVisible;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    this.label,
    required this.items,
    this.hintText,
    this.selectedItem,
    this.width,
    this.height,
    required this.onChanged,
    this.radius,
    this.backgroundColor,
    this.borderColor,
    this.fontWeight,
    this.fontSize,
    this.style,
    this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label ?? '',
            style: TextStyle(
              color: HexColor('#5B6E80'),
              fontSize: 13,
              fontWeight: fontWeight ?? FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        if (label != null) const SizedBox(height: 5),
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            // border: Border.all(color: borderColor ?? HexColor('#5A5D5F')),
            borderRadius: radius != null
                ? BorderRadius.circular(radius ?? 18)
                : null,
          ),
          child: DropdownSearch<String>(
            items: (filter, infiniteScrollProps) => items,
            selectedItem: selectedItem,
            onChanged: onChanged,

            suffixProps: DropdownSuffixProps(
              dropdownButtonProps: DropdownButtonProps(
                isVisible: isVisible ?? true,
                iconClosed: SvgPicture.asset(AppImages.arrowsquaredown),
                iconOpened: SvgPicture.asset(AppImages.arrowsquaredown),
              ),
            ),
            decoratorProps: DropDownDecoratorProps(
              baseStyle:
                  style ??
                  TextStyle(
                    fontWeight: fontWeight ?? FontWeight.w600,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 15,
                ),
                hintText: hintText,
                hintMaxLines: 1,
                hintStyle: TextStyle(
                  fontWeight: fontWeight ?? FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            popupProps: PopupProps.menu(
              itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                ),
              ),
              constraints: const BoxConstraints(maxHeight: 160),
              menuProps: MenuProps(
                clipBehavior: Clip.hardEdge,
                backgroundColor: HexColor('#40444B'),
                margin: const EdgeInsets.only(top: 12),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
