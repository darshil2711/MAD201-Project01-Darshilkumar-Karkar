/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// Home Screen Implementation (with auto-refresh)
import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';
import 'transactions_list_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import '../helpers/db_helper.dart'; // <-- Import the helper

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Use a Future to hold the dashboard data
  late Future<Map<String, double>> _totalsFuture;

  @override
  void initState() {
    super.initState();
    _refreshTotals();
  }

  // Gets the totals from the database and rebuilds the UI
  void _refreshTotals() {
    setState(() {
      _totalsFuture = DBHelper.getTotals();
    });
  }

  /// This is the key: it navigates to a new screen,
  /// and when that screen is "popped" (closed),
  /// the .then() block runs, refreshing the totals.
  void _navigateAndRefresh(Widget screen) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => screen)).then((_) {
      // This code runs when you come BACK to the HomeScreen
      _refreshTotals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            // Use the new helper method
            onPressed: () => _navigateAndRefresh(SettingsScreen()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Use a FutureBuilder to display the data from the database
            FutureBuilder<Map<String, double>>(
              future: _totalsFuture,
              builder: (context, snapshot) {
                // While loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // If error
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading totals.'));
                }

                // Get the data
                final income = snapshot.data?['income'] ?? 0.0;
                final expense = snapshot.data?['expense'] ?? 0.0;
                final balance = income - expense;

                // Display the data in Cards
                return Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text(
                          "Total Income: \$${income.toStringAsFixed(2)}",
                        ),
                        textColor: Colors.green,
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          "Total Expenses: \$${expense.toStringAsFixed(2)}",
                        ),
                        textColor: Colors.red,
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text("Balance: \$${balance.toStringAsFixed(2)}"),
                        titleTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 20),

            // Use the _navigateAndRefresh helper for all buttons
            ElevatedButton(
              child: Text("Add Transaction"),
              onPressed: () => _navigateAndRefresh(AddTransactionScreen()),
            ),
            ElevatedButton(
              child: Text("View All Transactions"),
              onPressed: () => _navigateAndRefresh(TransactionsListScreen()),
            ),
            ElevatedButton(
              child: Text("View Reports"),
              onPressed: () => _navigateAndRefresh(ReportsScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
