import 'package:atm_project/persistence/scripts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/account_Model.dart';
import 'authentication.dart';

class CreateUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
      ),
      body: CreateUserForm(),
    );
  }
}

class CreateUserForm extends StatelessWidget {
  CreateUserForm({super.key});

  var account1 = Account(id: 1, name: 'Jéssica', pin: 1611, balance: 0.0);
  var account2 = Account(id: 2, name: 'Davi', pin: 1234, balance: 0.0);

  void _registerUser(BuildContext context) async {
    var account1 = Account(id: 1, name: 'Jéssica', pin: 1611, balance: 0.0);
    var account2 = Account(id: 2, name: 'Davi', pin: 1234, balance: 0.0);

    await DBHelper.insertUser(account1);
    await DBHelper.insertUser(account2);

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ATMScreen(account1: account1, account2: account2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _registerUser(context),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                backgroundColor: Colors.black,
                minimumSize: const Size(200, 60)),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
