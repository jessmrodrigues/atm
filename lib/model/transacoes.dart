class Transacoes {
  int? id;
  int accountId;
  String type;
  double balance;

  Transacoes(
      {this.id,
      required this.accountId,
      required this.type,
      required this.balance});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountId': accountId,
      'type': type,
      'balance': balance,
    };
  }
}

enum TypeTransaction {
  DEPOSITO,
  TRANSFERENCIA,
  SAQUE,
}

extension TipoTransacaoExtension on TypeTransaction {
  String get descricao {
    switch (this) {
      case TypeTransaction.DEPOSITO:
        return 'Depósito';
      case TypeTransaction.TRANSFERENCIA:
        return 'Transferência';
      case TypeTransaction.SAQUE:
        return 'Saque';
    }
  }
}
