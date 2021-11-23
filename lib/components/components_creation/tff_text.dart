import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pts/Constant.dart';

class TFFText extends StatelessWidget {
  final void Function(String)? onChanged;
  final String hintText;
  final int? maxLength;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;
  final TextCapitalization? textCapitalization;
  final bool? obscureText;
  final TextEditingController? controller;
  final Brightness? keyboardAppearance;

  const TFFText({
    this.onChanged,
    required this.hintText,
    this.maxLength,
    required this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.width,
    this.textCapitalization,
    Key? key,
    this.obscureText,
    this.controller,
    this.keyboardAppearance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: HEIGHTCONTAINER,
        width: this.width ?? MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: TextFormField(
              keyboardAppearance: keyboardAppearance,
              controller: controller,
              obscureText: this.obscureText ?? false,
              textCapitalization:
                  this.textCapitalization ?? TextCapitalization.none,
              onChanged: this.onChanged,
              style: TextStyle(
                fontSize: TEXTFIELDFONTSIZE,
              ),
              decoration: InputDecoration(
                hintText: this.hintText,
                border: InputBorder.none,
                counterText: '',
                errorStyle: TextStyle(height: 0),
              ),
              maxLength: this.maxLength,
              validator: this.validator,
              keyboardType: this.keyboardType,
              inputFormatters: this.inputFormatters,
            ),
          ),
        ),
      ),
    );
  }
}

class TypeAheadTFFText extends StatelessWidget {
  final void Function(String)? onChanged;
  final String hintText;
  final int? maxLength;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;
  final TextCapitalization? textCapitalization;
  final bool? obscureText;
  final TextEditingController? controller;
  final Brightness? keyboardAppearance;
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final void Function(dynamic) onSuggestionSelected;
  final FutureOr<Iterable<dynamic>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, Widget, AnimationController?)?
      transitionBuilder;

  const TypeAheadTFFText(
      {this.onChanged,
      required this.hintText,
      this.maxLength,
      required this.validator,
      this.keyboardType,
      this.inputFormatters,
      this.width,
      this.textCapitalization,
      Key? key,
      this.obscureText,
      this.controller,
      this.keyboardAppearance,
      required this.itemBuilder,
      required this.onSuggestionSelected,
      required this.suggestionsCallback,
      this.transitionBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: HEIGHTCONTAINER,
        width: this.width ?? MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: TypeAheadFormField(
              itemBuilder: itemBuilder,
              onSuggestionSelected: onSuggestionSelected,
              suggestionsCallback: suggestionsCallback,
              transitionBuilder: transitionBuilder,
              textFieldConfiguration: TextFieldConfiguration(
                keyboardAppearance: keyboardAppearance,
                controller: controller,
                obscureText: this.obscureText ?? false,
                textCapitalization:
                    this.textCapitalization ?? TextCapitalization.none,
                onChanged: this.onChanged,
                style: TextStyle(
                  fontSize: TEXTFIELDFONTSIZE,
                ),
                decoration: InputDecoration(
                  hintText: this.hintText,
                  border: InputBorder.none,
                  counterText: '',
                  errorStyle: TextStyle(height: 0),
                ),
                maxLength: this.maxLength,
                keyboardType: this.keyboardType!,
                inputFormatters: this.inputFormatters,
              ),
              validator: this.validator,
            ),
          ),
        ),
      ),
    );
  }
}
