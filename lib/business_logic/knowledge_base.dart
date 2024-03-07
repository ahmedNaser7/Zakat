import 'package:flutter/material.dart';
import 'package:my_zakat/database_utils.dart';
import 'package:my_zakat/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../base.dart';
import 'knowledge_view_model.dart';
import 'navigator.dart';
import '../login/login_screen.dart';

// class KnowledgeBase extends StatefulWidget {
//   static const String routeName = 'home';
//   var Zakat_Total = 0;
//   @override
//   State<KnowledgeBase> createState() => _KnowledgeBaseState();
// }

// class _KnowledgeBaseState extends BaseState<KnowledgeBase, KnowledgeViewModel>
//     implements HomeNavigator {
//   @override
//   KnowledgeViewModel initViewModel() => KnowledgeViewModel();

//   @override
//   void initState() {
//     super.initState();
//     viewModel.navigator = this;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Zakat Calculator'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Welcome to Zakat Calculator App!',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ZakatCalculatorScreen()),
//                 );
//               },
//               child: Text('Calculate Zakat'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Zakat Calculator'),
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
    );
  }

  void calculateZakat() async {
    // Remove keyboard focus
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

    UserProvider currentUser = UserProvider();
    if (currentUser.user != null) {
      DataBaseUtils.updateTotalZakat(currentUser.user!.id, totalzakatAmount);
    }
  }
  // void _showDetailsDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: SingleChildScrollView(
  //           child: Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 ListTile(
  //                   title: Text('Featured Content Details'),
  //                   subtitle:
  //                       Text('More information about the featured content'),
  //                 ),
  //                 Divider(),
  //                 Image.network(
  //                   'https://i.pinimg.com/736x/17/7c/04/177c04215ece52f9d341aaaa878bd347.jpg',
  //                   height: 200,
  //                   width: 200,
  //                   fit: BoxFit.cover,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(16.0),
  //                   child: Text(
  //                     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  //                     style: TextStyle(fontSize: 16),
  //                   ),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop(); // Close the dialog
  //                   },
  //                   child: Text('Close'),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
