/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// Reports Screen Implementation
import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reports & Summary')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DBHelper.getCategorySummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No expense data for reports.'));
          }

          final summaryData = snapshot.data!;

          return Card(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Expenses by Category',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: summaryData.length,
                    itemBuilder: (ctx, i) {
                      final item = summaryData[i];
                      return ListTile(
                        title: Text(item['category']),
                        trailing: Text(
                          '\$${(item['total'] as double).toStringAsFixed(2)}',
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
