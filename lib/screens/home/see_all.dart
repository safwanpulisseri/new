import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rupee_app/database/transaction_controller.dart';
import 'package:rupee_app/model/db_category.dart';
import 'package:rupee_app/model/db_transaction.dart';
import 'package:rupee_app/screens/home/details_transaction.dart';
import 'package:rupee_app/screens/home/edit_transaction.dart';
import 'package:rupee_app/screens/home/main_home.dart';

class ScreenSeeAllTransaction extends StatefulWidget {
  const ScreenSeeAllTransaction({super.key});

  @override
  State<ScreenSeeAllTransaction> createState() =>
      _ScreenSeeAllTransactionState();
}

class _ScreenSeeAllTransactionState extends State<ScreenSeeAllTransaction> {
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    Future<void> deleteTransaction(String transactionId) async {
      await TransactionModelFunctions().deleteTransaction(transactionId);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.orange,
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScreenMainHome()));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        Text(
                          'Transaction History',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                child: Container(
                  height: 740,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(30)),
                          child: TextField(
                            cursorHeight: 38,
                            style: TextStyle(fontSize: 20),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search',
                                //icon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Radio(
                                    value: 'All',
                                    groupValue: SelectAction,
                                    onChanged: (value) {}),
                              ),
                              Text(
                                'All',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Radio(
                                    value: 'AllIncome',
                                    groupValue: SelectAction,
                                    onChanged: (value) {}),
                              ),
                              Text(
                                'Income',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Radio(
                                    value: 'AllExpense',
                                    groupValue: SelectAction,
                                    onChanged: (value) {}),
                              ),
                              Text(
                                'Expense',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          )
                        ],
                      ),
                      Expanded(
                        child: ValueListenableBuilder<Box<TransactionModel>>(
                          valueListenable:
                              Hive.box<TransactionModel>('transactionBox')
                                  .listenable(),
                          builder: (context, box, child) {
                            final List<TransactionModel> transactions =
                                box.values.toList().cast<TransactionModel>();
                            final List<TransactionModel> filteredTransactions =
                                transactions.where((transaction) {
                              final String transactionName = transaction
                                  .category.categoryName
                                  .toLowerCase();
                              final String query = searchQuery.toLowerCase();
                              return transactionName.contains(query);
                            }).toList();

                            return ListView.builder(
                              itemCount: filteredTransactions.length,
                              itemBuilder: (context, index) {
                                final TransactionModel transaction =
                                    filteredTransactions[index];
                                final CategoryModel category =
                                    transaction.category;
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
                                      trailing: Text(
                                        '${transaction.amount}',
                                        style: TextStyle(fontSize: 20),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Slidable list_of_categories(Key transactionKey, int index) {
    return Slidable(
      //key: transactionKey,
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            onPressed: (ctx) {},
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      endActionPane: ActionPane(motion: ScrollMotion(), children: [
        SlidableAction(
          backgroundColor: Colors.blue,
          onPressed: (ctx) {},
          icon: Icons.edit,
          label: 'Edit',
        )
      ]),
      child: Expanded(
        child: ListView.builder(
          itemCount: transactionModelNotifier.value.length,
          itemBuilder: (context, index) {
            final TransactionModel transaction =
                transactionModelNotifier.value[index];
            final CategoryModel category = transaction.category;
            final DateTime date = transaction.date;

            return ListTile(
              title: Text(
                category.categoryName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              subtitle: Text('${date.day}/${date.month}/${date.year}'),
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
              trailing: Text(
                '${transaction.amount}',
                style: TextStyle(fontSize: 20),
              ),
            );
            ;
          },
        ),
      ),
    );
  }
}
