import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/components/form/custom_ttf_form.dart';
import 'package:pts/components/form/fab_form.dart';
import 'package:pts/const.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/models/capitalize.dart';

class NamePage extends StatefulWidget {
  final void Function()? onNext;

  const NamePage({Key? key, this.onNext}) : super(key: key);
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  late String _name;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FORMBACKGROUNDCOLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          leading: CupertinoButton(
            child: Icon(
              Ionicons.close_outline,
              color: ICONCOLOR,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButton: FABForm(
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          BlocProvider.of<BuildPartiesCubit>(context)
              .addItem("name", _name.trimRight().trimLeft().inCaps);
          widget.onNext!();
          FocusScope.of(context).unfocus();
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => ThemePage()));
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText1(
                text: "Comment s'appelle ta soirée ?",
              ),
              TFFText(
                onChanged: (value) {
                  _name = value;
                },
                hintText: 'ex : La fête du roi',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vous devez rentrer un nom';
                  } else {
                    return null;
                  }
                },
                maxLength: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
