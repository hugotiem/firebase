import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/Constant.dart';
import 'package:pts/View/Pages/login/register_form_screen.dart';
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
    _controller = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          _currentIndex = _controller.index;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.logged) {
            Navigator.of(context).pop();
          }
          if (state.status == LoginStatus.signedUp) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterFormScreen(),),);
          }
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                textTheme: Theme.of(context).textTheme,
                iconTheme:
                    Theme.of(context).iconTheme.copyWith(color: ICONCOLOR),
                title: _currentIndex == 0
                    ? Text("Connexion")
                    : Text("Inscription"),
              ),
              body: SafeArea(
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
                        controller: _controller,
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
          },
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context,
      {String textBtn,
      void Function(String) onEmailChanged,
      void Function(String) onPasswordChanged,
      void Function() onTapBtn,
      String textGoogleBtn,
      void Function() onTapGoogleBtn,
      RichText bottomText}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            child: Column(
              children: [
                SizedBox(height: 40),
                TFFText(
                  hintText: 'Email',
                  onChanged: onEmailChanged,
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
                  onChanged: onPasswordChanged,
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
            onTap: onTapBtn,
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
                  textBtn,
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Text("ou"),
                      color: Colors.white,
                    )
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTapGoogleBtn,
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
                      textGoogleBtn,
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
          bottomText
        ],
      ),
    );
  }

  Widget _buildSignInContent(BuildContext context) {
    return _buildFormContent(
      context,
      onEmailChanged: (value) {
        this._signInEmail = value;
      },
      onPasswordChanged: (value) {
        this._signInPassword = value;
      },
      textBtn: "Se connecter",
      onTapBtn: () async {
        await BlocProvider.of<LoginCubit>(context)
            .signIn(_signInEmail, _signInPassword);
      },
      textGoogleBtn: "Se connecter avec Google",
      onTapGoogleBtn: () async {
        await BlocProvider.of<LoginCubit>(context).signInWithGoogle();
      },
      bottomText: RichText(
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
    );
  }

  Widget _buildRegisterContent(BuildContext context) {
    return _buildFormContent(
      context,
      onEmailChanged: (value) {
        this._registerEmail = value;
      },
      onPasswordChanged: (value) {
        this._registerPassword = value;
      },
      textBtn: "S'inscrire",
      onTapBtn: () async {
        await BlocProvider.of<LoginCubit>(context)
            .register(_registerEmail, _registerPassword);
      },
      textGoogleBtn: "S'inscrire avec Google",
      onTapGoogleBtn: () async {
        await BlocProvider.of<LoginCubit>(context).signInWithGoogle();
      },
      bottomText: RichText(
        text: TextSpan(
            text: "Déjà un compte ? ",
            style: TextStyle(color: SECONDARY_COLOR),
            children: [
              TextSpan(
                text: "Clique ici",
                style: TextStyle(
                  color: ICONCOLOR,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _controller.animateTo(0),
              ),
            ]),
      ),
    );
  }
}
