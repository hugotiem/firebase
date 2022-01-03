import 'package:flutter/material.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/title_appbar.dart';
import 'package:pts/const.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          title: TitleAppBar('Notification'),
        ),
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
