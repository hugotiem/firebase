import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/blocs/bank_account/bank_account_cubit.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/models/user.dart';
import 'package:pts/pages/profil/subpage/new_bank_account.dart';

class UserBank extends StatelessWidget {
  final User? user;

  const UserBank({this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankAccountCubit()..loadData(user?.mangoPayId),
      child: BlocBuilder<BankAccountCubit, BankAccountState>(
          builder: (context, state) {
        var bankAccount = state.bankAccounts;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: BackAppBar(
              title: TitleAppBar('Compte en banque'),
            ),
          ),
          body: Column(
            children: [
              Builder(builder: (context) {
                if (bankAccount == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: bankAccount.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var bankAccounts = bankAccount[index];
                    return Container(
                      child: Text(bankAccounts.toString()),
                    );
                  },
                );
              }),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewBankAccount()));
                  },
                  child: ListTile(
                      title: Text('Ajouter une carte'),
                      leading: Icon(Ionicons.add_circle_outline)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  thickness: 1,
                  height: 0,
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
