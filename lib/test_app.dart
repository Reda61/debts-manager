import 'dart:convert';

import 'package:expenses4/data/local/local_data_access/payments_data.dart';
import 'package:expenses4/data/models/transaction.dart';
import 'package:expenses4/logic/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart' show ReadContext;

class clsTry extends StatefulWidget {
  clsTry({super.key});

  @override
  State<clsTry> createState() => _clsTryState();
}

class _clsTryState extends State<clsTry> {
  final bool isSelected = true;
  static const String _baseUrl = 'http://192.168.0.196:5036/api';

  static Future<List> getAllTransacions(int userID) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/Transactions/All/$userID'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List> getAllPayments(int userID) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/Payments/All/$userID'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Try')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            color: Colors.red,
            onPressed: () async {
              ClsTransaction trans = ClsTransaction.empty();
              trans = context.read<ClsTransactionProvider>().transaction;

              // trans.paymentID = _newPayment.id!;
              // trans.debtID = _newPayment.debtID;
              // trans.amount = _newPayment.amount;
              // trans.date = _newPayment.date;

              String transactionSaveResult = await context
                  .read<ClsTransactionProvider>()
                  .save();
            },
          ),
        ],
      ),
    );
  }
}

Future<void> testfu() async {
  await Future.delayed(Duration(seconds: 3));
}

        // child: Wrap(
        //   spacing: 10,
        //   runSpacing: 10,
        //   children: _languages.map((lang) {
        //     final isSelected = lang['code'] == _selected;
        //     return ChoiceChip(
        //       label: Text(lang['label']!),
        //       padding: EdgeInsets.all(25),
        //       selected: isSelected,
        //       onSelected: (_) => setState(() => _selected = lang['code']!),
        //       selectedColor: Color(0xFFEEEDFE),
        //       labelStyle: TextStyle(
        //         color: isSelected ? Color(0xFF534AB7) : null,
        //       ),
        //       side: BorderSide(
        //         color: isSelected ? Color(0xFF534AB7) : Colors.grey.shade300,
        //       ),
        //     );
        //   }).toList(),
        // ),
//  ChoiceChip(
//           label: Text('Choice 1'),
//           padding: EdgeInsets.all(25),
//           selected: true,
//           // onSelected: (_) =>
//           // setState(() => _selected = lang['code']!),
//           selectedColor: Color(0xFFEEEDFE),
//           labelStyle: TextStyle(color: isSelected ? Color(0xFF534AB7) : null),
//           side: BorderSide(
//             color: isSelected ? Color(0xFF534AB7) : Colors.grey.shade300,
//           ),
//         ),
