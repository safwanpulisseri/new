import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rupee_app/database/transaction_controller.dart';
import 'package:rupee_app/model/db_transaction.dart';
import 'package:rupee_app/screens/home/main_home.dart';

class EditTransactionScreen extends StatefulWidget {
  final String transactionId;

  const EditTransactionScreen({Key? key, required this.transactionId})
      : super(key: key);

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  TransactionModel? transaction; // Transaction details
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTransactionDetails();
  }

  Future<void> fetchTransactionDetails() async {
    final box = await Hive.openBox<TransactionModel>('transactionBox');
    setState(() {
      transaction = box.get(widget.transactionId);
      // Prefill the controllers with the initial values
      amountController.text = transaction?.amount.toString() ?? '';
      descriptionController.text = transaction?.description ?? '';
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Edit Transaction'),
      // ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.red, Colors.orange])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              height: 500,
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(
                              transaction?.category.categoryImagePath ?? '',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            transaction?.category.categoryName ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(25),
                    child: TextFormField(
                      //initialValue: transaction?.amount.toString() ?? '',
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        // contentPadding: EdgeInsets.symmetric(
                        //   horizontal: 15,
                        //   vertical: 15,
                        // ),
                        labelText: 'Amount',
                        labelStyle: TextStyle(
                            fontSize: 17, color: Colors.grey.shade800),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: TextFormField(
                      controller: descriptionController,
                      // initialValue: transaction?.description ?? '',
                      // keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        // contentPadding: EdgeInsets.symmetric(
                        //   horizontal: 15,
                        //   vertical: 15,
                        // ),
                        labelText: 'Description',
                        labelStyle: TextStyle(
                            fontSize: 17, color: Colors.grey.shade800),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Text('Amount: ${transaction?.amount}'),
                  // SizedBox(height: 10),
                  // Text('Description: ${transaction?.description}'),
                  // // Add more fields to display transaction details
                  // // ...
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 245, 91, 1),
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      if (transaction != null) {
                        final updatedTransaction = TransactionModel(
                          // transaction!.amount =
                          //     double.parse(amountController.text);
                          // transaction!.description = descriptionController.text;
                          // box.put(widget.transactionId, transaction!);
                          id: transaction!.id,
                          amount: double.parse(amountController.text),
                          description: descriptionController.text,
                          date: transaction!.date,
                          category: transaction!.category,
                          isIncome: transaction!
                              .isIncome, // or false based on whether it's an income or expense
                        );
                        await TransactionModelFunctions().updateTransaction(
                            transaction!.id, updatedTransaction);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ScreenMainHome()));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Transaction Updated')));
                      }
                      // Logic to save changes
                      // For example:
                      //saveChanges(transaction!.id);
                    },
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
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
