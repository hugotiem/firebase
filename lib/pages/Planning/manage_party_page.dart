import 'package:pts/components/party_card/party_export.dart';
import 'package:pts/pages/Planning/subpage/list_user_party_page.dart';
import 'package:pts/pages/Planning/subpage/waitlist_guest_page.dart';
import 'package:pts/pages/Planning/subpage/waitlist_party_page.dart';
import 'package:pts/widgets/widgets_export.dart';

class ManagePartyOPage extends StatelessWidget {
  const ManagePartyOPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Soirées",
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR])),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              BoxContainer(text: "Mes soirées", to: MyParty()),
              BoxContainer(
                  text: "Mes demandes pour rejoindre des soirées",
                  to: PartyWaitList()),
              BoxContainer(
                  text: "Les demandes pour rejoindre ma soirée",
                  to: GuestWaitList())
            ],
          ),
        ),
      ),
    );
  }
}

class BoxContainer extends StatelessWidget {
  final String text;
  final Widget to;
  const BoxContainer({required this.text, required this.to, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => to)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 17, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 6,
                spreadRadius: 0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
