import 'database/db.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await database.init();
  runApp(ExpenseTrackerApp());
}

final database = ExpenseDatabase();

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SummaryPage(),
    );
  }
}

class SummaryPage extends StatefulWidget {
  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  double totalBudget = 0;
  double spent = 0;
  double remaining = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Summary'),
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
      body: Column(
        children: [
          Expanded(
            //add pie chart breakdown here
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: const EdgeInsets.all(8.0)),
                    Text(
                      'Breakdown of Spending',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: const EdgeInsets.all(8.0)),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 250,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Expenses vs. Remaining Money',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          Text(
                            'Spent',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$ $spent',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 40),
                    ),
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: LinearProgressIndicator(
                                  value: totalBudget == 0
                                      ? 0.0
                                      : (spent) / totalBudget,
                                  color: Colors.lightBlue),
                            ),
                            Text(
                              totalBudget == 0
                                  ? '0%'
                                  : ' ${((spent * 100) / totalBudget).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text('Percentage Spent'),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 30),
                    ),
                    Column(
                      children: [
                        Text(
                          'Remaining',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$ $remaining',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
