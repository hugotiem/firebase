import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/const.dart';
import 'package:pts/models/payments/wallet.dart';
import 'package:pts/pages/login/id_form_screen.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:pts/pages/login/list_country.dart';
import 'package:pts/services/payment_service.dart';

class NationnalityForm extends StatelessWidget {
  final String? name;
  final String? surname;
  final String? email;
  final DateTime? birth;
  final String? id;
  NationnalityForm(
      {this.id, this.birth, this.surname, this.email, this.name, Key? key})
      : super(key: key);

  final TextEditingController nationnalityController = TextEditingController();
  final TextEditingController countryLivingController = TextEditingController();

  PaymentService paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(),
      child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
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
                      String? mangopayUserID =
                          await paymentService.createMangopayUser(
                        name!,
                        surname!,
                        email!,
                        birth!,
                        nationnalityController.text.split(" - ")[1],
                        countryLivingController.text.split(" - ")[1],
                        true,
                      );
                      if (mangopayUserID == null) return;
                      await paymentService.createMangopayWallet(
                          WalletType.MAIN, mangopayUserID);
                      await paymentService.createMangopayWallet(
                          WalletType.PENDING, mangopayUserID);
                      await BlocProvider.of<UserCubit>(context)
                          .updateUserInfoMangoPay(id,
                              mangoPayId: mangopayUserID)
                          .then(
                            (_) => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => IdFormScreen(token: id),
                              ),
                            ),
                          );
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
              HeaderText1(text: "Information supplémentaire"),
              HeaderText2(text: "Qu'elle est ta nationnalité ?"),
              SelectableTextField(
                hint: "nationnalité",
                countries: listOfCountry,
                textEditingController: nationnalityController,
                bottomSheetTitle: "Qu'elle est ta nationnalité ?",
              ),
              HeaderText2(text: "Qu'elle est ton pays de résidence ?"),
              SelectableTextField(
                hint: "Pays de résidence",
                countries: listOfCountry,
                textEditingController: countryLivingController,
                bottomSheetTitle: "Qu'elle est ton pays de résidence ?",
              ),
            ],
          ),
        );
      }),
    );
  }
}

class SelectableTextField extends StatefulWidget {
  TextEditingController textEditingController = TextEditingController();
  final String hint;
  final List<SelectedListItem>? countries;
  final Function(String)? selectedItem;
  final String? bottomSheetTitle;

  SelectableTextField(
      {this.countries,
      required this.hint,
      required this.textEditingController,
      this.selectedItem,
      this.bottomSheetTitle,
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
        searchHintText: "Recherche",
        bottomSheetTitle: widget.bottomSheetTitle ?? "",
        searchBackgroundColor: Colors.black12,
        dataList: widget.countries ?? [],
        selectedItem: (String selected) {
          widget.textEditingController.text = selected;
        },
        enableMultipleSelection: false,
        searchController: _searchTextEditingController,
      ),
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 22, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextFormField(
          readOnly: true,
          controller: widget.textEditingController,
          cursorColor: ICONCOLOR,
          onTap: () {
            FocusScope.of(context).unfocus();
            onTextFieldTap();
          },
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
            filled: true,
            hintText: widget.hint,
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
