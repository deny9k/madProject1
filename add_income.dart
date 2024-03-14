import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_expense.dart';
import 'dashboard.dart';
import 'database/db.dart';
import 'viewData.dart';

enum PayPeriod { weekly, monthly }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await database.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: AddIncomePage(),
    ),
  );
}

class DataModel {
  double? incomeAmount;
  PayPeriod? incomePayPeriod;
}

class DataProvider with ChangeNotifier {
  DataModel data = DataModel();
}

class IncomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(), // Use the dark theme
      title: 'Add Income',
      home: AddIncomePage(),
    );
  }
}

class AddIncomePage extends StatefulWidget {
  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final database = ExpenseDatabase();
  String amount = "";
  PayPeriod? _selectedPayPeriod;

  final resetField = TextEditingController();
  final budgetField = TextEditingController();

  void resetData() {
    setState(() {
      amount = ""; // reset amount
      _selectedPayPeriod = null; // reset selected pay period
      resetField.clear(); // clear the TextField using its controller
      budgetField.clear(); // Clear the budget field
    });
  }

  void _addedIncomeMsg() {
    final snackBar = SnackBar(
      content: Text('Successfully added income'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Income"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpenseDashboard()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: resetField,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.attach_money),
                labelText: 'Amount',
                hintText: 'Enter Amount',
                suffixText: 'USD',
              ),
              onChanged: (value) {
                setState(() {
                  amount = value;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Pay Period: ',
                  style: TextStyle(fontSize: 16.0),
                ),
                Radio<PayPeriod>(
                  value: PayPeriod.weekly,
                  groupValue: _selectedPayPeriod,
                  onChanged: (PayPeriod? value) {
                    setState(() {
                      _selectedPayPeriod = value;
                    });
                  },
                  activeColor: Colors.blue,
                ),
                Text('Weekly'),
                Radio<PayPeriod>(
                  value: PayPeriod.monthly,
                  groupValue: _selectedPayPeriod,
                  onChanged: (PayPeriod? value) {
                    setState(() {
                      _selectedPayPeriod = value;
                    });
                  },
                  activeColor: Colors.blue,
                ),
                Text('Monthly'),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: budgetField,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.attach_money),
                labelText: 'Weekly Budget',
                hintText: 'Enter Weekly Budget',
                suffixText: 'USD',
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedPayPeriod != null && amount.isNotEmpty) {
                      double? parsedAmount = double.tryParse(amount);
                      if (parsedAmount != null) {
                        String parsePayPeriod =
                            _selectedPayPeriod.toString().split('.')[1];
                        await database.insertIncome(
                            parsedAmount, parsePayPeriod);
                        // Check if budgetField is not empty, parse and insert to the budget table
                        if (budgetField.text.isNotEmpty) {
                          double? parsedBudget =
                              double.tryParse(budgetField.text);
                          if (parsedBudget != null) {
                            await database.insertBudget(parsedBudget);
                          }
                        }
                        resetData();
                        _addedIncomeMsg();
                      }
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
