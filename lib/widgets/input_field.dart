import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phluowise/contants/app_color.dart';
import 'package:phluowise/utils/hexColor.dart';

class InputField extends StatelessWidget {
  final bool? isObsure;
  final bool? isEnable;
  final String? labelText;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? suffixIcon;
  final String? prefixIcon;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle;
  final HexColor? fillColor;
  final HexColor? borderColor;
  final int? maxLines;
  final int? minLines;
  final bool? isExpand;
  final void Function(String)? onChanged;
  const InputField({
    super.key,
    this.isObsure,
    this.isEnable,
    this.labelText,
    this.hintText,
    required this.controller,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.hintStyle,
    this.fillColor,
    this.borderColor,
    this.maxLines,
    this.onChanged,
    this.minLines, this.isExpand,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Inter'),
      cursorColor: Colors.white,
      validator: validator,
      onChanged: onChanged,
      minLines: minLines ?? 1,
      maxLines: maxLines,
      expands: isExpand ?? false,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.white),
        fillColor: fillColor ?? HexColor('#40444B'),
        filled: true,
        
        hintStyle:
            hintStyle ??
            TextStyle(
              color: HexColor('#DDDDDD'),
              fontSize: 16,
              fontFamily: 'Inter',
            ),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 5),
                child: SvgPicture.asset(prefixIcon!, width: 25, height: 25),
              )
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 5),
                child: SvgPicture.asset(suffixIcon!, width: 25, height: 25),
              )
            : null,
        prefixIconConstraints: BoxConstraints(maxWidth: 45, maxHeight: 45),
        suffixIconConstraints: BoxConstraints(maxWidth: 45, maxHeight: 45),
        contentPadding: EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor ?? HexColor('#40444B')),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor ?? HexColor('#40444B')),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor('#FF7576')),
          borderRadius: BorderRadius.circular(16),
        ),
        errorStyle: TextStyle(color: HexColor('#FF7576'), fontSize: 14),
      ),
    );
  }
}
