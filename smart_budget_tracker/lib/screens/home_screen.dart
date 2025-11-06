/// MAD201-01 Assignment 3
/// Darshilkumar Karkar - A00203357
/// Home Screen Implementation
import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';
import 'transactions_list_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Placeholder Cards
            Card(child: ListTile(title: Text("Total Income: \$0.00"))),
            Card(child: ListTile(title: Text("Total Expenses: \$0.00"))),
            Card(child: ListTile(title: Text("Balance: \$0.00"))),

            SizedBox(height: 20),

            ElevatedButton(
              child: Text("Add Transaction"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddTransactionScreen(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text("View All Transactions"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TransactionsListScreen(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text("View Reports"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ReportsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
