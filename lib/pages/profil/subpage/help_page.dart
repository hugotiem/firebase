import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/const.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(title: TitleAppBar("Aide")),
      ),
      body: BlocProvider(
          create: (context) => UserCubit()..init(),
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              String? id = state.token;
              return Column(
                children: [
                  SizedBox(height: 22),
                  onTapBox(
                    context,
                    "Signaler un problème",
                    to: ProblemMail(id),
                    separator: false,
                  ),
                ],
              );
            },
          )),
    );
  }

  Widget onTapBox(BuildContext context, String headerText,
      {bool separator = true, Widget? to}) {
    return InkWell(
      onTap: () => to == null
          ? null
          : Navigator.push(
              context, MaterialPageRoute(builder: (context) => to)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CText(headerText, fontSize: 16),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16,
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
      ),
    );
  }
}

class ProblemMail extends StatefulWidget {
  final String? id;
  const ProblemMail(this.id, {Key? key}) : super(key: key);

  @override
  State<ProblemMail> createState() => _ProblemMailState();
}

class _ProblemMailState extends State<ProblemMail> {
  String? _content;

  TextEditingController? _controller;

  @override
  void initState() {
    _controller = TextEditingController()
      ..addListener(() {
        _content = _controller!.text;
      });
    super.initState();
  }

  Future<void> sendEmail() async {
    final Email email = Email(
      subject: "Problème",
      body: _content!,
      recipients: ["problemepts@gmail.com"],
      isHTML: false,
    );


    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Scaffold(
      backgroundColor: FORMBACKGROUNDCOLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(title: TitleAppBar("Signaler un problème")),
      ),
      body: Column(
        children: [
          SizedBox(height: 22),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _controller,
                  style: TextStyle(
                    fontSize: TEXTFIELDFONTSIZE,
                  ),
                  maxLines: 100,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Expliquez brièvement ce qui ne fonctionne pas.',
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: 1),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 22),
          TextButton(
            onPressed: sendEmail,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: SECONDARY_COLOR,
                ),
                child: Center(
                  child: Text(
                    'Envoyer',
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 18,
                    ),
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
