/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// Add Transaction Screen Implementation
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/db_helper.dart';
import '../models/transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedType = 'Expense';
  String _selectedCategory = 'Food'; // Default category
  DateTime _selectedDate = DateTime.now();

  // Simple category lists
  final List<String> _expenseCategories = [
    'Food',
    'Transport',
    'Bills',
    'Other',
  ];
  final List<String> _incomeCategories = ['Salary', 'Bonus', 'Other'];

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _submitData() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newTx = Transaction(
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      type: _selectedType,
      category: _selectedCategory,
      date: DateFormat.toIso8601String(_selectedDate), // Store as ISO string
    );

    DBHelper.addTransaction(newTx).then((_) {
      Navigator.of(context).pop(); // Go back after saving
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentCategories = _selectedType == 'Expense'
        ? _expenseCategories
        : _incomeCategories;

    // Ensure selected category is valid
    if (!currentCategories.contains(_selectedCategory)) {
      _selectedCategory = currentCategories[0];
    }

    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid amount.';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: ['Expense', 'Income'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: currentCategories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    child: Text('Choose Date'),
                    onPressed: _presentDatePicker,
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Add Transaction'),
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
