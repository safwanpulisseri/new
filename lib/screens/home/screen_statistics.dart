import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rupee_app/database/transaction_controller.dart';
import 'package:rupee_app/model/db_category.dart';
import 'package:rupee_app/model/db_transaction.dart';
import 'package:rupee_app/screens/home/details_transaction.dart';
import 'package:rupee_app/screens/home/edit_transaction.dart';

class ScreenStatistics extends StatefulWidget {
  const ScreenStatistics({super.key});

  @override
  State<ScreenStatistics> createState() => _ScreenStatisticsState();
}

class _ScreenStatisticsState extends State<ScreenStatistics> {
  @override
  Widget build(BuildContext context) {
    Future<void> deleteTransaction(String transactionId) async {
      await TransactionModelFunctions().deleteTransaction(transactionId);
    }

    return Material(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              'Statistics',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...List.generate(
                  4,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          index_color = index;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: index_color == index
                              ? Colors.orange.withAlpha(500)
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          day[index],
                          style: TextStyle(
                            color: index_color == index
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 300,
              width: 300,
              child: PieChart(
                swapAnimationDuration: Duration(
                  milliseconds: 750, // PIECHART TIME
                ),
                PieChartData(
                  sections: [
                    PieChartSectionData(value: 50, color: Colors.red),
                    PieChartSectionData(
                      value: 50,
                      color: Colors.green,
                    ),
                  ],
                  sectionsSpace: 2,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Transactions',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.swap_vert,
                    color: Colors.black,
                    size: 30,
                  ),
                ],
              ),
            ),
            // List of Top Transactions
            Expanded(
              child: ValueListenableBuilder<Box<TransactionModel>>(
                valueListenable:
                    Hive.box<TransactionModel>('transactionBox').listenable(),
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
                              builder: (context) => TransactionDetailScreen(
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
                                              transactionId: transaction.id),
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
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            subtitle:
                                Text('${date.day}/${date.month}/${date.year}'),
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
                                  '${transaction.amount}',
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
    );
  }

  List day = [
    'Day',
    'Week',
    'Month',
    'Year',
  ];
  //
  int index_color = 0;
}
