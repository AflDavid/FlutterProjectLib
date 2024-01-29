import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
//google sheets api
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "flutter-412712",
  "private_key_id": "8b526c068849eedb08db4a5b94e79379af871372",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCm02cyqzMN5GIT\nzYhxyTClyavcfplLKlzrjm5AvvbtcFguUBH2K5x/Hzr+BbQl9l5Sz9XFtWnUTcEK\n9VhZ45oqvCk3vNZpa/oStYdvhrNQUf3+cRZHp5xvcrf2hFVWOGWCIxny3SgKXFJ2\n054fXZ4cQbCRArHtPfTsxr+8gCgRx4mmuwmEWlBzYDb6ar6V09mABnqubqJFOQFc\nFYgh63qeI59VxYTakxqpe1jofweHCcyiZJ2+8JHxdqmmg0qRBE1s3PA7hc7OpTUW\nSj82HozV6qz6K0zCWIbVPs5c+7A5FFgVV/0EpeBYC0gU4mvkE//gYiv/8mjL5r9C\nIbyWO4eRAgMBAAECggEAEEx0Z0cCYYuz+NUSbPJ/8ByeT7gnLCivBB0J4MW/fHZm\nyRyNyrAbVbCki/Oc9H4H3F2dmDe3h5RSpUpP19VkpyLzwHQwuwM/fwMxAJiHjZP7\nJZghGf5SSnGp7znh1/8BzNd21itc+XkoXd9iMhSMiVxyHpLFtSTh2F25Fxaqw4TD\nmR+id8VMEabGa3DQzVK4jhNfTNgLlrHpNWhaKMPewAZ7s4cD4vxweS7wUAzKm1U6\nAsa8je8BxJzFTJ1HmRpbAbmiD17g94ZkZzRf8rmYROVZF20PZ8QCAS0NZXgMPWVs\nzmshOc/+86akkI79LCsh675oc5ji4dr/cY2Jee6M+QKBgQDaTbwY+5UepRbHq1Zq\n+V9DzTTeiazZCuE0JPmH1zjXixI1mRDX8C38Q839BjkRZ2jujNLjBwS6W6kPrLfd\n9fmt5g4xHG5sFIAWi3q2fNPxF2vGCrpbUMRo6Ob6ZC4PvDwXDbc59tSm11x/B+JL\nagh2unczN/aU85EULOelGvdVKQKBgQDDog3BGCfAbw0GKuGZhOpBu/9hHIgnlf3n\n5onDn9VYhvOeCw/ZEhqnYDArmdyVHf2kYAQTJFSBzc5x0sn7PHsX3orn18+RxRSq\nIXJnoTIPRIF9znwjzZIbYxKNHix2AQYV2G/Nm0ZdzjRDA1ANPTSHW97W5W1NZ+FE\nxFBlQgBEKQKBgExVSiRiNC5XA7Ql0T3unMUUiBwYf/wUtdKJ60b4lsOnuWJMd3tK\nXIoNG4YSGvpe8m4Xh9YiqiCP1HnKpzBRxlBsVSIPEv1v3aoEc5BD7cgrrF+/eJJd\nl5AngDylswWFiG13Ok5mZM1CGPHCS/qaxQLfCLc8JljHIj+vxAATgdChAoGATjAp\nkSAnWxjHOszOp73gpm8NzXFK1Y90EEgqjV4HNb+SBHtlVRuQPY8LEZIIAC0hX53k\nYwYlJE/uD73wbhIpHEwcdjbhxd/ft3NwtwxM5p85pd9t7B1QJNP+6RnDKVKVbQu4\n+5Lwl7M/Xf0n9HKe2O6V7It7mPFIrmRLwXyUgKkCgYBhRHGqrc755GJMzQEHBFVa\ncUhbFxNols8+FJWXxPD8R1R7nI9hN3/N2nrBjb0hDlNKwQhKMw73s1xNWAM2gqKW\nN5GM27YJXkYqDaf3XREepHmhkhbPLRBj/2aa8mM+sPjv3msd8C6g3FU0OLE+IAgS\na4yiGTWYL5pntAindL7kcA==\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-project@flutter-412712.iam.gserviceaccount.com",
  "client_id": "116642745525245529415",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-project%40flutter-412712.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

''';

  static final _spreadsheetId = '1g8MOufk7qoy5ReC59KVPI-VfVPC4EpPoRKQq8u5uvI4';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('worksheet1');
    countRows();
  }

  // nr tranzactii
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    loadTransactions();
  }

  // incarca GSheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    loading = false;
  }

//tranzactie noua
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

//calculator income
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

//calculator cheltuieli
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}