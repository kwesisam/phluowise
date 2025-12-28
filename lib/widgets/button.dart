import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phluowise/contants/app_color.dart';
import 'package:phluowise/utils/hexColor.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final String? type;
  final Function()? onPressed;
  final double? borderRadius;
  final double? height;
  final Color? color;
  final String? icon;
  final double? fontSize;
  const Button({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.type,
    this.borderRadius,
    this.height,
    this.color,
    this.icon,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: type == 'secondary'
              ? HexColor('#40444B')
              : type == 'white'
              ? HexColor('#FDFFEC')
              : type == 'transparent'
              ? Colors.transparent
              : type == 'danger'
              ? HexColor('#F57D7D')
              : AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(borderRadius ?? 7),
            side: BorderSide(
              color: type == 'secondary'
                  ? HexColor('#40444B')
                  : type == 'white'
                  ? HexColor('#FDFFEC')
                  : type == 'transparent'
                  ? Colors.transparent
                  : type == 'danger'
                  ? HexColor('#F57D7D')
                  : AppColors.primary,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: icon != null ? 8 : 0,
          children: [
            if (icon != null) SvgPicture.asset(icon ?? ''),
            Text(
              buttonText,
              style: TextStyle(
                color:
                    color ??
                    (type == 'secondary'
                        ? AppColors.primary
                        : type == 'white'
                        ? HexColor('#313437')
                        : Colors.white),
                fontSize: fontSize ?? 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
