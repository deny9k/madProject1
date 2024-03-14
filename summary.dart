import 'dart:math';

import 'package:pie_chart/pie_chart.dart';

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
  Map<String, double> dataMap = {};
  List<Color> colors = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await getExpenseTotal();
    await getBudget();
    await sumExpensesByCategory();
    await getRemaining();

    setState(() {
      colors = generateRandomColors(dataMap.length);
    });
  }

  Future<double> getExpenseTotal() async {
    spent = 0;
    final expenses = await database.getExpenses();
    for (var expense in expenses) {
      spent += expense['amount'] as double;
    }
    return spent;
  }

  Future<double> getBudget() async {
    final budgets = await database.getBudgets();
    if (budgets.isEmpty) {
      totalBudget = 0;
      return 0;
    }
    totalBudget = budgets[0]['amount'] as double;
    return totalBudget;
  }

  Future<Map<String, double>> sumExpensesByCategory() async {
    dataMap = {}; // Reset the data map
    final expenses = await database.getExpenses();
    for (var expense in expenses) {
      final category = expense['category'] as String?;
      final amount = expense['amount'] as double;
      if (category != null) {
        if (dataMap.containsKey(category)) {
          dataMap[category] = (dataMap[category]! + amount);
        } else {
          dataMap[category] = amount;
        }
      }
    }
    return dataMap;
  }

  Future<void> getRemaining() async {
    remaining = totalBudget - spent;
  }

  List<Color> generateRandomColors(int numberOfColors) {
    Random random = Random();

    List<Color> colors = [];
    for (int i = 0; i < numberOfColors; i++) {
      Color color = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
      colors.add(color);
    }

    return colors;
  }

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
                    dataMap.isNotEmpty
                        ? PieChart(
                            dataMap: dataMap,
                            animationDuration: Duration(milliseconds: 800),
                            chartLegendSpacing: 32.0,
                            chartRadius:
                                MediaQuery.of(context).size.width / 2.5,
                            initialAngleInDegree: 0,
                            chartType: ChartType.disc,
                            ringStrokeWidth: 32.0,
                            legendOptions: const LegendOptions(
                              showLegendsInRow: true,
                              legendPosition: LegendPosition.bottom,
                              showLegends: true,
                              legendShape: BoxShape.rectangle,
                              legendTextStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: false,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: true,
                              decimalPlaces: 1,
                            ),
                            colorList: colors,
                          )
                        : Center(child: Text('No data available'))
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
