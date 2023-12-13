import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rupee_app/database/transaction_controller.dart';
import 'package:rupee_app/database/user_controller.dart';
import 'package:rupee_app/model/db_category.dart';
import 'package:rupee_app/model/db_transaction.dart';
import 'package:rupee_app/model/db_user.dart';
import 'package:rupee_app/screens/home/account/account.dart';
import 'package:rupee_app/screens/home/details_transaction.dart';
import 'package:rupee_app/screens/home/edit_transaction.dart';

import 'package:rupee_app/screens/home/see_all.dart';
import 'package:rupee_app/screens/widgets/time.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> totalIncomeNotifier =
        ValueNotifier<double>(0.0);
    final ValueNotifier<double> totalExpenseNotifier =
        ValueNotifier<double>(0.0);

    // Function to fetch total income and total expense
    Future<void> fetchTotalAmounts() async {
      final TransactionModelFunctions transactionFunctions =
          TransactionModelFunctions();
      final double totalIncome = transactionFunctions.calculateTotalIncome();
      final double totalExpense = transactionFunctions.calculateTotalExpense();

      totalIncomeNotifier.value = totalIncome;
      totalExpenseNotifier.value = totalExpense;
    }

    // Fetch total amounts when the screen builds
    fetchTotalAmounts();

    // Fetch transaction details from the database
    // Here, might use transactionModelNotifier or another way to fetch data
    Future<void> deleteTransaction(String transactionId) async {
      await TransactionModelFunctions().deleteTransaction(transactionId);
    }

    return Material(
      child: Container(
        // SCREEN ONE
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 230,
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            '${GreetingWidget().getGreeting()},',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          ValueListenableBuilder<Box<UserModel>>(
                            valueListenable:
                                Hive.box<UserModel>('userProfileBox')
                                    .listenable(),
                            builder: (context, box, child) {
                              final UserProfileFunctions profileFunctions =
                                  UserProfileFunctions();
                              final List<UserModel> profileDetailsList =
                                  profileFunctions.getAllProfileDetails();

                              if (profileDetailsList.isNotEmpty) {
                                final UserModel profileDetails =
                                    profileDetailsList.first;
                                // Check if the user's name is not null or empty
                                if (profileDetails.name != null &&
                                    profileDetails.name.isNotEmpty) {
                                  return Row(
                                    children: [
                                      Text(
                                        '${profileDetails.name}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ],
                                  );
                                }
                              }
                              // Default text if no name is added
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hi, User',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Row(
                            children: [
                              Text(
                                '₹0.0',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'your balance',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 75, //
                              ),
                              ValueListenableBuilder<Box<UserModel>>(
                                valueListenable:
                                    Hive.box<UserModel>('userProfileBox')
                                        .listenable(),
                                builder: (context, box, child) {
                                  final UserProfileFunctions profileFunctions =
                                      UserProfileFunctions();
                                  final List<UserModel> profileDetailsList =
                                      profileFunctions.getAllProfileDetails();

                                  if (profileDetailsList.isNotEmpty) {
                                    final UserModel profileDetails =
                                        profileDetailsList.first;
                                    // Check if the user has added a photo
                                    if (profileDetails.imagePath != null &&
                                        profileDetails.imagePath!.isNotEmpty) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ScreenAccount(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.file(
                                              File(profileDetails.imagePath!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 5,
                                              color: Colors.black,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white,
                                                offset: Offset(5, 5),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  // Default image if no photo is added
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ScreenAccount(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          'assets/profile.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(5, 5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            // CenterWhitecontainer
            Container(
              height: 600,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder<double>(
                        valueListenable: totalIncomeNotifier,
                        builder: (context, totalIncome, child) {
                          return Card(
                            elevation: 5,
                            child: Container(
                              height: 120,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.1),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Income',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '₹ $totalIncome',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ValueListenableBuilder(
                        valueListenable: totalExpenseNotifier,
                        builder: (context, totalExpense, child) {
                          return Card(
                            elevation: 5,
                            child: Container(
                              height: 120,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.1),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Expense',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '₹ $totalExpense',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Recent Transaction',
                        style: TextStyle(fontSize: 22),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(color: Colors.black),
                              minimumSize: Size(0, 30),
                              backgroundColor: Colors.grey[200],
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ScreenSeeAllTransaction()));
                            },
                            child: Text(
                              'See all',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  // List of Recent Transactions

                  Expanded(
                    child: ValueListenableBuilder<Box<TransactionModel>>(
                      valueListenable:
                          Hive.box<TransactionModel>('transactionBox')
                              .listenable(),
                      builder: (context, box, child) {
                        final List<TransactionModel> transactions =
                            box.values.toList().cast<TransactionModel>();
                        // Reverse the list to show most recent transactions first
                        final List<TransactionModel> reversedTransactions =
                            transactions.reversed.toList();

                        return ListView.builder(
                          itemCount: reversedTransactions.length,
                          itemBuilder: (context, index) {
                            final TransactionModel transaction =
                                reversedTransactions[index];
                            final CategoryModel category = transaction.category;
                            final DateTime date = transaction.date;

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TransactionDetailScreen(
                                            transaction: transaction),
                                  ),
                                );
                              },
                              child: Slidable(
                                startActionPane: (ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.red,
                                      onPressed: (ctx) {
                                        // Remove transaction from the database
                                        deleteTransaction(transaction.id);
                                        // Update UI as needed
                                      },
                                      label: 'Delete',
                                      icon: Icons.delete,
                                    ),
                                  ],
                                )),
                                endActionPane: (ActionPane(
                                  //extentRatio: 0.5,
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.blue,
                                      onPressed: (ctx) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditTransactionScreen(
                                                    transactionId:
                                                        transaction.id),
                                          ),
                                        );
                                      },
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    )
                                  ],
                                )),
                                child: ListTile(
                                  title: Text(
                                    category.categoryName,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                      '${date.day}/${date.month}/${date.year}'),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 30,
                                    child: ClipOval(
                                      child: Image.asset(
                                        category.categoryImagePath,
                                        // height: 100,
                                        // width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '₹${transaction.amount}',
                                        style: TextStyle(
                                          color: transaction.isIncome
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 0,
                                      ),
                                      transaction.isIncome
                                          ? Image.asset(
                                              'assets/icon_income copy.png',
                                              height: 20,
                                              width: 20,
                                            )
                                          : Image.asset(
                                              'assets/icon_expense-2.png',
                                              height: 20,
                                              width: 20,
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
