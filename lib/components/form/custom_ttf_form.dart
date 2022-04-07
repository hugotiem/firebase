import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pts/const.dart';

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
  final bool? readOnly;
  final void Function()? onTap;

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
    this.readOnly,
    this.onTap,
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
              onTap: onTap,
              readOnly: readOnly ?? false,
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
    return Padding(
      padding: const EdgeInsets.only(right: 34, left: 34, bottom: 35),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
            color: PRIMARY_COLOR,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: ICONCOLOR, width: 1.2)),
        child: Padding(
          padding: const EdgeInsets.only(left: 25),
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
                    fontSize: 22,
                    color: ICONCOLOR,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: ICONCOLOR.withOpacity(0.6), fontSize: 22),
                  hintText: this.hintText,
                  border: InputBorder.none,
                  counterText: '',
                  errorStyle: TextStyle(height: 0),
                ),
                maxLength: this.maxLength,
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

class TFFNumber extends StatelessWidget {
  final void Function(String) onChanged;

  const TFFNumber({required this.onChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Container(
        height: 52,
        width: 70,
        decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ICONCOLOR),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: TextFormField(
              onChanged: this.onChanged,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: 30,
                color: ICONCOLOR,
              ),
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
        ),
      ),
    );
  }
}

class TFFForm extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  const TFFForm(this.hintText,
      {this.validator,
      this.onChanged,
      this.controller,
      this.maxLength,
      this.keyboardType,
      this.inputFormatters,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 34, right: 34, bottom: 35),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
            color: PRIMARY_COLOR,
            border: Border.all(color: ICONCOLOR, width: 1.2),
            borderRadius: BorderRadius.circular(34)),
        child: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Center(
            child: TextFormField(
              controller: controller,
              style: TextStyle(
                  fontSize: 22, color: ICONCOLOR, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  hintText: this.hintText,
                  hintStyle: TextStyle(
                      color: ICONCOLOR.withOpacity(0.6), fontSize: 22),
                  border: InputBorder.none,
                  errorStyle: TextStyle(height: 0),
                  counterText: ""),
              validator: this.validator,
              onChanged: onChanged,
              maxLength: maxLength,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
            ),
          ),
        ),
      ),
    );
  }
}
