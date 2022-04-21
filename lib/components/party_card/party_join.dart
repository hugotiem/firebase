import 'package:pts/components/party_card/party_export.dart';

class JoinParty extends StatelessWidget {
  const JoinParty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SECONDARY_COLOR,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        backgroundColor: ICONCOLOR,
        elevation: 0,
        label: Text(
          'OK',
          style: TextStyle(fontSize: 15),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          Center(
            child: Container(
              height: double.infinity,
              child: Lottie.network(
                  "https://assets8.lottiefiles.com/packages/lf20_pkanqwys.json",
                  fit: BoxFit.cover),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "Vous venez de rejoindre la liste d'attente de la soirée !",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
