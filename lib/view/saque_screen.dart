import 'package:atm_project/model/accountUpdate.dart';
import 'package:flutter/material.dart';

import '../model/account_Model.dart';
import '../model/transacoes.dart';
import '../persistence/scripts.dart';

class SaqueScreen extends StatefulWidget {
  final Account? account1;

  SaqueScreen({this.account1});

  @override
  _SaqueScreenState createState() => _SaqueScreenState();
}

class _SaqueScreenState extends State<SaqueScreen> {
  TextEditingController _valorController = TextEditingController();

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  void _updateBalance(BuildContext context) async {
    String balance = _valorController.text;
    double? balanceParsed = double.tryParse(balance);

    if (balanceParsed == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Valor inválido'),
            content: const Text('O valor de saque informado não é válido.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    if (balanceParsed > widget.account1!.balance) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Saldo insuficiente'),
            content: const Text(
                'Você não possui saldo suficiente para realizar esse saque.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (double.parse(balance) <= widget.account1!.balance) {
      setState(() {
        widget.account1!.balance -= double.parse(balance);
      });
      var account = AccountUpdate(
          id: widget.account1?.id,
          pin: widget.account1?.pin,
          balance: double.parse(balance));

      var transacoes = Transacoes(
        accountId: widget.account1!.id,
        type: TypeTransaction.SAQUE.descricao,
        balance: double.parse(balance),
      );

      await DBHelper.updateAccount(account);
      await DBHelper.inserirTransacoes(transacoes);

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Saque realizado'),
          content: const Text('O saque foi realizado com sucesso!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saque'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Informe o valor do Saque:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor do Saque',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.black),
                  child: const Text('Confirmar'),
                  onPressed: () => _updateBalance(context),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.black),
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
