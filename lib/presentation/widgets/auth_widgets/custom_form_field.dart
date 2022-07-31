import 'package:flutter/material.dart';
import '../../../constants/palette.dart';

class CustomFormField extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final bool readOnly;
  final Color hintTextColor;
  final Function()? onTap;
  final Function(String?)? onChanged;
  final Function(String?)? onFieldSubmitted;
  final FontWeight hintTextWeight;
  final bool wantBorder;
  final bool autofocus;
  final TextInputType keyboardType;
  final double? fontSize;
  final Color textColor;
  final FocusNode? focusNode;

  const CustomFormField({
    Key? key,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.controller,
    this.focusNode,
    this.textAlign = TextAlign.center,
    this.readOnly = false,
    this.autofocus = false,
    this.wantBorder = true,
    this.hintTextColor = Colors.grey,
    this.textColor = Colors.black,
    this.hintTextWeight = FontWeight.w500,
    this.keyboardType = TextInputType.number,
    this.onChanged,
    this.onFieldSubmitted,
    this.fontSize,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      autofocus: autofocus,
      readOnly: readOnly,
      controller: controller,
      textAlign: textAlign,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: keyboardType,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(
        color: textColor,
        letterSpacing: 1.4,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 20.0,
          maxHeight: 5.0,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintTextColor,
          fontWeight: hintTextWeight,
          letterSpacing: 1.4,
          fontSize: fontSize,
        ),
        border: wantBorder
            ? const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Palette.tabColor,
                  width: 2.0,
                ),
              )
            : InputBorder.none,
        enabledBorder: wantBorder
            ? const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Palette.tabColor,
                  width: 1.0,
                ),
              )
            : InputBorder.none,
        focusedBorder: wantBorder
            ? const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Palette.tabColor,
                  width: 2.0,
                ),
              )
            : InputBorder.none,
      ),
    );
  }
}
