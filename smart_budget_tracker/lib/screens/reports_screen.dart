/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// Reports Screen Implementation
library;

import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reports & Summary')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DBHelper.getCategorySummary(),
        builder: (context, snapshot) {
          // 1. While data is loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // 2. If there is no data or the list is empty
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No expense data for reports.'));
          }
          // 3. If an error occurred
          if (snapshot.hasError) {
            return Center(child: Text('An error occurred.'));
          }

          // 4. If data is successfully loaded
          final summaryData = snapshot.data!;

          return Card(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Expenses by Category',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Divider(),
                // Use Expanded so the ListView takes the remaining space
                Expanded(
                  child: ListView.builder(
                    itemCount: summaryData.length,
                    itemBuilder: (ctx, i) {
                      final item = summaryData[i];
                      return ListTile(
                        title: Text(
                          item['category'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          '\$${(item['total'] as double).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
