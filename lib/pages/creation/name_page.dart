import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/components/form/background_form.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/models/capitalize.dart';
import 'package:pts/widgets/app_text_field.dart';

class NamePage extends StatelessWidget {
  final void Function(BuildContext) onNext;
  final String? title;
  NamePage({required this.onNext, Key? key, this.title}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String _name = title ?? "";

    return BackgroundForm(
      heroTag: "name",
      formkey: _formKey,
      onPressedFAB: () {
        if (!_formKey.currentState!.validate()) return;
        BlocProvider.of<BuildPartiesCubit>(context).setName(_name.inCaps);
        onNext(context);
      },
      children: [
        HeaderText1Form(text: "Comment s'appelle ta soirée ?"),
        AppTextFormField(
          formKey: _formKey,
          hintText: "ex: La Fête du Roi",
          controller: TextEditingController(text: title ?? _name),
          onChanged: (value) => _name = value,
          validator: (value) {
            if (value == null || value.isEmpty)
              return "Vous devez rentrer un nom";
            else if (value.length < 3)
              return "Le nom de la soirée est trop court";
            else
              return null;
          },
        ),
      ],
    );
  }
}
