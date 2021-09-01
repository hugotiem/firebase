import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/Constant.dart';
import 'package:pts/blocs/login/login_cubit.dart';
import 'package:pts/components/components_creation/tff_text.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  String _signInEmail;
  String _signInPassword;

  String _registerEmail;
  String _registerPassword;

  TabController _controller;

  int _currentIndex = 0;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.logged) {
              Navigator.of(context).pop();
            }
          },
          child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme:
                    Theme.of(context).iconTheme.copyWith(color: ICONCOLOR),
              ),
              body: SafeArea(
                // margin: EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    Container(
                      child: Icon(
                        Icons.house_rounded,
                        color: SECONDARY_COLOR,
                        size: 100,
                      ),
                    ),
                    Container(
                      child: TabBar(
                        indicatorColor: SECONDARY_COLOR,
                        unselectedLabelColor: SECONDARY_COLOR.withOpacity(.5),
                        labelColor: SECONDARY_COLOR,
                        unselectedLabelStyle: TextStyle(
                          fontSize: 20,
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
                        physics: BouncingScrollPhysics(),
                        controller: _controller,
                        children: [
                          _buildSignInContent(context),
                          _buildRegisterContent(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSignInContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 40),
            child: Text(
              "Connexion",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Form(
            child: Column(
              children: [
                TFFText(
                  hintText: 'Email',
                  onChanged: (value) {
                    this._signInEmail = value;
                  },
                  validator: (value) {
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TFFText(
                  obscureText: true,
                  hintText: 'Mot de passe',
                  onChanged: (value) {
                    this._signInPassword = value;
                  },
                  validator: (value) {
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () async {
              await BlocProvider.of<LoginCubit>(context)
                  .signIn(_signInEmail, _signInPassword);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: SECONDARY_COLOR,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Se connecter",
                  style: TextStyle(
                    color: ICONCOLOR,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () async {
              await BlocProvider.of<LoginCubit>(context).signInWithGoogle();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset(
                        "assets/images/google-logo.png",
                        height: 40,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Se connecter avec Google",
                      style: TextStyle(
                        color: SECONDARY_COLOR,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RichText(
            text: TextSpan(
              text: "Pas de compte ? ",
              style: TextStyle(color: SECONDARY_COLOR),
              children: [
                TextSpan(
                  text: "Clique ici",
                  style: TextStyle(
                    color: ICONCOLOR,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _controller.animateTo(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 40),
            child: Text(
              "Inscription",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Form(
            child: Column(
              children: [
                TFFText(
                  hintText: 'Email',
                  onChanged: (value) {
                    this._registerEmail = value;
                  },
                  validator: (value) {
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TFFText(
                  obscureText: true,
                  hintText: 'Mot de passe',
                  onChanged: (value) {
                    this._registerPassword = value;
                  },
                  validator: (value) {
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () async {
              await BlocProvider.of<LoginCubit>(context)
                  .register(_signInEmail, _signInPassword);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: SECONDARY_COLOR,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "S'inscrire",
                  style: TextStyle(
                    color: ICONCOLOR,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () async {
              await BlocProvider.of<LoginCubit>(context).signInWithGoogle();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset(
                        "assets/images/google-logo.png",
                        height: 40,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "S'inscrire avec Google",
                      style: TextStyle(
                        color: SECONDARY_COLOR,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
