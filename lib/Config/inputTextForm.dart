import 'package:flutter/material.dart';

convertKey(text) {
  var removedSteps = text.toString().toLowerCase().replaceAll(' ', '_');
  return removedSteps;
}

class AllInputDesign extends StatefulWidget {
  final controller;
  final prefixText;
  final maxLine;
  final enabled;
  final onTap;
  final onChanged;
  final autoValidate;
  final hintText;
  final labelText;
  final inputHeaderName;
  final textInputAction;
  final counterText;
  final maxLength;
  final obscureText;
  final prefixStyle;
  final validator;
  final errorText;
  final inputborder;
  final contentPadding;
  final autofillHints;
  final initialValue;
  final keyBoardType;
  final validatorFieldValue;
  final alignLabelWithHint;
  final enabledBorder;
  final errorBorder;
  final expand;
  final fillColor;
  final disabledBorder;
  final prefixIcon;
  final focusedBorder;
  final obsecureText;
  final suffixIcon;
  final style;
  final autoFocus;

  const AllInputDesign({
    this.controller,
    this.maxLine = 1,
    this.enabled,
    this.prefixText,
    this.textInputAction,
    this.onTap,
    this.onChanged,
    this.autoValidate,
    this.inputborder,
    this.alignLabelWithHint,
    this.focusedBorder,
    this.enabledBorder,
    this.errorBorder,
    this.expand,
    this.disabledBorder,
    this.prefixIcon,
    this.counterText,
    this.maxLength,
    this.obscureText,
    this.fillColor,
    this.prefixStyle,
    this.keyBoardType,
    this.obsecureText,
    this.contentPadding,
    this.autofillHints,
    this.initialValue,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.inputHeaderName,
    this.validatorFieldValue,
    this.validator,
    this.errorText,
    this.style,
    this.autoFocus = false,
  });

  @override
  _AllInputDesignState createState() => _AllInputDesignState();
}

class _AllInputDesignState extends State<AllInputDesign> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      maxLines: widget.maxLine,
      initialValue: widget.initialValue,
      maxLength: widget.maxLength,
      key: Key(convertKey(widget.inputHeaderName)),
      // onSaved: widget.onSaved,
      autofillHints: widget.autofillHints,
      keyboardType: widget.keyBoardType,
      validator: widget.validator,
      onTap: widget.onTap,
      controller: widget.controller,
      enabled: widget.enabled,
      expands: widget.expand ?? false,
      style: widget.style,
      obscureText: widget.obsecureText ?? false,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      // obs: widget.obsecureText,
      autofocus: widget.autoFocus,
      decoration: InputDecoration(
          // focusedBorder: widget.focusedBorder,
          // enabledBorder: widget.enabledBorder,
          // disabledBorder: widget.disabledBorder,
          // errorBorder: widget.errorBorder,
          prefixIcon: widget.prefixIcon,
          // border: widget.inputborder,
          filled: true,
          fillColor: widget.fillColor ?? Colors.white,
          counterText: widget.counterText,
          hintText: (widget.hintText != null) ? widget.hintText : '',
          labelText: (widget.labelText != null) ? widget.labelText : '',
          alignLabelWithHint: widget.alignLabelWithHint ?? false,
          // labelStyle: GoogleFonts.lato(
          //   color: Colors.black54,
          // ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: widget.suffixIcon != null ? widget.suffixIcon : Text(''),
          ),
          prefixText: (widget.prefixText != null) ? widget.prefixText : '',
          prefixStyle: widget.prefixStyle,
          errorText: widget.errorText,
          contentPadding: widget.contentPadding ?? EdgeInsets.all(15.0),
          focusedBorder: widget.focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.transparent, width: 1.2),
              ),
          enabledBorder: widget.enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.transparent, width: 1.2),
              ),
          // border: OutlineInputBorder(),
          border: widget.inputborder ??
              OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      BorderSide(color: Colors.transparent, width: 1.0))),
    );
  }
}
