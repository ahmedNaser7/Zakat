import 'package:flutter/material.dart';
import 'package:my_zakat/database_utils.dart';
import 'package:my_zakat/home/home_screen.dart';
import 'package:provider/provider.dart';
import '../provider/my_user.dart';
import '../provider/user_provider.dart';

class ZakatCalculatorScreen extends StatefulWidget {
  @override
  _ZakatCalculatorScreenState createState() => _ZakatCalculatorScreenState();
}

class _ZakatCalculatorScreenState extends State<ZakatCalculatorScreen> {
  TextEditingController cashController = TextEditingController();
  TextEditingController goldWeightController = TextEditingController();
  TextEditingController goldPriceController = TextEditingController();
  TextEditingController silverWeightController = TextEditingController();
  TextEditingController silverPriceController = TextEditingController();
  TextEditingController inventoryController = TextEditingController();
  TextEditingController investmentsController = TextEditingController();
  TextEditingController debtsController = TextEditingController();

  double totalzakatAmount = 0.0;
  double cashzakatAmount = 0.0;
  double silverzakatAmount = 0.0;
  double goldzakatAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      return false;
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text('Zakat Calculator'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: goldPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Gold Price per Gram'),
              ),
              TextFormField(
                controller: silverPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Silver Price per Gram'),
              ),
              TextFormField(
                controller: cashController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Cash on hand'),
              ),
              TextFormField(
                controller: goldWeightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Gold (in grams)'),
              ),
              TextFormField(
                controller: silverWeightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Silver (in grams)'),
              ),
              TextFormField(
                controller: inventoryController,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: 'Business inventory value'),
              ),
              TextFormField(
                controller: investmentsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Investments value'),
              ),
              TextFormField(
                controller: debtsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Total debts'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  calculateZakat();
                },
                child: Text('Calculate'),
              ),
              SizedBox(height: 20),
              Text(
                  'Zakat Amount for cash: ${cashzakatAmount.toStringAsFixed(2)} EGP'),
              Text(
                  'Zakat Amount for Gold: ${goldzakatAmount.toStringAsFixed(2)} EGP'),
              Text(
                  'Zakat Amount for Silver: ${silverzakatAmount.toStringAsFixed(2)} EGP'),
              Text(
                  'Total Zakat Amount: ${totalzakatAmount.toStringAsFixed(2)} EGP'),
            ],
          ),
        ),
      ),
    )
    );

  }

  void calculateZakat() async {
    FocusScope.of(context).unfocus();

    double goldWeight = double.tryParse(goldWeightController.text) ?? 0.0;
    double goldPrice = double.tryParse(goldPriceController.text) ?? 0.0;
    double silverWeight = double.tryParse(silverWeightController.text) ?? 0.0;
    double silverPrice = double.tryParse(silverPriceController.text) ?? 0.0;
    double cash = double.tryParse(cashController.text) ?? 0.0;
    double inventory = double.tryParse(inventoryController.text) ?? 0.0;
    double investments = double.tryParse(investmentsController.text) ?? 0.0;
    double debts = double.tryParse(debtsController.text) ?? 0.0;

    // Check if gold price is provided
    if (goldPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter valid gold price.'),
      ));
      return;
    }
    // Check if cash value is provided
    if (cashController.text.isEmpty &&
        goldWeightController.text.isEmpty &&
        silverWeightController.text.isEmpty &&
        inventoryController.text.isEmpty &&
        investmentsController.text.isEmpty &&
        debtsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill the text field to calculate zakat'),
      ));
      return; // Exit the function
    }

    // Check if gold weight is less than 85 grams
    if (goldWeight < 85 && goldWeight != 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gold weight must be more than 85 grams'),
      ));
      return; // Exit the function
    }

    // Calculate the total value of gold and silver assets
    double goldValue = goldWeight * goldPrice;
    double silverValue = silverWeight * silverPrice;

    // Check if silver weight is more than 595 grams
    if (silverWeight < 595 && silverWeight != 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Silver weight must be more than 595 grams'),
      ));
      return; // Exit the function
    }

    if (silverPrice == 0 && silverWeight != 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('please enter silver price'),
      ));
      return; // Exit the function
    }

    // Calculate total cash
    double totalCash = cash + investments + inventory - debts;

    // Check if the weight of cash in gold is greater than 85 grams
    double cashInGold = totalCash / goldPrice;
    if (cashInGold >= 85 || cashInGold == 0) {
      cashzakatAmount = cashInGold * 0.025 * goldPrice;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Cash equivalent in gold must be more than 85 grams.'),
      ));
      return; // Exit the function
    }

    // Calculate total assets
    double totalAssets =
        totalCash + goldValue + silverValue + inventory + investments;

    // Deduct debts
    double zakatableAssets = totalAssets - debts;

    // Calculate Zakat amount (2.5% of zakatable assets)
    goldzakatAmount = goldValue * 0.025;
    silverzakatAmount = silverValue * 0.025;
    totalzakatAmount = goldzakatAmount + silverzakatAmount + cashzakatAmount;

    setState(() {
      totalzakatAmount = totalzakatAmount;
      cashzakatAmount = cashzakatAmount;
      goldzakatAmount = goldzakatAmount;
      silverzakatAmount = silverzakatAmount;
    });

    // Update total_zakat
    MyUser? currentUser = Provider.of<UserProvider>(context, listen: false).user;
    if (currentUser != null) {
      double updatedTotalZakat = totalzakatAmount;
      currentUser.total_zakat = updatedTotalZakat;
      await DataBaseUtils.updateUser(currentUser);
      Provider.of<UserProvider>(context, listen: false).user = currentUser;

    }
  }
}
