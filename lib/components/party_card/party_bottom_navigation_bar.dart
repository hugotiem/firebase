import 'package:pts/components/party_card/party_export.dart';

class CardBNB extends StatelessWidget {
  final String? prix;
  final Widget? onTap;

  const CardBNB({this.prix, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: PRIMARY_COLOR, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 10),
        )
      ]),
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Center(
                    child: CText(
                      this.prix,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Icon(Icons.euro_outlined, size: 20)
                ],
              ),
            ),
            onTap!,
          ],
        ),
      ),
    );
  }
}
