import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/blocs/card_registration/card_registration_cubit.dart';
import 'package:pts/blocs/transactions/transactions_cubit.dart';
import 'package:pts/components/showModalBottomSheet.dart';
import 'package:pts/const.dart';
import 'package:pts/models/payments/credit_card.dart';
import 'package:pts/models/payments/transaction.dart';
import 'package:pts/models/payments/wallet.dart';
import 'package:pts/models/user.dart';
import 'package:pts/pages/profil/subpage/new_credit_card_page.dart';
import 'package:pts/services/payment_service.dart';

class WalletPage extends StatelessWidget {
  final User? user;
  WalletPage(this.user, {Key? key}) : super(key: key);

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
      body: BlocProvider(
        create: (context) =>
            TransactionsCubit()..loadData(user?.mangoPayId ?? ""),
        child: BlocBuilder<TransactionsCubit, TransactionsState>(
            builder: (context, state) {
          var wallet = state.wallet;
          var transactions = state.transactions;
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR]),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Builder(builder: (context) {
                                        String text;
                                        if (wallet == null) {
                                          text = "-,--";
                                        } else {
                                          text = wallet.amount
                                              .toStringAsFixed(2)
                                              .replaceFirst(".", ",");
                                        }
                                        return Text(
                                          "$text €",
                                          style: TextStyle(
                                            color: SECONDARY_COLOR,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 50,
                                          ),
                                        );
                                      }),
                                    ),
                                    BlocProvider(
                                      create: (context) =>
                                          CardRegistrationCubit()
                                            ..loadData(user!.mangoPayId),
                                      child: BlocBuilder<CardRegistrationCubit,
                                              CardRegistrationState>(
                                          builder: (context, cardState) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TransactionBox(text: "Retirer", image: "assets/retiré.png",),
                                            TransactionBox(
                                              text: "Ajouter",
                                              image: "assets/ajouté.png",
                                              onTap: () async {
                                                joinparty(
                                                    cardState.cards!, user!);
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
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "historique des transactions".toUpperCase(),
                              style: TextStyle(
                                color: SECONDARY_COLOR,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              if (transactions == null) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: ICONCOLOR,
                                  ),
                                );
                              }
                              if (transactions.isEmpty) {
                                return Center(
                                  child:
                                      Text("Aucune transaction pour le moment"),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  var transaction = transactions[index];
                                  if (transaction.type ==
                                      TransactionType.PAYIN) {
                                    if (transaction.recipientId ==
                                        transaction.authorId) {
                                      // Lorsqu'on recharge notre compte

                                      // return TextPaymentReceived(
                                      //   amount: transaction.amount ?? 0,
                                      //   recipient: user?.name ?? "",
                                      //   date:
                                      //       transaction.date ?? DateTime.now(),
                                      // );
                                    }
                                  }
                                  if (transaction.type ==
                                      TransactionType.TRANSFER) {
                                    if (transaction.recipientId ==
                                        transaction.authorId) {
                                      return TextPaymentReceived(
                                          recipient: transaction.tag ?? "",
                                          amount: transaction.amount ?? 0,
                                          date: transaction.date ??
                                              DateTime.now());
                                    }
                                    return TextPaymentDone();
                                  }
                                  return Container();
                                },
                              );

                              // Column(
                              //   children: [
                              //     TextPaymentReceived(),
                              //     TextPaymentDone(),
                              //   ],
                              // );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

class TextPaymentReceived extends StatelessWidget {
  final String recipient;
  final int amount;
  final DateTime date;
  const TextPaymentReceived(
      {Key? key,
      required this.recipient,
      required this.amount,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(Ionicons.person_outline, color: ICONCOLOR),
            Icon(Ionicons.arrow_back_outline, color: ICONCOLOR),
            BoldText1("${(amount * 0.01).toString().replaceFirst(".", ",")}€",
                secondaryColor: false),
            SmallText1("reçu de", secondaryColor: false),
            BoldText1(recipient.toUpperCase(), secondaryColor: false),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: SmallText1("le ${DateFormat.yMd('fr').format(date)}",
                  secondaryColor: false),
            ),
          ],
        ),
      ),
    );
  }
}

class TextPaymentDone extends StatelessWidget {
  const TextPaymentDone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(Ionicons.person_outline, color: SECONDARY_COLOR),
            Icon(Ionicons.arrow_forward_outline, color: SECONDARY_COLOR),
            BoldText1("6.85€"),
            SmallText1("reçu de"),
            BoldText1("ANTHONY"),
            FittedBox(child: SmallText1("le 26.04.2022")),
          ],
        ),
      ),
    );
  }
}

class BoldText1 extends StatelessWidget {
  final String text;
  final bool secondaryColor;
  const BoldText1(this.text, {this.secondaryColor = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: secondaryColor ? SECONDARY_COLOR : ICONCOLOR,
          fontSize: 24,
          fontWeight: FontWeight.w700),
    );
  }
}

class SmallText1 extends StatelessWidget {
  final String text;
  final bool secondaryColor;
  const SmallText1(this.text, {this.secondaryColor = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: TextStyle(
            color: secondaryColor ? SECONDARY_COLOR : ICONCOLOR,
            fontWeight: FontWeight.w400,
            fontSize: 16),
      ),
    );
  }
}

class TransactionBox extends StatelessWidget {
  final String? text;
  final void Function()? onTap;
  final String? image;
  const TransactionBox({this.text, this.onTap, this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 22, right: 22),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
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
              child: Image(image: AssetImage(image!)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text ?? "",
                style: TextStyle(
                    color: SECONDARY_COLOR, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
