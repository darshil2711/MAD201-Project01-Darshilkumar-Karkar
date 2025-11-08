/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// Transaction List Screen Implementation
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/db_helper.dart';
import '../models/transaction.dart';
import 'add_transaction_screen.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  _TransactionsListScreenState createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  // A Future that will hold our list of transactions from the database.
  // Using a Future is great for handling data that takes time to load.
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    // When the screen is first built, we kick off the process of fetching
    // the transactions from the database.
    _refreshTransactions();
  }

  /// This function re-fetches the transactions from the database and updates the state.
  /// We call this when the screen loads and after any add/edit/delete operation.
  void _refreshTransactions() {
    setState(() {
      _transactionsFuture = DBHelper.getAllTransactions();
    });
  }

  /// Navigates to the AddTransactionScreen to edit an existing transaction.
  /// After editing is complete, it refreshes the list.
  void _navigateToEditScreen(Transaction transaction) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) =>
                AddTransactionScreen(transaction: transaction),
          ),
        )
        .then((_) => _refreshTransactions()); // Refresh list after returning
  }

  /// Deletes a transaction from the database using its ID.
  /// After deletion, it refreshes the transaction list to update the UI.
  void _deleteTransaction(int id) {
    DBHelper.deleteTransaction(id).then(
      (_) => setState(() {
        // Re-fetch the list to show that the item is gone.
        _transactionsFuture = DBHelper.getAllTransactions();
        // Show a confirmation message to the user.
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Transaction deleted')));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The main structure of our screen
      appBar: AppBar(title: const Text('All Transactions')),
      body: FutureBuilder<List<Transaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred!'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No transactions found.'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    child: const Text('Add one now'),
                    onPressed: () {
                      Navigator.of(context) // Navigate to add a new one
                          .push(
                            MaterialPageRoute(
                              builder: (context) => AddTransactionScreen(),
                            ),
                          )
                          .then((_) => _refreshTransactions());
                    },
                  ),
                ],
              ),
            );
          }

          // If we have data, we build the list.
          final transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, i) {
              final tx = transactions[i];
              final isExpense = tx.type == 'Expense';
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isExpense ? Colors.red : Colors.green,
                    child: Icon(
                      isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                      color: Colors.white, // Visual cue for income vs expense
                    ),
                  ),
                  title: Text(tx.title),
                  subtitle: Text(
                    DateFormat.yMd().format(DateTime.parse(tx.date)),
                  ),
                  trailing: Row(
                    // Use a Row to hold the amount and action buttons.
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
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => _navigateToEditScreen(tx),
                      ),
                      // Delete button
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () => _deleteTransaction(tx.id!),
                      ),
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
