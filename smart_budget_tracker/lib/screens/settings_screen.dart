/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// Settings Screen Implementation
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../providers/theme_notifier.dart'; // Import the notifier

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedCurrency = 'USD';
  Future<String>? _rateFuture;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _fetchRate();
  }

  void _fetchRate() {
    setState(() {
      _rateFuture = ApiService.getConversionRate('USD', 'CAD');
    });
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = prefs.getString('currency') ?? 'USD';
    });
  }

  void _saveCurrency(String? value) async {
    if (value == null) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currency', value);
    setState(() {
      _selectedCurrency = value;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Currency preference saved')));
  }

  @override
  Widget build(BuildContext context) {
    // Get the notifier to access the theme state
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Theme Toggle
          SwitchListTile(
            title: Text('Dark Mode'),
            // Set the value from the notifier
            value: themeNotifier.isDarkMode,
            // Call the notifier's method on change
            onChanged: (value) {
              themeNotifier.toggleTheme(value);
            },
          ),
          Divider(),
          // Currency Preference
          ListTile(
            title: Text('Default Currency'),
            trailing: DropdownButton<String>(
              value: _selectedCurrency,
              items: ['USD', 'CAD', 'EUR', 'INR'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: _saveCurrency,
            ),
          ),
          Divider(),
          // API Conversion Rate Display
          ListTile(
            title: Text('Live Conversion Rate (USD → CAD)'),
            subtitle: FutureBuilder<String>(
              future: _rateFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading rate...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Text(
                    snapshot.data ?? 'Could not get rate',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                } else {
                  return Text('No rate data');
                }
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _fetchRate,
            ),
          ),
        ],
      ),
    );
  }
}
