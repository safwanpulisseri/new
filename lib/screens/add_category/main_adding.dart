import 'dart:developer';
import 'dart:ffi';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:rupee_app/database/transaction_controller.dart';
import 'package:rupee_app/model/db_category.dart';
import 'package:rupee_app/model/db_transaction.dart';
import 'package:rupee_app/screens/home/main_home.dart';
import 'package:rupee_app/screens/home/screen_home.dart';

class ScreenMainAdding extends StatefulWidget {
  const ScreenMainAdding({Key? key}) : super(key: key);

  @override
  State<ScreenMainAdding> createState() => _ScreenMainAddingState();
}

class _ScreenMainAddingState extends State<ScreenMainAdding> {
  // double totalIncome = 0.0;
  // double totalExpense = 0.0;
  final _formKey = GlobalKey<FormState>(); // Add GlobalKey for form validation
  String selectedRadio = 'Option 1';

  Future<void> _saveTransaction() async {
    // Determine if it's an income or expense transaction
    // bool isIncome = selectedRadio == 'Option 1';
    // bool isExpense = selectedRadio == 'Option 2';

    print('Transaction in Progress');

    // Retrieve values from controllers and variables
    double amount = double.tryParse(amount_C.text) ?? 0.0;
    String description = explain_C.text;
    DateTime date = DateTime.now();
    final String categoryName =
        selectedItem ?? "Others"; // Use a default if no category selected

    final CategoryModel selectedCategory = _findCategoryByName(categoryName);

    // Create a transaction model instance
    TransactionModel newTransaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      description: description,
      date: date,
      category: selectedCategory,
      isIncome: true, // or false based on whether it's an income or expense
    );
    // Call the function to add the transaction to the database
    await TransactionModelFunctions()
        .addTransaction(newTransaction, selectedRadio);

