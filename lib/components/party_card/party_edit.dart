import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/const.dart';
import 'package:pts/models/party.dart';

class EditParty extends StatefulWidget {
  final Party party;
  const EditParty(this.party, {Key? key}) : super(key: key);

  @override
  State<EditParty> createState() => _EditPartyState();
}

class _EditPartyState extends State<EditParty> {
  String? _name;
  String? _theme;
  String? _number;
  AnimalState? _animal;
  SmokeState? _smoke;
  String? _desc;

  TextEditingController? _nameController;
  TextEditingController? _numberController;
  TextEditingController? _descController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.party.name)
      ..addListener(() {
        _name = _nameController!.text;
      });
    _numberController =
        TextEditingController(text: widget.party.number.toString())
          ..addListener(() {
            _number = _numberController!.text;
          });
    _descController = TextEditingController(text: widget.party.desc)
      ..addListener(() {
        _desc = _descController!.text;
      });

    _animal == null ? _animal = widget.party.animals : _animal = _animal;
    _name == null ? _name = widget.party.name : _name = _name;
    _number == null
        ? _number = widget.party.number.toString()
        : _number = _number;
    _theme == null ? _theme = widget.party.theme : _theme = _theme;
    _smoke == null ? _smoke = widget.party.smoke : _smoke = _smoke;
    _desc == null ? _desc = widget.party.desc : _desc = _desc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PartiesCubit(),
      child: BlocBuilder<PartiesCubit, PartiesState>(builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: BackAppBar(actions: [
              TextButton(
                onPressed: () async {
                  BlocProvider.of<PartiesCubit>(context)
                      .saveData(widget.party.id!, {
                    "name": _name,
                    "theme": _theme,
                    "number": _number,
                    "animals": _animal,
                    "smoke": _smoke,
                    "desc": _desc
                  });
                  int countComment = 0;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: CText("Modifié"),
                          content: CText("Tu as bien modifié t'as soirée"),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.popUntil(context, (route) {
                                return countComment++ == 3;
                              }),
                              child: CText("OK"),
                            )
                          ],
                        );
                      });
                },
                child: CText("Sauvegarder"),
              )
            ]),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText1(text: "Modifie ta soirée"),
                  ttf("Nom", _nameController),
                  dropdownTheme("Thème", widget.party.theme),
                  ttf("Nombre d'invité", _numberController),
                  dropdownAnimals("Animaux", widget.party.animals),
                  dropdownSmoke("Fumé", widget.party.smoke),
                  ttf('Description', _descController, maxLength: true)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget ttf(String text, TextEditingController? controller,
      {bool? maxLength = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Stack(
        children: [
          hintText1(text),
          Padding(
            padding:
                EdgeInsets.only(top: controller!.text.length > 60 ? 12 : 0),
            child: TextFormField(
              maxLines: 100,
              minLines: 1,
              maxLength: maxLength == true ? 500 : null,
              textAlignVertical: TextAlignVertical.bottom,
              controller: controller,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: SECONDARY_COLOR),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropdownTheme(String text, String? theme) {
    return Stack(
      children: [
        hintText1(text),
        Padding(
          padding: const EdgeInsets.only(bottom: 22, top: 2),
          child: DropdownButtonFormField<String>(
            value: _theme,
            items: [
              'Festive',
              'Gaming',
              'Jeux de société',
              "Thème",
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: CText(
                  value,
                  fontSize: 16,
                ),
              );
            }).toList(),
            hint: Text(
              theme!,
            ),
            elevation: 0,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 15),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                _theme = value;
              });
            },
            alignment: Alignment.bottomLeft,
          ),
        ),
      ],
    );
  }

  Widget dropdownAnimals(String text, AnimalState? animal) {
    String? val;
    return Stack(
      children: [
        hintText1(text),
        Padding(
          padding: const EdgeInsets.only(bottom: 22, top: 2),
          child: DropdownButtonFormField<String>(
            value: val,
            items: [
              'Oui',
              'Non',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: CText(
                  value,
                  fontSize: 16,
                ),
              );
            }).toList(),
            hint: Text(
              animal == AnimalState.allowed ? "Oui" : "Non",
            ),
            elevation: 0,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 15),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                val = value;
                val == "Oui"
                    ? _animal = AnimalState.allowed
                    : _animal = AnimalState.notAllowed;
              });
            },
            alignment: Alignment.bottomLeft,
          ),
        ),
      ],
    );
  }

  Widget dropdownSmoke(String text, SmokeState? smoke) {
    String? val;
    return Stack(
      children: [
        hintText1(text),
        Padding(
          padding: const EdgeInsets.only(bottom: 22, top: 2),
          child: DropdownButtonFormField<String>(
            value: val,
            items: [
              'Oui',
              'Non',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: CText(
                  value,
                  fontSize: 16,
                ),
              );
            }).toList(),
            hint: Text(
              Party.getTitleByState(smoke!),
            ),
            elevation: 0,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 15),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                val = value;
                // val == "Oui" ?  = true : _smoke = false;
              });
            },
            alignment: Alignment.bottomLeft,
          ),
        ),
      ],
    );
  }

  Widget hintText1(String text) {
    return Opacity(opacity: 0.65, child: CText(text));
  }
}
