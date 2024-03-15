import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'database/db.dart';

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
  String dataDeleted = '';

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

  void _deleteExpenses() async {
    await database.deleteExpenses();
    final snackBar = SnackBar(
      content: Text('Deleted expenses'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _deleteIncome() async {
    await database.deleteIncome();
    final snackBar = SnackBar(
      content: Text('Deleted incomes'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _deleteBudget() async {
    await database.deleteBudget();
    final snackBar = SnackBar(
      content: Text('Deleted budgets'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        if (dataDeleted == 'expenses') {
          _deleteExpenses();
        } else if (dataDeleted == 'income') {
          _deleteIncome();
        } else if (dataDeleted == 'budget') {
          _deleteBudget();
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure?"),
      content: Text("Do you really want to continue?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Data"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ExpenseDashboard())); // Navigate back to the previous screen
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(title: Text("Users"), dense: true),
          ...users.map((user) => ListTile(
                title: Text("Email: ${user['username']}"),
                subtitle:
                    Text("Name: ${user['first_name']} ${user['last_name']}"),
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
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
            ),
            onPressed: () {
              dataDeleted = 'expenses';
              showAlertDialog(context);
            },
            child: Text(
              "Delete all expenses",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
            ),
            onPressed: () {
              dataDeleted = 'income';
              showAlertDialog(context);
            },
            child: Text(
              "Delete all incomes",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
            ),
            onPressed: () {
              dataDeleted = 'budget';
              showAlertDialog(context);
            },
            child: Text(
              "Delete all budgets",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
