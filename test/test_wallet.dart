import 'package:binander/api/api.dart';

class TestWallet {
  List<AccountBalance> balances;

  TestWallet(this.balances);

  AccountBalance findBalanceByAsset(String asset) {
    return balances.firstWhere((b) => b.asset == asset);
  }
}
