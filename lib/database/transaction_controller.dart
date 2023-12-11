import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:rupee_app/model/db_transaction.dart';

final ValueNotifier<List<TransactionModel>> transactionModelNotifier =
    ValueNotifier<List<TransactionModel>>([]);
// double totalIncome = 0.0;
// double totalExpense = 0.0;

class TransactionModelFunctions {
  final box = Hive.box<TransactionModel>('transactionBox');

  // final ValueNotifier<double> totalIncomeNotifier = ValueNotifier<double>(0.0);
  // final ValueNotifier<double> totalExpenseNotifier = ValueNotifier<double>(0.0);

  // double totalIncome = 0.0;
  // double totalExpense = 0.0;

  // void updateTotalIncome(double newIncome) {
  //   totalIncome += newIncome;
  // }

  // void updateTotalExpense(double newExpense) {
  //   totalExpense += newExpense;
  // }

  List<TransactionModel> transactionDetailsNotifier = [];

  final box1 = Hive.box<TransactionModel>('transactionBox');
  // Method to update total income and expense
  // void updateTotalValues(List<TransactionModel> transactions) {
  //   double totalIncome = 0.0;
  //   double totalExpense = 0.0;

  //   for (var transaction in transactions) {
  //     if (transaction.type == true) {
  //       totalIncome += transaction.amount;
  //     } else {
  //       totalExpense += transaction.amount;
  //     }
  //   }

  // totalIncomeNotifier.value = totalIncome;
  // totalExpenseNotifier.value = totalExpense;
  // }

  Future<void> addTransaction(TransactionModel money) async {
    final box1 = await Hive.openBox<TransactionModel>('transactionBox');
    await box1.put(money.id, money);
    transactionModelNotifier.value.add(money);
    await box.put(money.id, money);

    // if (money.type) {
    //   // Income transaction
    //   totalIncome += money.amount;
    // } else {
    //   // Expense transaction
    //   totalExpense += money.amount;
    // }

    //notifyListeners();
    // // Update respective total notifier based on income or expense
    // if (money.isIncome) {
    //   updateTotalIncome(money.amount);
    // } else if (money.isExpense) {
    //   updateTotalExpense(money.amount);
    // }

    log('Added Transaction Details to Database');
    transactionModelNotifier.value = box.values.toList();
    transactionModelNotifier.notifyListeners();
  }

  Future<void> getAllTransactions() async {
    final box1 = await Hive.openBox<TransactionModel>('transactionBox');
    transactionModelNotifier.value.clear();
    transactionModelNotifier.value.addAll(box1.values);
    transactionModelNotifier.notifyListeners();
    //   final box = await Hive.openBox<TransactionModel>('transactionBox');
    //   transactionModelNotifier.value = box.values.toList();
    //   // Calculate total income and expense when retrieving all transactions
    //  // calculateTotalIncomeAndExpense();
    //   transactionModelNotifier.notifyListeners();
  }

  Future<void> updateTransaction(
      String transactionId, TransactionModel updatedTransaction) async {
    final box = await Hive.openBox<TransactionModel>('transactionBox');
    await box.put(transactionId, updatedTransaction);
    transactionModelNotifier.value = box.values.toList();
    transactionModelNotifier.notifyListeners();
  }

  Future<void> deleteTransaction(String transactionId) async {
    final box = await Hive.openBox<TransactionModel>('transactionBox');
    await box.delete(transactionId);
    transactionModelNotifier.value = box.values.toList();
    transactionModelNotifier.notifyListeners();
  }

  // void notifyListeners() {
  //   totalIncomeNotifier.value = totalIncome;
  //   totalExpenseNotifier.value = totalExpense;
  //   transactionModelNotifier.value = box.values.toList();
  //   transactionModelNotifier.notifyListeners();
  // }

  // static void calculateTotalIncomeAndExpense() {

  //   transactionModelNotifier.value.forEach((transaction) {
  //     if (transaction.type) {
  //       totalIncome += transaction.amount;
  //     } else {
  //       totalExpense += transaction.amount;
  //     }
  //   });
  //   totalIncome = transactionModelNotifier.value
  //       .where((transaction) => transaction.type)
  //       .fold<double>(
  //           0, (previousValue, element) => previousValue + element.amount);

  //   totalExpense = transactionModelNotifier.value
  //       .where((transaction) => !transaction.type)
  //       .fold<double>(
  //           0, (previousValue, element) => previousValue + element.amount);
  // }
  // void updateTotalIncome(double newIncome) {
  //   totalIncomeNotifier.value += newIncome;
  // }

  // void updateTotalExpense(double newExpense) {
  //   totalExpenseNotifier.value += newExpense;
  // }

  // Future<void> saveChanges(String transactionId) async {
  //  // TransactionModel updatedTransaction = getUpdatedTransaction();
  //  // await updateTransaction(transactionId, updatedTransaction)
  // }
}
