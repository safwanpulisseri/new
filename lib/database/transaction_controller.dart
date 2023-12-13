import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:rupee_app/model/db_transaction.dart';

final ValueNotifier<List<TransactionModel>> transactionModelNotifier =
    ValueNotifier<List<TransactionModel>>([]);

class TransactionModelFunctions {
  final box = Hive.box<TransactionModel>('transactionBox');

  double calculateTotalIncome() {
    double totalIncome = 0.0;
    final incomeTransactions =
        box.values.where((transaction) => transaction.isIncome);
    totalIncome = incomeTransactions.fold<double>(
        0, (previousValue, element) => previousValue + element.amount);
    return totalIncome;
  }

  double calculateTotalExpense() {
    double totalExpense = 0.0;
    final expenseTransactions =
        box.values.where((transaction) => !transaction.isIncome);
    totalExpense = expenseTransactions.fold<double>(
        0, (previousValue, element) => previousValue + element.amount);
    return totalExpense;
  }

  // Store total income and total expense in the database
  Future<void> storeTotalAmounts() async {
    final totalIncome = calculateTotalIncome();
    final totalExpense = calculateTotalExpense();

    final box = await Hive.openBox<double>('totalAmountsBox');
    await box.put('totalIncome', totalIncome);
    await box.put('totalExpense', totalExpense);
  }

  List<TransactionModel> transactionDetailsNotifier = [];

  final box1 = Hive.box<TransactionModel>('transactionBox');

  Future<void> addTransaction(
      TransactionModel money, String selectedRadio) async {
    final box1 = await Hive.openBox<TransactionModel>('transactionBox');
    // Check the selectedRadio value to determine if it's income or expense
    if (selectedRadio == 'Option 1') {
      money.isIncome = true; // Mark the transaction as income
    } else {
      money.isIncome = false; // Mark the transaction as expense
    }
    await box1.put(money.id, money);
    transactionModelNotifier.value.add(money);
    await box.put(money.id, money);

    log('Added Transaction Details to Database');
    transactionModelNotifier.value = box.values.toList();
    transactionModelNotifier.notifyListeners();
  }

  Future<void> getAllTransactions() async {
    final box1 = await Hive.openBox<TransactionModel>('transactionBox');
    transactionModelNotifier.value.clear();
    transactionModelNotifier.value.addAll(box1.values);
    transactionModelNotifier.notifyListeners();
  }

  Future<void> updateTransaction(
      String transactionId, TransactionModel updatedTransaction) async {
    final box = await Hive.openBox<TransactionModel>('transactionBox');
    await box.put(transactionId, updatedTransaction);

    transactionModelNotifier.value = box.values.toList();
    transactionModelNotifier.notifyListeners();

    // Update total income and total expense after updating a transaction
    storeTotalAmounts();
  }

  Future<void> deleteTransaction(String transactionId) async {
    final box = await Hive.openBox<TransactionModel>('transactionBox');
    await box.delete(transactionId);
    transactionModelNotifier.value = box.values.toList();
    transactionModelNotifier.notifyListeners();

    // Update total income and total expense after deleting a transaction
    storeTotalAmounts();
  }

  // Future<void> saveChanges(String transactionId) async {
  //  // TransactionModel updatedTransaction = getUpdatedTransaction();
  //  // await updateTransaction(transactionId, updatedTransaction)
  // }
}
