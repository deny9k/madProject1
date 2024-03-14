import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dashboard.dart';
import 'database/db.dart';
import 'viewData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await database.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: ExpensePage(),
    ),
  );
}

class ExpensePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(), // Use the dark theme
      title: 'Add Expense',

      home: AddExpensePage(),
    );
  }
}

class DataModel {
  double? expenseAmount;
  String? expenseCategory;
}

class DataProvider with ChangeNotifier {
  DataModel data = DataModel();
}

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final database = ExpenseDatabase();
  String amount = "";
  String category = "";
  String description = "";
  DateTime selectedDate = DateTime.now();
  final dateController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  void resetData() {
    amount = "";
    amountController.clear();
    category = "";
    categoryController.clear();
    description = "";
    descriptionController.clear();
    dateController.clear();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2100, 12),
    );

    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
  }

  void _addedExpenseMsg() {
    final snackBar = SnackBar(
      content: Text('Successfully added expense'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expenses"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: amountController,
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
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.piggyBank),
                  labelText: 'Category',
                  hintText: 'Enter Category',
                ),
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.note),
                  labelText: 'Description',
                  hintText: 'Enter Description',
                ),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  labelText: 'Date',
                  hintText: 'Enter Date',
                ),
                onTap: () {
                  _selectDate(context);
                },
                readOnly: true,
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (category.isNotEmpty && amount.isNotEmpty) {
                        double? parsedAmount = double.tryParse(amount);
                        if (parsedAmount != null) {
                          await database.insertExpense(parsedAmount, category,
                              description, selectedDate);
                          resetData();
                          _addedExpenseMsg();
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
      ),
    );
  }
}
