import 'package:hive/hive.dart';
import 'package:rupee_app/model/db_category.dart';

part 'db_transaction.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final CategoryModel category;

  @HiveField(5)
  bool isIncome; // True if income, False if expense

  TransactionModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
    required this.isIncome,
  });

  // Setter for isIncome
  void setIncome(bool income) {
    isIncome = income;
  }
}
