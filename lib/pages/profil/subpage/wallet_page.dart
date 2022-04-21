import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
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
  WalletPage({Key? key}) : super(key: key);

  final PaymentService _paymentService = PaymentService();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<dynamic> joinparty(
        List<CreditCard> listCreditcard, User connectUser) {
      String selectedId = "";
      return customShowModalBottomSheet(
        context,
        [
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

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: BackAppBar(
            title: TitleAppBar("Portefeuille"),
          ),
        ),
        body: BlocProvider(
          create: (context) => UserCubit()..init(),
          child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
            User? user = state.user;
            Wallet? wallet = state.wallet;
            if (user == null && wallet == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return BlocProvider(
              create: (context) =>
                  CardRegistrationCubit()..loadData(user!.mangoPayId),
              child: BlocBuilder<CardRegistrationCubit, CardRegistrationState>(
                  builder: (context, cardState) {
                return Column(children: [
                  Text(wallet!.amount.toString()),
                  TextButton(
                    onPressed: () async {
                      joinparty(cardState.cards!, user!);
                      // var cards = await _paymentService
                      //     .getUserCreditCards(user!.mangoPayId ?? "");

                      // if (cards == null) return;

                      // await _paymentService.cardDirectPayin(
                      //     user.mangoPayId ?? "", 200, cards[0].id);
                    },
                    child: Text("ajouter"),
                  )
                ]);
              }),
            );
          }),
        ));
  }
}
