/// MAD201-01 Assignment 3
/// Darshilkumar Karkar - A00203357
/// Database Helper for Transactions
// lib/helpers/db_helper.dart
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import '../models/transaction.dart';

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'transactions.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount REAL, type TEXT, category TEXT, date TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<Map<String, double>> getTotals() async {
    final db = await DBHelper.database();
    double totalIncome = 0;
    double totalExpense = 0;

    final incomeResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ?',
      ['Income'],
    );
    if (incomeResult.first['total'] != null) {
      totalIncome = incomeResult.first['total'] as double;
    }

    final expenseResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ?',
      ['Expense'],
    );
    if (expenseResult.first['total'] != null) {
      totalExpense = expenseResult.first['total'] as double;
    }

    return {'income': totalIncome, 'expense': totalExpense};
  }

  static Future<List<Map<String, dynamic>>> getCategorySummary() async {
    final db = await DBHelper.database();
    // This query sums up amounts, grouped by category, only for expenses
    return db.rawQuery(
      'SELECT category, SUM(amount) as total FROM transactions WHERE type = ? GROUP BY category',
      ['Expense'],
    );
  }

  static Future<int> addTransaction(Transaction tx) async {
    final db = await DBHelper.database();
    return db.insert(
      'transactions',
      tx.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Transaction>> getAllTransactions() async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  static Future<int> updateTransaction(Transaction tx) async {
    final db = await DBHelper.database();
    return db.update(
      'transactions',
      tx.toMap(),
      where: 'id = ?',
      whereArgs: [tx.id],
    );
  }

  static Future<int> deleteTransaction(int id) async {
    final db = await DBHelper.database();
    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