    // if (isIncome) {
    //   await calculateTotalIncome();
    // } else if (isExpense) {
    //   await calculateTotalExpense();
    // }
    print('adding complete');
    var hiveBox = await Hive.openBox<TransactionModel>('transactionBox');
    final allData = hiveBox.values.toList();
    log(allData.length.toString());
    for (var data in allData) {
      log("Diary Entry: key=${data.id} Date=${data.date}, Title=${data.amount}, Content=${data.description}, ImagePath=${data.category}, ");
    }
  }

  CategoryModel _findCategoryByName(String categoryName) {
    List<CategoryModel> categories = [
      CategoryModel(
          categoryName: "Wages", categoryImagePath: "assets/Income1.png"),
      CategoryModel(
          categoryName: "Pension", categoryImagePath: "assets/Income2.png"),
      CategoryModel(
          categoryName: "Bonus", categoryImagePath: "assets/Icome3.png"),
      CategoryModel(
          categoryName: "Dividend", categoryImagePath: "assets/Income4.png"),
      // Add other income categories

      CategoryModel(
          categoryName: "Bills", categoryImagePath: "assets/Bills1.png"),
      CategoryModel(
          categoryName: "Health", categoryImagePath: "assets/Bills2.png"),
      CategoryModel(
          categoryName: "Shopping", categoryImagePath: "assets/Bills3.png"),
      CategoryModel(
          categoryName: "Recharge", categoryImagePath: "assets/Bills4.png"),
      // Add other expense categories

      // Add more categories as needed
    ];
    // Find the CategoryModel with the specified name
    CategoryModel selectedCategory = categories.firstWhere(
        (category) => category.categoryName == categoryName,
        orElse: () => CategoryModel(
            categoryName: categoryName,
            categoryImagePath:
                "assets/Others.png")); //add Default IMage "assets/default_category_image.png"
    return selectedCategory;
  }

  void _handleRadioValueChanged(String value) {
    setState(() {
      selectedRadio = value;
    });
  }

  DateTime date = DateTime.now();
  String? selectedItem;
  final TextEditingController explain_C = TextEditingController();

  FocusNode ex = FocusNode();
  final TextEditingController amount_C = TextEditingController();
  FocusNode amount = FocusNode();

  final List<String> _itemsOfExpense = [
    "Bills",
    "Health",
    "Shopping",
    "Recharge",
  ];
  final List<String> _itemsOfIncome = [
    "Wages",
    "Pension",
    "Bonus",
    "Dividend",
  ];
  int index = 0;

  @override
  void initState() {
    super.initState();
    ex.addListener(() {
      setState(() {});
    });
    amount.addListener(() {
      setState(() {});
    });
    // Fetch initial total income and expense from the database
    // calculateTotalIncome();
    // calculateTotalExpense();
  }

  // Future<void> calculateTotalIncome() async {
  //   var hiveBox = await Hive.openBox<TransactionModel>('transactionBox');
  //   final allIncome =
  //       hiveBox.values.where((transaction) => transaction.isIncome);
  //   double totalIncome =
  //       allIncome.fold(0, (prev, element) => prev + element.amount);

  //   // Update the total income in the TransactionModelFunctions
  //   TransactionModelFunctions().updateTotalIncome(totalIncome);
  // }

  // Future<void> calculateTotalExpense() async {
  //   var hiveBox = await Hive.openBox<TransactionModel>('transactionBox');
  //   final allExpense =
  //       hiveBox.values.where((transaction) => transaction.isExpense);
  //   double totalExpense =
  //       allExpense.fold(0, (prev, element) => prev + element.amount);

  //   // Update the total expense in the TransactionModelFunctions
  //   TransactionModelFunctions().updateTotalExpense(totalExpense);
  // }

  List<String> expenseImages = [
    'assets/Bills1.png',
    'assets/Bills2.png',
    'assets/Bills3.png',
    'assets/Bills4.png',
  ];
  List<String> incomeImages = [
    'assets/Income1.png',
    'assets/Income2.png',
    'assets/Icome3.png',
    'assets/Income4.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            backgroundContainer(context),
            Positioned(
              top: 120,
              child: mainContainer(),
            ),
          ],
        ),
      ),
    );
  }

  Container mainContainer() {
    return Container(
      height: 600,
      width: 350,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey,
            offset: Offset(5, 5),
          ),
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey,
            offset: Offset(-1, -1),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            category_selection(),
            SizedBox(
              height: 50,
            ),
            amounts(),
            SizedBox(
              height: 20,
            ),
            explain(),
            SizedBox(
              height: 20,
            ),
            categories(),
            SizedBox(
              height: 20,
            ),
            day_month_year(),
            SizedBox(
              height: 40,
            ),
            save_button(),
          ],
        ),
      ),
    );
  }

  Row category_selection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            _handleRadioValueChanged('Option 1');
          },
          child: Container(
            child: Radio(
              value: 'Option 1',
              groupValue: selectedRadio,
              onChanged: (value) {
                _handleRadioValueChanged(value as String);
              },
            ),
          ),
        ),
        Text(
          'Income',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        InkWell(
          onTap: () {
            _handleRadioValueChanged('Option 2');
          },
          child: Container(
            child: Radio(
              value: 'Option 2',
              groupValue: selectedRadio,
              onChanged: (value) {
                setState(() {
                  selectedRadio = value as String;
                });
              },
            ),
          ),
        ),
        Text(
          'Expense',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  GestureDetector save_button() {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          await _saveTransaction();
          // Perform any necessary action after saving, such as navigating back
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Transaction Added'),
              duration: Duration(
                seconds: 2,
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScreenMainHome()));
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            50,
          ),
          gradient: const LinearGradient(
            colors: [
              Colors.red,
              Colors.orange,
            ],
          ),
        ),
        child: const Text(
          'Save',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Container day_month_year() {
    return Container(
      alignment: Alignment.bottomLeft,
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Colors.grey,
          )),
      child: TextButton(
          onPressed: () async {
            DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2022),
                lastDate: DateTime(2100));
            if (newDate == null) return;
            setState(() {
              date = newDate;
            });
          },
          child: Text(
            'Date:${date.day}/${date.month}/${date.year}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          )),
    );
  }

  Padding explain() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Description is required';
          }
          return null;
        },
        focusNode: ex,
        controller: explain_C,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          labelText: 'Description',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade800),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                width: 2,
                color: Colors.grey,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 2,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Padding amounts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Amount is required';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        focusNode: amount,
        controller: amount_C,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          labelText: 'Amount',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade800),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                width: 2,
                color: Colors.grey,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 2,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Padding categories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade600,
            width: 1.5,
          ),
        ),
        child: DropdownButton<String>(
          value: selectedItem,
          items: selectedRadio == 'Option 1' // Check if it's Income
              ? _itemsOfIncome
                  .asMap()
                  .entries
                  .map(
                    (entry) => DropdownMenuItem(
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            child: Image.asset(incomeImages[entry.key]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      value: entry.value,
                    ),
                  )
                  .toList()
              : _itemsOfExpense // It's Expense
                  .asMap()
                  .entries
                  .map(
                    (entry) => DropdownMenuItem(
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            child: Image.asset(expenseImages[entry.key]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      value: entry.value,
                    ),
                  )
                  .toList()
            ..add(
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Add Category'),
                  ],
                ),
                value: 'Add Category',
              ),
            ),
          selectedItemBuilder: (context) {
            return selectedRadio == 'Option 1' // Check if it's Income
                ? _itemsOfIncome
                    .asMap()
                    .entries
                    .map(
                      (entry) => Row(
                        children: [
                          Container(
                            width: 42,
                            child: Image.asset(incomeImages[entry.key]),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList()
                : _itemsOfExpense // It's Expense
                    .asMap()
                    .entries
                    .map(
                      (entry) => Row(
                        children: [
                          Container(
                            width: 42,
                            child: Image.asset(expenseImages[entry.key]),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList();
          },
          hint: Text('Category'),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
          onChanged: (value) {
            setState(
              () {
                selectedItem = value!;
                if (value == 'Add Category') {
                  _showAddCategoryDialog();
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Add Category'),
          content: TextField(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                //Add New Categories
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Column backgroundContainer(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.orange,
              ],
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScreenMainHome(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey.shade100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Row(
                      children: [
                        Text(
                          'Adding',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
