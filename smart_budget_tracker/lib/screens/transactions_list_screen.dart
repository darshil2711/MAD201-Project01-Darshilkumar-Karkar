/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// Add Transaction Screen Implementation
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/db_helper.dart';
import '../models/transaction.dart';

class TransactionsListScreen extends StatefulWidget {
  @override
  _TransactionsListScreenState createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _refreshTransactions();
  }

  void _refreshTransactions() {
    setState(() {
      _transactionsFuture = DBHelper.getAllTransactions();
    });
  }

  void _deleteTransaction(int id) {
    DBHelper.deleteTransaction(id).then((_) {
      _refreshTransactions(); // Refresh the list after deleting
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Transactions')),
      body: FutureBuilder<List<Transaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No transactions found.'));
          }

          final transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, i) {
              final tx = transactions[i];
              final isExpense = tx.type == 'Expense';
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isExpense ? Colors.red : Colors.green,
                    child: Icon(
                      isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(tx.title),
                  subtitle: Text(
                    DateFormat.yMd().format(DateTime.parse(tx.date)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${isExpense ? '-' : '+'}\$${tx.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isExpense ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: () => _deleteTransaction(tx.id!),
                      ),
                      // You would add an Edit button here
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
