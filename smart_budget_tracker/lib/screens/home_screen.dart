/// MAD201-01 Assignment 3
/// Darshilkumar Karkar - A00203357
/// Home Screen Implementation
// ... (imports)
import '../helpers/db_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, double>> _totalsFuture;

  @override
  void initState() {
    super.initState();
    _refreshTotals();
  }

  void _refreshTotals() {
    setState(() {
      _totalsFuture = DBHelper.getTotals();
    });
  }

  // Helper to navigate and refresh
  void _navigateAndRefresh(Widget screen) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => screen)).then((_) {
      // This .then() block runs when we pop() back to this screen
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
            onPressed: () => _navigateAndRefresh(SettingsScreen()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<Map<String, double>>(
              future: _totalsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final income = snapshot.data?['income'] ?? 0.0;
                final expense = snapshot.data?['expense'] ?? 0.0;
                final balance = income - expense;

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
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 20),

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
