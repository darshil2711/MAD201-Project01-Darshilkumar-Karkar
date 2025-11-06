/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// Settings Screen Implementation
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _selectedCurrency = 'USD';
  Future<String>? _rateFuture;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _rateFuture = ApiService.getConversionRate('USD', 'CAD');
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _selectedCurrency = prefs.getString('currency') ?? 'USD';
    });
    // Note: Applying the theme app-wide requires a state management solution
    // like Provider, or passing this value all the way up to main.dart.
    // For this project, we just save the setting.
  }

  void _saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
    setState(() {
      _isDarkMode = value;
    });
    // Add logic here to actually change the theme (e.g., using Provider)
  }

  void _saveCurrency(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currency', value);
    setState(() {
      _selectedCurrency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: _saveTheme,
          ),
          ListTile(
            title: Text('Default Currency'),
            trailing: DropdownButton<String>(
              value: _selectedCurrency,
              items: ['USD', 'CAD', 'EUR'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  _saveCurrency(newValue);
                }
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Live Conversion Rate'),
            subtitle: FutureBuilder<String>(
              future: _rateFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading rate...');
                } else if (snapshot.hasError) {
                  return Text('Error loading rate');
                } else {
                  return Text(snapshot.data ?? 'Could not get rate');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
