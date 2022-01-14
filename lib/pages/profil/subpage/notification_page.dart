import 'package:flutter/material.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/const.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool mainNotification = true;
  bool partyNotification = true;
  bool askNotification = true;
  bool messagesNotification = true;

  @override
  Widget build(BuildContext context) {
    if (mainNotification == false) {
      partyNotification = false;
      askNotification = false;
      messagesNotification = false;
    }

    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          title: TitleAppBar('Réglages des notifications'),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 22),
          customCheckBox("Activer les notifications", mainNotification,
              (value) {
            setState(() {
              mainNotification = value!;
            });
          }),
          customCheckBox("Soirée", partyNotification, (value) {
            setState(() {
              partyNotification = value!;
              if (mainNotification == false && partyNotification == true) {
                mainNotification = true;
              }
            });
          },
              hintText:
                  "Recevez une notification lorsque vous êtes accepté ou refusé dans une soirée."),
          customCheckBox("Demande", askNotification, (value) {
            setState(() {
              askNotification = value!;
              if (mainNotification == false && askNotification == true) {
                mainNotification = true;
              }
            });
          },
              hintText:
                  "Recevez une notification lorsque quelqu'un souhaite rejoindre votre soirée"),
          customCheckBox(
            "Messages",
            messagesNotification,
            (value) {
              setState(() {
                messagesNotification = value!;
                if (mainNotification == false && messagesNotification == true) {
                  mainNotification = true;
                }
              });
            },
            hintText:
                "Recevez une notification lorsque vous recevez un message.",
            separator: false,
          ),
        ],
      ),
    );
  }

  Color? getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return SECONDARY_COLOR;
  }

  Widget customCheckBox(
      String headerText, bool? value, void Function(bool?)? onChanged,
      {String? hintText, bool separator = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CText(headerText, fontSize: 16),
                  ),
                  hintText == null
                      ? SizedBox()
                      : Opacity(
                          opacity: 0.7,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: CText(hintText),
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: Checkbox(
                  value: value,
                  onChanged: onChanged,
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  side: BorderSide(width: 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )
            ],
          ),
          separator == true
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 2, color: FOCUS_COLOR),
                      ),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

// class NotificationPage extends StatelessWidget {
//   const NotificationPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: (Center(
//         child: TextButton(
//           onPressed: () => Timer(
//             const Duration(seconds: 10),
//             () => NotificationService.showNotification(
//                 body: 'Vous avez été accepté à la soirée du roi.',
//                 title: 'PTS',
//                 payload: 'test'),
//           ),
//           child: Text('Notification'),
//         ),
//       )),
//     );
//   }
// }
