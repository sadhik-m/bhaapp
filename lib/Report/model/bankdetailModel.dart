class BankDetailModel {
  String accountHolderName;
  String bankName;
  String accountNumber;
  String ifscCode;
  bool modified;
  bool saveBankDetails;

  BankDetailModel({
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.modified,
    required this.saveBankDetails,
  });

  dynamic toJson() => {
    'accountHolderName': accountHolderName,
    'bankName': bankName,
    'accountNumber': accountNumber,
    'ifscCode': ifscCode,
    'modified': modified,
    'saveBankDetails': saveBankDetails,
  };

  factory BankDetailModel.fromJson(Map<String, dynamic> json) {
    return BankDetailModel(
      accountHolderName: json['accountHolderName'],
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
      modified: json['modified'],
      saveBankDetails: json['saveBankDetails'],
    );
  }

}