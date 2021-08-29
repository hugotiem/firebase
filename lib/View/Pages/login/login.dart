import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/components/components_creation/tff_text.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 120,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: Theme.of(context).iconTheme.copyWith(color: ICONCOLOR),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Container(
                child: Placeholder(
                  fallbackHeight: 150,
                ),
              ),
              Container(
                child: TabBar(
                  indicatorColor: SECONDARY_COLOR,
                  unselectedLabelColor: SECONDARY_COLOR.withOpacity(.5),
                  labelColor: SECONDARY_COLOR,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Se connecter",
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "S'inscrire",
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildSignInContent(context),
                    _buildRegisterContent(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInContent(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text("Connexion"),
        ),
        Form(
            child: Column(
          children: [
            TFFText(
              hintText: '',
              onChanged: (value) {},
              validator: (value) {
                return null;
              },
            ),
            TFFText(
              hintText: '',
              onChanged: (value) {},
              validator: (value) {
                return null;
              },
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildRegisterContent(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text("Inscription"),
        ),
        Form(
            child: Column(
          children: [
            TFFText(
              hintText: '',
              onChanged: (value) {},
              validator: (value) {
                return null;
              },
            ),
            TFFText(
              hintText: '',
              onChanged: (value) {},
              validator: (value) {
                return null;
              },
            ),
          ],
        )),
      ],
    );
  }
}
