import 'package:atm_project/model/accountUpdate.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/account_Model.dart';
import '../model/transacoes.dart';

import '../persistence/scripts.dart';

class ExtratoScreen extends StatefulWidget {
  final Account? account1;

  ExtratoScreen({this.account1});

  @override
  _ExtratoScreenState createState() => _ExtratoScreenState();
}

class _ExtratoScreenState extends State<ExtratoScreen> {
  TextEditingController _valorController = TextEditingController();
  List<Transacoes> _transacoes = [];

  @override
  void initState() {
    super.initState();
    _getTransacoes();
  }

  void _getTransacoes() async {
    List<Transacoes> transacoes =
        await DBHelper.getTransactionsByAccount(widget.account1!.id);

    transacoes.sort(
      (a, b) => b.id!.compareTo(a.id!),
    );
    setState(() {
      _transacoes = transacoes;
    });
  }

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Histórico',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _transacoes.length,
                itemBuilder: (context, index) {
                  Transacoes transacoes = _transacoes[index];
                  return ListTile(
                    title: Text('Tipo: ${transacoes.type}'),
                    subtitle: Text('Valor: ${transacoes.balance}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
