import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ExpenseDatabase {
  // For the User table
  static const String userTable = "user";
  static const String userId = 'user_id';
  static const String username = 'username';
  static const String password = 'password';
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static int? loggedInUserId;

  // For the expense table
  static const String expenseDate = 'expense_date';
  static const String category = 'category';

  // For the Budget table
  static const String budgetTable = "budget";
  static const String budgetId = 'id';
  static const String budgetAmount = 'amount';

  // create the database
  static const name = "ExpenseDatabase.db";
  static late Database _database;

  static int? get loggedInUserIdValue => loggedInUserId;

  static set loggedInUserIdValue(int? value) {
    loggedInUserId = value;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await _database.query(userTable);
  }

  // Define formatDate here
  static String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    return await _database
        .query('expense', where: 'user_id = ?', whereArgs: [loggedInUserId]);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    if (loggedInUserId == null) {
      print("No user is logged in.");
    }
    return await _database
        .query(userTable, where: 'user_id = ?', whereArgs: [loggedInUserId]);
  }

  Future<List<Map<String, dynamic>>> getIncomes() async {
    return await _database
        .query(incomeTable, where: 'user_id = ?', whereArgs: [loggedInUserId]);
  }

  Future<List<Map<String, dynamic>>> getBudgets() async {
    return await _database
        .query(budgetTable, where: 'user_id = ?', whereArgs: [loggedInUserId]);
  }

  // initialize the database (will OPEN the database)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, name);
    _database = await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
    );
  }

  // create the table
  static const String expenseTable = "expense";
  static const String expenseId = 'id';
  static const String expenseAmount = 'amount';
  static const String expenseDescription = 'description';

  static const String incomeTable = "income";
  static const String incomeId = 'id';
  static const String incomeAmount = 'amount';
  static const String incomePeriod = 'period';
  Future _onCreate(Database database, int version) async {
    // Creating the User table first because other tables reference it
    await database.execute('''
        CREATE TABLE $userTable (
          $userId INTEGER PRIMARY KEY ,
           $firstName TEXT NOT NULL,     
          $lastName TEXT NOT NULL,
          $username TEXT NOT NULL UNIQUE,
          $password TEXT NOT NULL  
        )
        ''');

    await database.execute('''
        CREATE TABLE $expenseTable (
          $expenseId INTEGER PRIMARY KEY AUTOINCREMENT,
          $expenseAmount REAL NOT NULL,
          $category TEXT,
          $expenseDescription TEXT,
          $expenseDate TEXT NOT NULL,
          user_id INTEGER,
          FOREIGN KEY (user_id) REFERENCES $userTable($userId)
        )
        ''');

    await database.execute('''
        CREATE TABLE $incomeTable (
          $incomeId INTEGER PRIMARY KEY,
          $incomeAmount REAL NOT NULL,
          $incomePeriod TEXT NOT NULL,
          user_id INTEGER,
          FOREIGN KEY (user_id) REFERENCES $userTable($userId)
        )
        ''');

    await database.execute('''
        CREATE TABLE $budgetTable (
          $budgetId INTEGER PRIMARY KEY,
          $budgetAmount REAL NOT NULL,
          user_id INTEGER,
          FOREIGN KEY (user_id) REFERENCES $userTable($userId)
        )
        ''');
  }

  Future<List<Map<String, dynamic>>> getUsersByEmail(String email) async {
    return await _database
        .query(userTable, where: 'username= ?', whereArgs: [email]);
  }

  Future<void> insertUser(
      String fName, String lName, String email, String pwd) async {
    await _database.insert(
      userTable,
      {
        firstName: fName,
        lastName: lName,
        username: email,
        password: pwd,
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    print("User inserted successfully");
  }

  // insert data into the income table
  Future<void> insertIncome(double amount, String period) async {
    if (loggedInUserId == null) {
      print("No user is logged in.");
    }

    await _database.insert(
      incomeTable,
      {
        incomeAmount: amount,
        incomePeriod: period,
        'user_id': loggedInUserId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    String path = await getDatabasesPath();
    print(path);
  }

  Future<void> insertBudget(double amount) async {
    if (loggedInUserId == null) {
      print("No user is logged in.");
    }

    await _database.insert(
      budgetTable,
      {
        budgetAmount: amount,
        'user_id': loggedInUserId,
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    print("Budget inserted successfully");
  }

  // insert data into the expense table
  Future<void> insertExpense(double amount, String category, String description,
      DateTime expenseDate) async {
    if (loggedInUserId == null) {
      print("No user is logged in.");
    }

    String formattedDate = ExpenseDatabase.formatDate(expenseDate);
    await _database.insert(
      expenseTable,
      {
        expenseAmount: amount,
        'category': category,
        expenseDescription: description,
        'expense_date': formattedDate,
        'user_id': loggedInUserId,
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    print("Data inserted successfully");
  }
}
