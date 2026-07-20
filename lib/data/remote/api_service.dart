// import 'dart:convert';
// import 'package:expenses4/core/my_own_enums/enums.dart';
// import 'package:expenses4/data/models/Dept.dart';
// import 'package:expenses4/data/models/Payment.dart';
// import 'package:expenses4/data/models/person.dart';
// import 'package:expenses4/data/models/transaction.dart';
// import 'package:http/http.dart' as http;

// class clsApiService {
//   static const String _baseUrl = 'http://192.168.0.196:5036/api';

//   static Future<int?> postUser(
//     String googleID,
//     String email,
//     String? name,
//   ) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$_baseUrl/Users'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'id': 0,
//           'googleID': googleID,
//           'email': email,
//           'name': name,
//         }),
//       );
//       if (response.statusCode < 205) {
//         return int.parse(jsonDecode(response.body)['id'].toString());
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future<enStatusResponse> postPerson(
//     clsPerson person,
//     int currentUserID,
//   ) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$_baseUrl/People/'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'id': person.id,
//           'userID': currentUserID,
//           'fullname': person.fullname,
//           'phone': person.phone,
//           'imagePath': person.imagepath,
//           'updateAt': person.updateAt,
//         }),
//       );
//       if (response.statusCode < 299) {
//         return enStatusResponse.Ok;
//       }
//       if (response.statusCode == 404) {
//         return enStatusResponse.NotFound;
//       }

//       if (response.statusCode == 400) {
//         return enStatusResponse.BadRequest;
//       }

//       if (response.statusCode > 499) {
//         return enStatusResponse.ServerError;
//       }
//       return enStatusResponse.localError;
//     } catch (e) {
//       print("++++++++++++++++++++++++++++++++++++++++++++++");
//       print(e);
//       return enStatusResponse.localError;
//     }
//   }

//   static Future<enStatusResponse> postDebt(
//     clsDebt debt,
//     int currentUserID,
//   ) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$_baseUrl/Debts/'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "id": debt.id,
//           "personID": debt.personID,
//           "userID": currentUserID,
//           "amount": debt.amount,
//           "paidAmount": debt.paidAmount,
//           "isSettled": debt.isSettled,
//           "isPaidToMe": debt.isPaidToMe,
//           "date": debt.date,
//           "note": debt.note,
//           "updateAt": debt.updatedAt,
//         }),
//       );
//       if (response.statusCode < 299) {
//         return enStatusResponse.Ok;
//       }
//       if (response.statusCode == 404) {
//         return enStatusResponse.NotFound;
//       }

//       if (response.statusCode == 400) {
//         return enStatusResponse.BadRequest;
//       }

//       if (response.statusCode > 499) {
//         return enStatusResponse.ServerError;
//       }
//       return enStatusResponse.localError;
//     } catch (e) {
//       print("++++++++++++++++++++++++++++++++++++++++++++++");
//       print(e.toString());
//       return enStatusResponse.localError;
//     }
//   }

//   static Future<enStatusResponse> postPayment(
//     clsPayment payment,
//     int currentUserID,
//   ) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$_baseUrl/Payments/'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "id": payment.id,
//           "debtID": payment.debtID,
//           "userID": currentUserID,
//           "date": payment.date,
//           "amount": payment.amount,
//           "updateAt": payment.updatedAt,
//         }),
//       );
//       if (response.statusCode < 299) {
//         return enStatusResponse.Ok;
//       }
//       if (response.statusCode == 404) {
//         return enStatusResponse.NotFound;
//       }

//       if (response.statusCode == 400) {
//         return enStatusResponse.BadRequest;
//       }

//       if (response.statusCode > 499) {
//         return enStatusResponse.ServerError;
//       }
//       return enStatusResponse.localError;
//     } catch (e) {
//       print("++++++++++++++++++++++++++++++++++++++++++++++");
//       print(e.toString());
//       return enStatusResponse.localError;
//     }
//   }

//   static Future<enStatusResponse> postTransacion(
//     ClsTransaction transaction,
//     int currentUserID,
//   ) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$_baseUrl/Transactions/'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'id': transaction.id,
//           'debtID': transaction.debtID,
//           'paymentID': transaction.paymentID,
//           'date': transaction.date,
//           'amount': transaction.amount,
//           'updateAt': transaction.updateAt,
//         }),
//       );
//       if (response.statusCode < 299) {
//         return enStatusResponse.Ok;
//       }
//       if (response.statusCode == 404) {
//         return enStatusResponse.NotFound;
//       }

//       if (response.statusCode == 400) {
//         return enStatusResponse.BadRequest;
//       }

//       if (response.statusCode > 499) {
//         return enStatusResponse.ServerError;
//       }

//       return enStatusResponse.localError;
//     } catch (e) {
//       print("++++++++++++++++++++++++++++++++++++++++++++++");
//       print(e.toString());
//       return enStatusResponse.localError;
//     }
//   }

//   //Get Data

//   static Future<int?> getUserByEmail(String email) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$_baseUrl/Users/FindByEmail/$email'),
//         headers: {'Content-Type': 'application/json'},
//       );
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body)['id'];
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future<List> getAllDebts(int userID) async {
//     try {
//       final response = await http.get(Uri.parse('$_baseUrl/Debts/All/$userID'));
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       }
//       return [];
//     } catch (e) {
//       print("-----------------------------------$e");

