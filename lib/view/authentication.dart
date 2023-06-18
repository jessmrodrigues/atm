import 'package:atm_project/persistence/scripts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/account_Model.dart';
import 'home_screen.dart';

class ATMScreen extends StatefulWidget {
  final Account? account1;
  final Account? account2;

  ATMScreen({this.account1, this.account2, super.key});

  @override
  _ATMScreenState createState() => _ATMScreenState();
}

class _ATMScreenState extends State<ATMScreen> {
  late Account account1;
  late Account account2;

  @override
  void initState() {
    super.initState();
    account1 = widget.account1!;
    account2 = widget.account2!;
  }

  void _login(BuildContext context) async {
    Database db = await DBHelper.database();

    List<Map<String, dynamic>> result = await db.query(
      'Account',
      where: 'pin = ?',
      whereArgs: [account1.pin],
    );

    if (result.isNotEmpty && account1.pin == int.parse(pin)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(account1: account1,)),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('PIN incorreto'),
            content: Text('O PIN inserido está incorreto. Tente novamente.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  String pin = '';

  void _addDigit(String digit) {
    setState(() {
      pin += digit;
    });
  }

  void _removeDigit() {
    setState(() {
      if (pin.isNotEmpty) {
        pin = pin.substring(0, pin.length - 1);
      }
    });
  }

  /*void _submitPin() {
    if (pin == '1234') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('PIN incorreto'),
            content: Text('O PIN inserido está incorreto. Tente novamente.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ATM'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Insira seu PIN:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              controller: TextEditingController(text: '*' * pin.length),
              enabled: false,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildDigitButton('1'),
                _buildDigitButton('2'),
                _buildDigitButton('3'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildDigitButton('4'),
                _buildDigitButton('5'),
                _buildDigitButton('6'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildDigitButton('7'),
                _buildDigitButton('8'),
                _buildDigitButton('9'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildActionButton('X', _removeDigit),
                _buildDigitButton('0'),
                _buildSubmitButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitButton(String digit) {
    return TextButton(
      child: Text(
        digit,
        style: TextStyle(fontSize: 24),
      ),
      onPressed: () {
        _addDigit(digit);
      },
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return TextButton(
      child: Text(
        label,
        style: TextStyle(fontSize: 24),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildSubmitButton() {
    return TextButton(
      child: Text('OK'),
      onPressed: () => _login(context),
    );
  }
}
