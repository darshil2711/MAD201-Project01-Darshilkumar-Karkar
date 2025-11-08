/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// Add/Edit Transaction Screen Implementation
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/db_helper.dart';
import '../models/transaction.dart';
import 'package:flutter/services.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transaction; // Optional transaction for editing

  const AddTransactionScreen({super.key, this.transaction});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Use TextEditingControllers for TextFormFields
  late TextEditingController _titleController;
  late TextEditingController _amountController;

  // State variables for dropdowns and date
  String _type = 'Expense';
  String _category = 'Food';
  DateTime _selectedDate = DateTime.now();

  final List<String> _expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other',
  ];
  final List<String> _incomeCategories = ['Salary', 'Gift', 'Bonus', 'Other'];

  @override
  void initState() {
    super.initState();

    final tx = widget.transaction;

    // Initialize controllers and state based on add vs. edit mode
    if (tx != null) {
      // Edit Mode: Pre-fill all fields
      _titleController = TextEditingController(text: tx.title);
      _amountController = TextEditingController(text: tx.amount.toString());
      _type = tx.type;
      _category = tx.category;
      _selectedDate = DateTime.parse(tx.date);
    } else {
      // Add Mode: Initialize with defaults
      _titleController = TextEditingController();
      _amountController = TextEditingController();
      _type = 'Expense';
      _category = 'Food';
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    // Always dispose of controllers
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
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

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      final newTransaction = Transaction(
        id: widget.transaction?.id, // Keep id if editing, null if adding
        title: _titleController.text, // Get value from controller
        amount: double.parse(
          _amountController.text,
        ), // Get value from controller
        type: _type,
        category: _category,
        date: _selectedDate.toIso8601String(),
      );

      // Check if we are adding or updating
      if (widget.transaction == null) {
        // Add 'await' here
        await DBHelper.addTransaction(newTransaction);
      } else {
        // Add 'await' here
        await DBHelper.updateTransaction(newTransaction);
      }

      // This line will now wait until the save is complete
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the current list of categories based on the selected type
    final currentCategories = _type == 'Expense'
        ? _expenseCategories
        : _incomeCategories;

    // Ensure the selected category is valid for the current type
    if (!currentCategories.contains(_category)) {
      _category = currentCategories[0];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction == null ? 'Add Transaction' : 'Edit Transaction',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _titleController, // Use controller
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title.' : null,
                // No onSaved needed
              ),
              TextFormField(
                controller: _amountController, // Use controller
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a positive amount.';
                  }
                  return null;
                },
                // No onSaved needed
              ),
              DropdownButtonFormField<String>(
                value: _type, // *** FIX: Use value instead of initialValue
                decoration: const InputDecoration(labelText: 'Type'),
                items: ['Expense', 'Income'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _type = newValue!;
                    // Reset category when type changes
                    _category = _type == 'Expense'
                        ? _expenseCategories[0]
                        : _incomeCategories[0];
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _category, // *** FIX: Use value instead of initialValue
                decoration: const InputDecoration(labelText: 'Category'),
                items: currentCategories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) => setState(() => _category = newValue!),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text(
                  widget.transaction == null
                      ? 'Add Transaction'
                      : 'Update Transaction',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
