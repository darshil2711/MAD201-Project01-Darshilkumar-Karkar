/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// SharedPreferences "Database" Helper Class (Web Compatible)
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class DBHelper {
  // Use a constant for the key
  static const String _dbKey = 'transactions';

  /// (Private) Reads all transactions from SharedPreferences
  static Future<List<Transaction>> _readTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final jsonString = prefs.getString(_dbKey);
      if (jsonString != null) {
        // Decode the JSON string into a List of Maps
        final List<dynamic> jsonList = json.decode(jsonString) as List;
        // Convert the List of Maps into a List of Transactions
        return jsonList.map((map) => Transaction.fromMap(map)).toList();
      }
    } catch (e) {
      // If decoding fails, return an empty list
      return [];
    }
    return [];
  }

  /// (Private) Saves a list of transactions to SharedPreferences
  static Future<void> _saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert the List of Transactions into a List of Maps
    final List<Map<String, dynamic>> jsonList = transactions
        .map((tx) => tx.toMap())
        .toList();
    // Encode the List of Maps into a JSON string
    final jsonString = json.encode(jsonList);
    await prefs.setString(_dbKey, jsonString);
  }

  /// Inserts a new transaction.
  static Future<void> addTransaction(Transaction tx) async {
    final List<Transaction> transactions = await _readTransactions();

    // Create a new transaction with a unique ID
    final newTxWithId = Transaction(
      id: DateTime.now().millisecondsSinceEpoch, // Create a unique ID
      title: tx.title,
      amount: tx.amount,
      type: tx.type,
      category: tx.category,
      date: tx.date,
    );

    transactions.add(newTxWithId);
    await _saveTransactions(transactions);
  }

  /// Updates an existing transaction.
  static Future<void> updateTransaction(Transaction txToUpdate) async {
    final List<Transaction> transactions = await _readTransactions();

    // Find the index of the old transaction using its ID
    final int index = transactions.indexWhere((tx) => tx.id == txToUpdate.id);

    // If the transaction is found, replace it with the new one
    if (index != -1) {
      transactions[index] = txToUpdate;
      // Save the updated list
      await _saveTransactions(transactions);
    }
  }

  /// Retrieves all transactions, ordered by date.
  static Future<List<Transaction>> getAllTransactions() async {
    final List<Transaction> transactions = await _readTransactions();
    // Sort by date, descending (newest first)
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }

  /// Deletes a transaction by its id.
  static Future<void> deleteTransaction(int id) async {
    final List<Transaction> transactions = await _readTransactions();
    // Remove the transaction with the matching ID
    transactions.removeWhere((tx) => tx.id == id);
    await _saveTransactions(transactions);
  }

  /// Gets the sum of all income and all expenses
  static Future<Map<String, double>> getTotals() async {
    final List<Transaction> transactions = await _readTransactions();
    double totalIncome = 0;
    double totalExpense = 0;

    for (var tx in transactions) {
      if (tx.type == 'Income') {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;
      }
    }
    return {'income': totalIncome, 'expense': totalExpense};
  }

  /// Gets a summary of expenses grouped by category
  static Future<List<Map<String, dynamic>>> getCategorySummary() async {
    final List<Transaction> transactions = await _readTransactions();
    var summary = <String, double>{};

    // Group expenses by category
    for (var tx in transactions) {
      if (tx.type == 'Expense') {
        summary.update(
          tx.category,
          (value) => value + tx.amount,
          ifAbsent: () => tx.amount,
        );
      }
    }

    // Convert the map to a list and sort it
    var sortedSummary = summary.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Format it for the reports screen
    return sortedSummary
        .map((e) => {'category': e.key, 'total': e.value})
        .toList();
  }
}
