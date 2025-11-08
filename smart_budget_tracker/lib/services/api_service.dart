/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// API Service for currency conversion
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  /// Fetches the conversion rate from one currency to another.
  static Future<String> getConversionRate(
    String baseCurrency,
    String targetCurrency,
  ) async {
    // Note: You must get a free API key from https://www.exchangerate-api.com/
    // and replace 'YOUR_API_KEY' with it.
    // Using the v6 API, as v4 is deprecated
    final url = Uri.parse(
      'https://v6.exchangerate-api.com/v6/fb3498c5c34a7335511f7441/latest/USD',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the API call was successful
        if (data['result'] == 'success') {
          final rate = data['conversion_rates'][targetCurrency];
          return '1 $baseCurrency = $rate $targetCurrency';
        } else {
          // Handle API-level errors
          return 'Failed to load rate: ${data['error-type']}';
        }
      } else {
        // Handle HTTP-level errors
        return 'Failed to load rate (Status code: ${response.statusCode})';
      }
    } catch (error) {
      // Handle network or other errors
      return 'Error: ${error.toString()}';
    }
  }
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.category = 'Other',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'date': date.toIso8601String(),
    'category': category,
  };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'],
    title: json['title'],
    amount: (json['amount'] as num).toDouble(),
    date: DateTime.parse(json['date']),
    category: json['category'] ?? 'Other',
  );
}

class ExpenseService {
  static const _storageKey = 'expenses_v1';
  final List<Expense> _expenses = [];

  List<Expense> get expenses => List.unmodifiable(_expenses);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        final list = json.decode(raw) as List;
        _expenses.clear();
        _expenses.addAll(
          list.map((e) => Expense.fromJson(e as Map<String, dynamic>)),
        );
      } catch (_) {}
    }
  }

  Future<bool> addExpense(Expense expense, {bool persist = true}) async {
    try {
      // basic validation
      if (expense.title.trim().isEmpty || expense.amount <= 0) return false;

      _expenses.insert(0, expense);

      if (persist) {
        final prefs = await SharedPreferences.getInstance();
        final encoded = json.encode(_expenses.map((e) => e.toJson()).toList());
        await prefs.setString(_storageKey, encoded);
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> clearAll() async {
    _expenses.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
