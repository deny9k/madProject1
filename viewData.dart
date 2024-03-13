import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'db.dart';

class ViewDataPage extends StatefulWidget {
  @override
  _ViewDataPageState createState() => _ViewDataPageState();
}

class _ViewDataPageState extends State<ViewDataPage> {
  final database = ExpenseDatabase();

  // Declare separate lists for each table.
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> incomes = [];
  List<Map<String, dynamic>> budgets = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    users = await database.getUsers();
    expenses = await database.getExpenses();
    print('Fetched expenses: $expenses');
    incomes = await database.getIncomes();
    budgets = await database.getBudgets();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Data")),
      body: ListView(
        children: [
          ListTile(title: Text("Users"), dense: true),
          ...users.map((user) => ListTile(
                title: Text("Username: ${user['username']}"),
                subtitle: Text("Password: ${user['password']}"),
              )),
          ListTile(title: Text("Expenses"), dense: true),
          ...expenses.map((expense) => ListTile(
                title: Text("Amount: \$${expense['amount']}"),
                subtitle: Text(
                    "Category: ${expense['category']}\nDate: ${expense['expense_date']}\nDescription: ${expense['description']}"),
              )),
          ListTile(title: Text("Incomes"), dense: true),
          ...incomes.map((income) => ListTile(
                title: Text("Amount: \$${income['amount']}"),
                subtitle: Text("Period: ${income['period']}"),
              )),
          ListTile(title: Text("Budgets"), dense: true),
          ...budgets.map((budget) => ListTile(
                title: Text("Amount: \$${budget['amount']}"),
              )),
        ],
      ),
    );
  }
}
