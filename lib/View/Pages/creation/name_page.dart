import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/Constant.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/components_creation/fab_form.dart';
import 'package:pts/components/components_creation/headertext_one.dart';
import 'package:pts/components/components_creation/tff_text.dart';
import 'package:pts/Model/capitalize.dart';

class NamePage extends StatefulWidget {
  final void Function() onNext;

  const NamePage({Key key, this.onNext}) : super(key: key);
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  String _name;
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
              Icons.close,
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
          if (!_formKey.currentState.validate()) {
            return;
          }
          BlocProvider.of<BuildPartiesCubit>(context).addItem("name", _name.trimRight().trimLeft().inCaps);
          widget.onNext();
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
                text: "Comment s'appelera-t'elle ?",
              ),
              TFFText(
                onChanged: (value) {
                  _name = value;
                },
                hintText: 'ex : La fête du roi',
                validator: (value) {
                  if (value.isEmpty) {
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
