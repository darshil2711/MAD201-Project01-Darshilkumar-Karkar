/// MAD201-01 Assignment 3
/// Darshilkumar Karkar - A00203357
/// Transaction Model
// lib/models/transaction.dart
class Transaction {
  final int? id;
  final String title;
  final double amount;
  final String type; // "Income" or "Expense"
  final String category;
  final String date;

  Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  // Convert a Transaction into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date,
    };
  }

  // Factory constructor to create a Transaction from a Map.
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      type: map['type'],
      category: map['category'],
      date: map['date'],
    );
  }
}
