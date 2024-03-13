import 'add_income.dart';
import 'package:flutter/material.dart';
import 'database/db.dart';
import 'database/dbtest.dart';

import 'login.dart';

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

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
       print('_getData call');
    e_total = 0;
    i_total = 0;
    expenses = await database.getExpenses();
    incomes = await database.getIncomes();

    for (final expense in expenses) {
      e_total += expense['amount'];
    }
    for (final income in incomes) {
      i_total += income['amount'];
    }
    setState(() {});
  }
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
                  // final result = Navigator.of(context).push(
                  // MaterialPageRoute(builder: (context) => AddExpensePage()), navigate to add expense page when created
                  //     );
                },
              ),
              ListTile(
                title: Text('Weekly Summary'),
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           SummaryPage()), // Navigate to summary page when creeated
                  // );
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
                ],
              ),
              SizedBox(height: 20),
              //add code for recent transactions
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) => AddExpensePage()), //navigate to add expense page
          // );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
