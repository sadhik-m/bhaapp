import 'dart:convert';
import 'package:http/http.dart'as http;

bool isValidIFSC(String ifscCode) {
  if (ifscCode == null || ifscCode.isEmpty) {
    return false;
  }

  // IFSC code must be 11 characters long
  if (ifscCode.length != 11) {
    return false;
  }

  // IFSC code must contain only uppercase letters and numbers
  RegExp regExp = RegExp(r'^[A-Z0-9]+$');
  if (!regExp.hasMatch(ifscCode)) {
    return false;
  }

  // First four characters should be uppercase letters (bank code)
  String bankCode = ifscCode.substring(0, 4);
  RegExp bankCodeRegExp = RegExp(r'^[A-Z]{4}$');
  if (!bankCodeRegExp.hasMatch(bankCode)) {
    return false;
  }

  // Fifth character should be '0' (zero)
  if (ifscCode[4] != '0') {
    return false;
  }

  // Remaining six characters should be uppercase letters and numbers (branch code)
  String branchCode = ifscCode.substring(5);
  RegExp branchCodeRegExp = RegExp(r'^[A-Z0-9]{6}$');
  if (!branchCodeRegExp.hasMatch(branchCode)) {
    return false;
  }

  return true;
}
Future<String?> fetchBankDetailsFromIFSC(String ifscCode) async {
  if (ifscCode.isEmpty) {
    return null;
  }

  final url = Uri.parse('https://ifsc.razorpay.com/$ifscCode');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return responseData['BANK'];
  } else {
    return null;
  }
}

bool isValidIndianBankAccountNumber(String accountNumber) {
  // Account number should consist of only numeric digits
  if (!RegExp(r'^\d+$').hasMatch(accountNumber)) {
    return false;
  }

  // Account number should be between 6 and 16 digits (a common range for Indian bank account numbers)
  if (accountNumber.length < 6 || accountNumber.length > 16) {
    return false;
  }

  return true;
}