import 'package:pts/blocs/application/application_cubit.dart';
import 'package:pts/blocs/messaging/messaging_cubit.dart';
import 'package:pts/components/party_card/party_export.dart';
import 'package:pts/services/auth_service.dart';
import 'package:pts/widgets/widgets_export.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (BlocProvider.of<ApplicationCubit>(context).state.user == null) {
      return Connect();
    }

    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: CustomAppBar(
        title: "Messages",
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR])),
        child: ListMessage(),
      ),
    );
  }
}

class ListMessage extends StatefulWidget {
  const ListMessage({Key? key}) : super(key: key);

  @override
  _ListMessageState createState() => _ListMessageState();
}

class _ListMessageState extends State<ListMessage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  dynamic _docs;
  late String? currentUserId;
  late String? currentUserName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      child: Builder(builder: (context) {
        var user = BlocProvider.of<ApplicationCubit>(context).state.user;

        currentUserId = user?.id;
        currentUserName = user?.name;

        return BlocProvider(
          create: (context) =>
              MessagingCubit()..fetchMessageList(currentUserId),
          child: BlocBuilder<MessagingCubit, MessagingState>(
            builder: (context, state) {
              var chats = state.chats;
              if (chats == null)
                return const Center(
                  child: CircularProgressIndicator(),
                );
              if (chats.isEmpty) return EmptyList();
              //List listUser = chats.;
              return Container(
                margin: const EdgeInsets.only(bottom: 40, top: 10),
                child: Column(
                  children: chats.map(
                    (chat) {
                      return InkWell(
                        onTap: () => openChat(chat.recipient.id, chat.recipient.name, chat.recipient.messagingToken),
                        child: UserLineDesign(
                            userID: chat.recipient.id, userName: chat.recipient.name),
                      );
                    },
                  ).toList(),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // Stream<DocumentSnapshot> getmessageStreamSnapshot(
  //     BuildContext context) async* {
  //   yield* FirebaseFirestore.instance
  //       .collection('chat')
  //       .doc(currentUserId)
  //       .snapshots();
  // }

  void openChat(String? userID, String? userName, String? messagingToken) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          userID!,
          otherUserName: userName,
          otherUserMessagingToken: messagingToken,
        ),
      ),
    );
  }
}

class UserLineDesign extends StatelessWidget {
  final String? userID, userName;

  const UserLineDesign({this.userID, this.userName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage("assets/roundBlankProfilPicture.png"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  this.userName != null
                      ? Container(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            this.userName!,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      : Text(''),
                  GetLastMessage(this.userID)
                ],
              ),
            ),
          ),
          GetTimeLastMessage(this.userID)
        ],
      ),
    );
  }
}

class EmptyList extends StatelessWidget {
  const EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 26, right: 18, left: 18),
      child: Container(
        child: Opacity(
          opacity: 0.85,
          child: Text(
            "Pas de message pour l'instant. Rejoingnez ou créez une soirée pour contacter quelqu'un.",
            style: TextStyle(color: SECONDARY_COLOR),
          ),
        ),
      ),
    );
  }
}

class GetLastMessage extends StatelessWidget {
  final String? otherUserID;
  const GetLastMessage(this.otherUserID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference chatService =
        FirebaseFirestore.instance.collection('chat');
    String currentUserID = AuthService().currentUser!.uid;
    List<dynamic> _docs;

    return FutureBuilder<QuerySnapshot>(
      future: chatService
          .doc(currentUserID)
          .collection(otherUserID!)
          .orderBy('date')
          .limitToLast(1)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text('');
        _docs = snapshot.data!.docs;
        return Row(
          children: _docs.map((doc) {
            return Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Opacity(
                  opacity: 0.64,
                  child: Text(
                    detect(doc['text']) ? 'Image' : doc['text'],
                    overflow: TextOverflow.ellipsis,
                  ),
                ));
          }).toList(),
        );
      },
    );
  }
}

class GetTimeLastMessage extends StatelessWidget {
  final String? otherUserID;
  const GetTimeLastMessage(this.otherUserID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference chatService =
        FirebaseFirestore.instance.collection('chat');
    String currentUserID = AuthService().currentUser!.uid;
    List<dynamic> _docs;

    return FutureBuilder<QuerySnapshot>(
      future: chatService
          .doc(currentUserID)
          .collection(otherUserID!)
          .orderBy('date')
          .limitToLast(1)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text('');
        _docs = snapshot.data!.docs;
        return Row(
          children: _docs.map((doc) {
            return Container(
              child: Opacity(
                opacity: 0.64,
                child: Text(
                  timeConverter(doc['date']),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String timeConverter(String time) {
    Duration dif;
    DateTime parsedDate;
    dynamic times, min, h, temps;
    double j, sem, mois, ans;

    times = time.toString().split(" - ").join(" ");
    parsedDate = DateTime.parse(times);

    dif = DateTime.now().difference(parsedDate);

    min = int.parse(dif.toString().split(":")[1]);
    h = int.parse(dif.toString().split(':')[0]);
    j = h / 24;
    sem = j / 7;
    mois = sem / 4;
    ans = mois / 12;

    if (mois >= 12) {
      temps = "${ans.round()} ans";
    } else if (sem >= 4) {
      temps = "${mois.round()} mois";
    } else if (j >= 7) {
      temps = "${sem.round()} sem";
    } else if (h > 24) {
      temps = "${j.round()} j";
    } else if (h >= 01) {
      temps = "$h h";
    } else if (min < 60) {
      temps = "$min min";
    }

    return temps;
  }
}
