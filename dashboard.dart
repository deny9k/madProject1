import 'add_income.dart';
import 'add_expense.dart';
import 'package:flutter/material.dart';
import 'database/db.dart';

import 'login.dart';
import 'summary.dart';
import 'viewData.dart';

final database = ExpenseDatabase();

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: ExpenseDashboard(),
    );
  }
}

class ExpenseDashboard extends StatefulWidget {
  @override
  _ExpenseDashboardState createState() => _ExpenseDashboardState();
}

class _ExpenseDashboardState extends State<ExpenseDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double expenseTotal = 0;
  double incomeTotal = 0;
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> incomes = [];
  List<Map<String, dynamic>> total = [];

  @override
  void initState() {
    super.initState();
    _getData();
    setState(() {}); //refresh page when coming back to it
  }

  void _getData() async {
    print('_getData call');
    expenseTotal = 0;
    incomeTotal = 0;
    expenses = await database.getExpenses();
    incomes = await database.getIncomes();

    for (final expense in expenses) {
      expenseTotal += expense['amount'];
    }
    for (final income in incomes) {
      incomeTotal += income['amount'];
    }
    setState(() {}); //refresh data when coming back to it
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: Text('Add Income'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddIncomePage()),
                  );
                },
              ),
              ListTile(
                title: Text('Add Expense'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddExpensePage()),
                  );
                },
              ),
              ListTile(
                title: Text('Weekly Summary'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SummaryPage()),
                  );
                },
              ),
              ListTile(
                title: Text('View Data'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewDataPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Log out'),
                onTap: () {
                  ExpenseDatabase.loggedInUserIdValue = null;
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Expenses',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('\$ ${expenseTotal}',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Income',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('\$ ${incomeTotal}',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              //add code for recent transactions
              Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      return TransactionCard(
                        transactionName: '${expenses[index]["category"]}',
                        amount: expenses[index]["amount"],
                        date: '${expenses[index]["expense_date"]}',
                        icon: Icons.shopping_cart,
                        categoryColor: Colors.purple,
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    AddExpensePage()), //navigate to add expense page
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String transactionName;
  final double amount;
  final String date;
  final IconData icon;
  final Color categoryColor;

  TransactionCard({
    required this.transactionName,
    required this.amount,
    required this.date,
    required this.icon,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 45,
          color: categoryColor,
        ),
        title: Text(
          transactionName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          date,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: Text(
          '\$$amount',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }
}
