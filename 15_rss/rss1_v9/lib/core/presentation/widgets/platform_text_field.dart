import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'abstract_plaform_widget.dart';

class RmTextField
    extends AbstractPlatformWidget<CupertinoTextField, TextField> {
  const RmTextField(
      {super.key,
      this.controller,
      this.focusNode,
      this.maxLength,
      this.inputFormatters,
      this.keyboardType,
      this.autocorrect = true,
      this.contextMenuBuilder,
      this.hintText,
      this.obscureText = false});

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool autocorrect;
  final dynamic contextMenuBuilder;
  final String? hintText;
  final bool obscureText;

  @override
  CupertinoTextField buildCupertino(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      focusNode: focusNode,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autocorrect: autocorrect,
      contextMenuBuilder: contextMenuBuilder,
      placeholder: hintText,
      obscureText: obscureText,
    );
  }

  @override
  TextField buildMaterial(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autocorrect: autocorrect,
      contextMenuBuilder: contextMenuBuilder,
      decoration: InputDecoration(
        labelText: hintText,
      ),
      obscureText: obscureText,
    );
  }
}
