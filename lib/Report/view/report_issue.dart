import 'dart:convert';
import 'dart:io';

import 'package:bhaapp/Report/model/bankdetailModel.dart';
import 'package:bhaapp/Report/services/reportIssueService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utilities/utilities.dart';
import '../../common/widgets/appBar.dart';
import '../../common/widgets/black_button.dart';
import '../../common/widgets/loading_indicator.dart';

class ReportIssueScreen extends StatefulWidget {
  String orderid;
   ReportIssueScreen({Key? key,required this.orderid}) : super(key: key);

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIssueList();
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar("Report an Issue",
          [],true),
      body:loaded?
       Column(
         children: [
           Expanded(
             child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth*0.07,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    Text('Issue (required)',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.8)
                      ),),
                    SizedBox(height: 5,),
                    DropdownButton(
                      padding: EdgeInsets.zero,
                      isExpanded: true,
                      hint: Text('Choose an Issue'),
                      value: selectedIssue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: issueList.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedIssue = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 15,),
                    Text('Add Image (optional)',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.8)
                      ),),
                    SizedBox(height: 15,),
                    _image==null?
                    InkWell(
                      onTap: (){
                        _showPicker(context);
                      },
                      child: Container(
                        height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        border: Border.all(color: Colors.black)
                      ),
                      child: Center(child: Icon(Icons.add),),),
                    ):
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 160,
                          width: 160,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              border: Border.all(color: Colors.black),
                            image: DecorationImage(image: FileImage(File(_image!.path)),
                            fit: BoxFit.cover)
                          ),
                         ),
                        InkWell(
                            onTap: (){
                              setState(() {
                                _image=null;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black
                                ),
                                child: Icon(Icons.close_outlined,color: Colors.white,)))
                      ],
                    ),
                    SizedBox(height: 15,),
                    Text('Notes (optional)',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.8)
                      ),),
                    SizedBox(height: 15,),
                    TextField(
                      maxLines: 6,
                      controller: notesController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(

                        )
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text('Bank Details (required)',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.8)
                      ),),
                    SizedBox(height: 15,),
                    TextField(
                      controller: accountHolderNameController,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                      ],
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Account Holder Name'
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: ifscCodeController,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                      ],
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'IFSC Code',
                        counterText: ''
                      ),
                      maxLength: 11,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      autovalidateMode:
                      AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter IFSC Code';
                        }
                        if ((value != null) && value.isNotEmpty) {
                          bool isValid = isValidIFSC(value);
                          if (isValid == false) {
                            return 'Invalid IFSC code';
                          } else {
                            fetchBankDetailsFromIFSC(value).then((value) {
                              if (value != null) {
                                setState(() {
                                  bankNameController.text = value;
                                });
                              }
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      controller: bankNameController,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                      ],
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Bank Name'
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: accountNumberController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Account Number',
                          counterText: ''
                      ),
                      maxLength: 16,
                      autovalidateMode:
                      AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter bank A/C No';
                        } else if (!isValidIndianBankAccountNumber(
                            value)) {
                          return 'Invalid bank A/C No';
                        }
                      },
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: confirmAccountNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Account Number',
                        counterText: ''
                      ),
                      maxLength: 16,
                      autovalidateMode:
                      AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter bank A/C No';
                        } else if (!isValidIndianBankAccountNumber(
                            value)) {
                          return 'Invalid bank A/C No';
                        }
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,

                      title: Text("Save bank details for future refunds",style: TextStyle(
                        fontSize: 14
                      ),),
                      value: saveBankDetails,
                      onChanged: (newValue) {
                        setState(() {
                          saveBankDetails = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                    )
                  ],
                ),
              ),
      ),
           ),
           SizedBox(height: 10,),
           Padding(
             padding: EdgeInsets.symmetric(
               horizontal: screenWidth*0.07,),
             child: blackButton("Report", () {
                 reportIssue();
             }, screenWidth, screenHeight * 0.05),
           ),
           SizedBox(height: 15,),
         ],
       ):Center(child: CircularProgressIndicator(),),
    );
  }

  List<String> issueList=[];
  bool loaded=false;
  bool saveBankDetails=true;
  String ?selectedIssue;
  var notesController=TextEditingController();
  var accountHolderNameController=TextEditingController();
  var bankNameController=TextEditingController();
  var accountNumberController=TextEditingController();
  var confirmAccountNumberController=TextEditingController();
  var ifscCodeController=TextEditingController();
  getIssueList() async {
    issueList = await FirebaseFirestore.instance
        .collection('reportIssueDetails')
        .get()
        .then((value) {
      return List<String>.from(value.docs[0]['customerReasons'] ?? []);
    });
    await checkBankDataAvailable();


    setState(() {
      loaded = true;
    });
  }
  String bankname='';
  String accno='';
  String ifsccode='';
  String custname='';
  bool isModified=false;
  checkBankDataAvailable()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String uid=preferences.getString('uid')??'';
    await FirebaseFirestore.instance.collection('customers').doc(uid).get().then((value){
      if(value.exists){
        if(value.data()!.containsKey('refundBankDetails')){
          setState(() {
            BankDetailModel bankDetailModel=BankDetailModel(
                bankName: value['refundBankDetails']['bankName'],
                accountHolderName: value['refundBankDetails']['accountHolderName'],
                accountNumber: value['refundBankDetails']['accountNumber'],
                ifscCode: value['refundBankDetails']['ifscCode'],
                modified: value['refundBankDetails']['modified'],
                saveBankDetails:value['refundBankDetails']['saveBankDetails']??true
            );
            bankNameController.text=bankDetailModel.bankName;
            bankname=bankDetailModel.bankName;
            accountHolderNameController.text=bankDetailModel.accountHolderName;
            custname=bankDetailModel.accountHolderName;
            accountNumberController.text=bankDetailModel.accountNumber;
            accno=bankDetailModel.accountNumber;
            confirmAccountNumberController.text=bankDetailModel.accountNumber;
            ifscCodeController.text=bankDetailModel.ifscCode;
            ifsccode=bankDetailModel.ifscCode;
            isModified=bankDetailModel.modified;
          });
        }else{
          print('Not Available');
        }
      }
    });
  }


  File? _image; // Used only if you need a single picture

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Color(0xff2E3138),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Colors.yellow,
                      ),
                      title: new Text(
                        'Photo Library',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        getImage(true);
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Colors.yellow,
                    ),
                    title: new Text('Camera',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      getImage(false);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(bool gallery) async {
    showLoadingIndicator(context);

    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile =
      await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile =
      await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    }

    setState(() {
      if (pickedFile != null) {
        //_images.add(File(pickedFile.path));
        setState(() {
          _image = File(pickedFile!.path);
          uploadFile(_image!);
        });
        // Use if you only need a single picture
      } else {
        print('No image selected.');
        Navigator.of(context).pop();
      }
    });
  }

  String returnURL = '';
  uploadFile(File _image) async {
    await FirebaseStorage.instance
        .ref()
        .child('deliveryImage/${_image.path}')
        .putFile(_image);
    print('File Uploaded');

    await FirebaseStorage.instance
        .ref()
        .child('deliveryImage/${_image.path}')
        .getDownloadURL()
        .then((fileURL) async {
       setState(() {
      returnURL = fileURL;
      Navigator.of(context).pop();
      });
    });
  }


  reportIssue(){
    if(selectedIssue==null){
      Fluttertoast.showToast(msg: 'choose an issue!');
    }else if(accountHolderNameController.text.isEmpty){
      Fluttertoast.showToast(msg: 'enter account holder name');
    }else if(isValidIFSC(ifscCodeController.text)==false){
      Fluttertoast.showToast(msg: 'invalid IFSC Code');
    }else if(bankNameController.text.isEmpty){
      Fluttertoast.showToast(msg: 'enter bank name');
    }else if(isValidIndianBankAccountNumber(accountNumberController.text)==false){
      Fluttertoast.showToast(msg: 'invalid account number');
    }else if(isValidIndianBankAccountNumber(confirmAccountNumberController.text)==false){
      Fluttertoast.showToast(msg: 'invalid confirm account number');
    }else if(confirmAccountNumberController.text!=accountNumberController.text){
      Fluttertoast.showToast(msg: 'account number and confirm account number are not matching!');
    }else{
      if(
      accountHolderNameController.text!=custname||
          bankNameController.text!=bankname||
      ifscCodeController.text!=ifsccode||
      accountNumberController.text!=accno
      ){
        setState(() {
          isModified=true;
        });
      }else{
        isModified=false;
      }


      ReportIssueService().reportIssue(
          selectedIssue.toString(),
          returnURL,
          notesController.text,
          widget.orderid,
          BankDetailModel(
              accountHolderName: accountHolderNameController.text,
              bankName: bankNameController.text,
              accountNumber: accountNumberController.text,
              ifscCode: ifscCodeController.text,
               modified: isModified,
              saveBankDetails:saveBankDetails
          ),
          context);
    }
  }
}
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}