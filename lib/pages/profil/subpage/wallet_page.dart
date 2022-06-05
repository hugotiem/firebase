import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/blocs/card_registration/card_registration_cubit.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/showModalBottomSheet.dart';
import 'package:pts/const.dart';
import 'package:pts/models/payments/credit_card.dart';
import 'package:pts/models/payments/wallet.dart';
import 'package:pts/models/user.dart';
import 'package:pts/pages/profil/subpage/new_credit_card_page.dart';
import 'package:pts/services/payment_service.dart';

class WalletPage extends StatelessWidget {
  final Wallet? wallet;
  final User? user;
  WalletPage(this.wallet, this.user, {Key? key}) : super(key: key);

  final PaymentService _paymentService = PaymentService();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<dynamic> joinparty(
        List<CreditCard> listCreditcard, User connectUser) {
      String selectedId = "";
      return customShowModalBottomSheet(
        context,
        children: [
          titleText("Sélectionne ton moyen de paiement"),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4, left: 2),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    NewCreditCard(user: connectUser)));
                          },
                          child: Container(
                            height: 70,
                            width: 110,
                            decoration: BoxDecoration(
                              color: PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(Ionicons.add_circle_outline,
                                size: 45),
                          ),
                        ),
                      ),
                      const Text("+ ajouter")
                    ],
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: listCreditcard.length,
                      itemBuilder: (context, index) {
                        var card = listCreditcard[index];
                        bool _selected = card.id == selectedId;
                        return Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedId = card.id;
                                    });
                                  },
                                  child: Badge(
                                    badgeContent: _selected
                                        ? Icon(
                                            Ionicons.checkmark_outline,
                                            color: PRIMARY_COLOR,
                                            size: 15,
                                          )
                                        : null,
                                    position: BadgePosition.bottomEnd(),
                                    badgeColor: _selected
                                        ? Colors.green
                                        : PRIMARY_COLOR,
                                    elevation: 0,
                                    child: Container(
                                      height: 70,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: PRIMARY_COLOR,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _selected
                                                ? Colors.green
                                                : PRIMARY_COLOR,
                                            width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 3,
                                            spreadRadius: 0,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                      ),
                                      child: Center(
                                          child: Text(card.cardProvider)),
                                    ),
                                  ),
                                ),
                              ),
                              Text(card.alias.substring(8).replaceAll("X", "*"))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 22),
                ],
              ),
            );
          }),
          TextField(
            controller: _controller,
            style: TextStyle(
              color: SECONDARY_COLOR,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 22),
            child: GestureDetector(
              onTap: () async {
                double prix = double.parse(_controller.text);
                int prix1 = (prix * 100).toInt();
                await _paymentService.cardDirectPayin(
                    connectUser.mangoPayId!, prix1, selectedId);
                // await _paymentService.transfer(
                //   connectUser.id!,
                //   "CREDIT_EUR",
                //   (prix * 100).toInt(),
                // );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.99,
                height: 40,
                decoration: BoxDecoration(
                  color: SECONDARY_COLOR,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "Valider",
                        style: TextStyle(
                          color: PRIMARY_COLOR,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(Ionicons.lock_closed_outline,
                            color: PRIMARY_COLOR),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR]),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: height * 0.05,
                left: width * 0.05,
              ),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Image(
                  image: AssetImage("assets/RETOUR.png"),
                  alignment: Alignment.topLeft,
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              clipBehavior: Clip.antiAlias,
              height: height * 0.88,
              width: width,
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 40),
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                                color: PRIMARY_COLOR,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 18),
                                  child: const Text(
                                    "TON SOLDE ACTUEL",
                                    style: TextStyle(
                                      color: SECONDARY_COLOR,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    "${wallet!.amount.toString().replaceFirst(".", ",")}€",
                                    style: TextStyle(
                                      color: SECONDARY_COLOR,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 40,
                                    ),
                                  ),
                                ),
                                BlocProvider(
                                  create: (context) => CardRegistrationCubit()
                                    ..loadData(user!.mangoPayId),
                                  child: BlocBuilder<CardRegistrationCubit,
                                          CardRegistrationState>(
                                      builder: (context, cardState) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TransactionBox(text: "Retirer"),
                                        TransactionBox(
                                          text: "Ajouter",
                                          onTap: () async {
                                            joinparty(cardState.cards!, user!);
                                          },
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text(
                          "historique des transactions".toUpperCase(),
                          style: TextStyle(
                            color: SECONDARY_COLOR,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TransactionBox extends StatelessWidget {
  final String? text;
  final void Function()? onTap;
  const TransactionBox({this.text, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 22, right: 22),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              // child: Icon,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text ?? "",
                style: TextStyle(
                    color: SECONDARY_COLOR, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
