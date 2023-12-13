import 'package:flutter/material.dart';
import 'package:rupee_app/model/db_category.dart';
import 'package:rupee_app/model/db_transaction.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CategoryModel category = transaction.category;
    final DateTime date = transaction.date;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  category.categoryName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(fontSize: 16),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 30,
                  child: ClipOval(
                    child: Image.asset(
                      category.categoryImagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                trailing: Text(
                  '${transaction.amount}',
                  style: TextStyle(
                      color: transaction.isIncome ? Colors.green : Colors.red,
                      fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Description: ${transaction.description}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              // Other details you want to display
            ],
          ),
        ),
      ),
    );
  }
}
