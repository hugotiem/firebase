import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/const.dart';
import 'package:pts/pages/login/id_form_screen.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:pts/pages/login/list_country.dart';

class NationnalityForm extends StatelessWidget {
  NationnalityForm({Key? key}) : super(key: key);

  final TextEditingController nationnalityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: FORMBACKGROUNDCOLOR,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Wrap(
          children: <Widget>[
            Center(
              child: GestureDetector(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width - 100,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: ICONCOLOR,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Text(
                    "suivant".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () async {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => IdFormScreen()));
                  // await BlocProvider.of<UserCubit>(context)
                  //     .updateUserInfo(
                  //       id,
                  //       name: _name,
                  //       surname: _surname,
                  //       gender: _gender,
                  //       birthday: _date,
                  //     )
                  //     .then(
                  //       (_) => Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (context) => NationnalityForm()
                  //               // IdFormScreen(token: id),
                  //         ),
                  //       ),
                  //     );
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          HeaderText1(text: "Titre"),
          HeaderText2(text: "Qu'elle est ta nationnalité ?"),
          SelectableTextField(
            hint: "nationnalité",
            isCountrySelected: true,
            countries: listOfCountry,
            title: "title",
            textEditingController: nationnalityController,
          ),
          HeaderText2(text: "Qu'elle est ton pays de résidence ?"),
        ],
      ),
    );
  }
}

class SelectableTextField extends StatefulWidget {
  TextEditingController textEditingController = TextEditingController();
  final String title;
  final String hint;
  final bool isCountrySelected;
  final List<SelectedListItem>? countries;

  SelectableTextField(
      {this.countries,
      required this.hint,
      required this.isCountrySelected,
      required this.title,
      required this.textEditingController,
      Key? key})
      : super(key: key);

  @override
  State<SelectableTextField> createState() => _SelectableTextFieldState();
}

class _SelectableTextFieldState extends State<SelectableTextField> {
  final TextEditingController _searchTextEditingController =
      TextEditingController();
  void onTextFieldTap() {
    DropDownState(
      DropDown(
        submitButtonText: "kDone",
        submitButtonColor: const Color.fromRGBO(70, 76, 222, 1),
        searchHintText: "kSearch",
        bottomSheetTitle: "kCities",
        searchBackgroundColor: Colors.black12,
        dataList: widget.countries ?? [],
        selectedItems: (List<dynamic> selectedList) {
          showSnackBar(selectedList.toString());
        },
        selectedItem: (String selected) {
          showSnackBar(selected);
          widget.textEditingController.text = selected;
        },
        enableMultipleSelection: false,
        searchController: _searchTextEditingController,
      ),
    ).showModal(context);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        const SizedBox(
          height: 5.0,
        ),
        TextFormField(
          readOnly: true,
          controller: widget.textEditingController,
          cursorColor: Colors.black,
          onTap: widget.isCountrySelected
              ? () {
                  FocusScope.of(context).unfocus();
                  onTextFieldTap();
                }
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            contentPadding:
                const EdgeInsets.only(left: 8, bottom: 0, top: 0, right: 15),
            hintText: widget.hint,
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}
