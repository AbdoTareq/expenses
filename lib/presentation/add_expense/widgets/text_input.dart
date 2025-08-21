// TextField that takes TextEditingController from the main controller(ex:LoginController) to control text from outside to be independent widget
import 'package:expenses/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    super.key,
    this.focus,
    this.controller,
    this.function,
    required this.hint,
    this.spaceAfter = true,
    this.inputType,
    this.maxLength,
    this.registerFocus = false,
    this.isPass = false,
    this.onTap,
    this.disableInput = false,
    this.enabled = true,
    this.borderColor = Colors.transparent,
    this.validate,
    this.suffixIcon,
    this.prefixIcon,
    this.fontSize,
    this.alignLabelWithHint = true,
    this.color,
    this.onChanged,
    this.textColor,
    this.showUnderline = true,
    this.hintColor,
    this.autofillHints,
    this.minLines,
    this.maxLines,
    this.contentPadding,
    this.cursorColor,
  });

  final FocusNode? focus;
  final Function? function;
  final String hint;
  final bool spaceAfter;
  final TextInputType? inputType;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final Function(String value)? onChanged;
  final double? fontSize;
  final bool registerFocus;
  final bool? alignLabelWithHint;
  final bool isPass;
  final Function()? onTap;
  final bool disableInput;
  final bool enabled;
  final Color borderColor;
  final Color? cursorColor;
  final String? Function(String?)? validate;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? color;
  final Color? textColor;
  final Color? hintColor;
  final EdgeInsets? contentPadding;
  final TextEditingController? controller;
  final bool showUnderline;
  final Iterable<String>? autofillHints;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: widget.autofillHints,
      onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        alignLabelWithHint: false,
        // to hide maxLength counter
        counterText: '',
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: widget.contentPadding ?? const EdgeInsets.all(16),
        errorStyle: const TextStyle(fontSize: 12, height: 0.8),
        filled: true,
        fillColor: kGrey3,
        // hintStyle: context.textTheme.labelSmall,
        // labelStyle: context.textTheme.labelSmall,
        labelText: widget.hint,
        suffixIcon: widget.suffixIcon,
        suffixIconConstraints: const BoxConstraints(minWidth: 60),
        prefixIcon: widget.prefixIcon,
        prefixIconConstraints: const BoxConstraints(minWidth: 80),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: widget.borderColor),
        ),
      ),
      onTap: widget.onTap,
      cursorColor: widget.cursorColor ?? widget.borderColor,
      onChanged: widget.onChanged,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      textInputAction: TextInputAction.next,
      autofocus: widget.registerFocus,
      enableInteractiveSelection: !widget.disableInput,
      enabled: widget.enabled,
      keyboardType: widget.inputType,
      obscureText: widget.isPass,
      inputFormatters: [
        if (widget.inputType == TextInputType.number)
          FilteringTextInputFormatter.allow(RegExp("[-0-9,.]")),
      ],
      readOnly: widget.disableInput,
      maxLength: widget.maxLength,
      onFieldSubmitted: (v) async {
        FocusScope.of(context).requestFocus(widget.focus);
        try {
          await widget.function!();
        } catch (e) {}
      },
      validator: widget.validate,
    );
  }
}