//       return [];
//     }
//   }

//   static Future<List> getAllPeople(int userID) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$_baseUrl/People/All/$userID'),
//       );
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       }
//       return [];
//     } catch (e) {
//       print("-----------------------------------$e");
//       return [];
//     }
//   }

//   static Future<List> getAllPayments(int userID) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$_baseUrl/Payments/All/$userID'),
//       );
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       }
//       return [];
//     } catch (e) {
//       print("-----------------------------------$e");

//       return [];
//     }
//   }

//   static Future<List> getAllTransacions(int userID) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$_baseUrl/Transactions/All/$userID'),
//       );
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       }
//       return [];
//     } catch (e) {
//       print("-----------------------------------$e");

//       return [];
//     }
//   }

//   // Delete Data

//   static Future<enStatusResponse> deleteTransactions(
//     String transactionID,
//     int userID,
//   ) async {
//     // if (jsonDecode(response.body)['result'] == 0) return enStatusResponse.NotFound;
//     try {
//       final response = await http.delete(
//         Uri.parse('$_baseUrl/Transactions/$transactionID/$userID'),
//       );
//       if (response.statusCode < 299) {
//         return enStatusResponse.Ok;
//       }
//       if (response.statusCode == 404) {
//         return enStatusResponse.NotFound;
//       }

//       if (response.statusCode == 400) {
//         return enStatusResponse.BadRequest;
//       }

//       if (response.statusCode > 499) {
//         return enStatusResponse.ServerError;
//       }
//       return enStatusResponse.localError;
//     } catch (e) {
//       print("++++++++++++++++++++++++++++++++++++++++++++++");
//       print(e.toString());
//       return enStatusResponse.localError;
//     }
//   }

//   static Future<enStatusResponse> deletePayments(
//     String paymentID,
//     int userID,
//   ) async {
//     try {
//       final response = await http.delete(
//         Uri.parse('$_baseUrl/Payments/$paymentID/$userID'),
//       );
//       if (response.statusCode < 299) {
//         return enStatusResponse.Ok;
//       }
//       if (response.statusCode == 404) {
//         return enStatusResponse.NotFound;
//       }

//       if (response.statusCode == 400) {
//         return enStatusResponse.BadRequest;
//       }

//       if (response.statusCode > 499) {
//         return enStatusResponse.ServerError;
//       }
//       return enStatusResponse.localError;
//     } catch (e) {
//       print("++++++++++++++++++++++++++++++++++++++++++++++");
//       print(e.toString());
//       return enStatusResponse.localError;
//     }
//   }

//   static Future<enStatusResponse> deleteDebts(String debtID, int userID) async {
//     // if (jsonDecode(response.body)['result'] == 0) return enStatusResponse.NotFound;
//     try {
//       final response = await http.delete(
//         Uri.parse('$_baseUrl/Debts/$debtID/$userID'),
//       );
//       if (response.statusCode < 299) {
//         return enStatusResponse.Ok;
//       }
//       if (response.statusCode == 404) {
//         return enStatusResponse.NotFound;
//       }

//       if (response.statusCode == 400) {
//         return enStatusResponse.BadRequest;
//       }

//       if (response.statusCode > 499) {
//         return enStatusResponse.ServerError;
//       }
//       return enStatusResponse.localError;
//     } catch (e) {
//       print("++++++++++++++++++++++++++++++++++++++++++++++");
//       print(e.toString());
//       return enStatusResponse.localError;
//     }
//   }

//   static Future<enStatusResponse> deletePeople(
//     String personID,
//     int userID,
//   ) async {
//     // if (jsonDecode(response.body)['result'] == 0) return enStatusResponse.NotFound;
//     try {
//       final response = await http.delete(
//         Uri.parse('$_baseUrl/People/$personID/$userID'),
//         headers: {'Content-Type': 'application/json'},
//       );
//       if (response.statusCode < 299) {
//         return enStatusResponse.Ok;
//       }
//       if (response.statusCode == 404) {
//         return enStatusResponse.NotFound;
//       }

//       if (response.statusCode == 400) {
//         return enStatusResponse.BadRequest;
//       }

//       if (response.statusCode > 499) {
//         return enStatusResponse.ServerError;
//       }
//       return enStatusResponse.localError;
//     } catch (e) {
//       print("++++++++++++++++++++++++++++++++++++++++++++++");
//       print(e.toString());
//       return enStatusResponse.localError;
//     }
//   }
// }
