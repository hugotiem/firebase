import 'package:flutter_credit_card_new/credit_card_widget.dart';
import 'package:pts/widgets/widgets_export.dart';

import '../../../components/party_card/party_export.dart';

class ExistingCard extends StatelessWidget {
  final User? user;
  const ExistingCard({this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardRegistrationCubit()..loadData(user?.mangoPayId),
      child: BlocBuilder<CardRegistrationCubit, CardRegistrationState>(
          builder: (context, state) {
        var cards = state.cards;
        return Scaffold(
          appBar: CustomAppBar(
              title: "Carte(s) enregistés(s)",
              onPressed: () => Navigator.pop(context)),
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR])),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(40))),
              child: Column(
                children: [
                  Builder(builder: (context) {
                    if (cards == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: cards.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        CreditCard card = cards[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          child: CreditCardWidget(
                              cardNumber: card.alias,
                              expiryDate: card.expirationDate,
                              cardHolderName: "Jean Sauvage",
                              cvvCode: "455",
                              showBackView: false,
                              isHolderNameVisible: true,
                              onCreditCardWidgetChange: (credit) {}),
                        );
                      },
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewCreditCard(user: user)));
                      },
                      child: ListTile(
                          title: Text('Ajouter une carte'),
                          leading: Icon(Ionicons.add_circle_outline)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Divider(
                      thickness: 1,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
