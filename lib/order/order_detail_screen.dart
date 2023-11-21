import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/order/model/orderStatusModel.dart';
import 'package:bhaapp/order/widget/order_detail_product_tile.dart';
import 'package:bhaapp/order/widget/order_tracker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cart/service/send_notification.dart';
import '../common/widgets/appBar.dart';
import '../common/widgets/loading_indicator.dart';
import '../home/service/rateVendor.dart';

class OrderDetail extends StatefulWidget {
  String orderid;
  String shopName;
  List<String> sku = [];
  List<String> quqntity = [];
  String shopContact;
  String orderStatus;
  String orderStatusDate;
  String deliveryAddress;
  String deliveryTime;
  String orderTotal;
  OrderDetail({
    Key? key,
    required this.orderid,
    required this.shopName,
    required this.sku,
    required this.quqntity,
    required this.shopContact,
    required this.orderStatus,
    required this.orderStatusDate,
    required this.deliveryAddress,
    required this.deliveryTime,
    required this.orderTotal,
  }) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  bool loaded = false;
  int label = 0;
  int otpCode = 0;
  String pickupPoint = '';
  List<OrderStatusModel> satatusList = [];
  getStatusList() async {
    print(widget.orderid);
    String stsList = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderid)
        .get()
        .then((value) {
      return value['DeliveryStatus'].toString();
    });
    setState(() {
      var convert = json.decode(stsList);
      print(convert);
      print(convert[0]['name']);
      for (var i = 0; i < convert.length; i++) {
        satatusList.add(OrderStatusModel(
            name: convert[i]['name'],
            status: convert[i]['status'],
            date: convert[i]['date'],
            image: convert[i]['image']));
      }
    });

    /* await FirebaseFirestore.instance.collection('orders').doc(widget.orderid).collection('DeliveryStatus').get().then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        setState(() {
          satatusList.add(OrderStatusModel(name: doc['name'], status: doc['status'], date: doc['date']));
        });
      });
    });*/
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getStatusList();
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(
            "Order Details",
            [
              /*Padding(
            padding: const EdgeInsets.only(right:18.0),
            child: Row(
              children: [

                Image.asset('assets/home/search.png',
                  height: 24,color: Colors.black,),
              ],
            ),
          )*/
            ],
            true),
        body: //loaded?
            RefreshIndicator(
          onRefresh: _pullRefresh,
          child: Container(
            height: screenHeight,
            width: screenWidth,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('orderId', isEqualTo: widget.orderid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return SizedBox.shrink();
                }

                /* if (snapshot.data!.docs.isEmpty) {
                return SizedBox();
              }*/
                if (snapshot.hasData) {
                  satatusList.clear();
                  label = snapshot.data!.docs[0]['label'];
                  otpCode = snapshot.data!.docs[0]['otpCode'];
                  pickupPoint = snapshot.data!.docs[0]['pickupPoint'];
                  String stsList =
                      snapshot.data!.docs[0]['DeliveryStatus'].toString();
                  var convert = json.decode(stsList);
                  print(convert);
                  print(convert[0]['name']);
                  for (var item in convert) {
                    satatusList.add(OrderStatusModel(
                        name: item['name'],
                        status: item['status'],
                        date: item['date'],
                        image: item['image']));
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: screenWidth,
                                //height: screenHeight*0.065,
                                color: splashBlue.withOpacity(0.1),
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05,
                                    vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Order ID : ',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        Expanded(
                                          child: Text(
                                            widget.orderid,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: splashBlue),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Shop : ',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        Expanded(
                                          child: Text(
                                            widget.shopName,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: splashBlue),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Label : ',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        Expanded(
                                          child: Text(
                                            label == 0
                                                ? 'No Label'
                                                : label.toString(),
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: splashBlue),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: otpCode == 0
                                                        ? const Text(
                                                            'No OTP code')
                                                        : Text('${otpCode}'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          // Close the AlertDialog
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Show OTP'))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.03,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.07,
                                ),
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      itemCount: widget.sku.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return orderDetailProductListTile(
                                            screenWidth,
                                            screenHeight,
                                            widget.sku[index],
                                            widget.quqntity[index],
                                            index + 1);
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: Colors.black
                                                  .withOpacity(0.8)),
                                        ),
                                        Text(
                                          '₹${widget.orderTotal}',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: Colors.black
                                                  .withOpacity(0.8)),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Expected Delivery Time',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                              color: Colors.black
                                                  .withOpacity(0.8)),
                                        ),
                                        Expanded(
                                          child: Text(
                                            widget.deliveryTime,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                color: Colors.black
                                                    .withOpacity(0.8)),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    deliveringLocation(),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Tracking Details',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black
                                                  .withOpacity(0.8)),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            launchUrl(Uri(
                                              scheme: 'tel',
                                              path: widget.shopContact,
                                            ));
                                          },
                                          child: Container(
                                            width: 56,
                                            height: 19.6,
                                            color: Color(0xff28B446)
                                                .withOpacity(0.2),
                                            child: Center(
                                              child: Text(
                                                'Call',
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10,
                                                    color: Color(0xff28B446)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    snapshot.data!.docs[0]['status']
                                                .toLowerCase() ==
                                            'order cancelled'
                                        ? Text(
                                            "Order Cancelled",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red),
                                          )
                                        : OrderTracker(
                                            orderStatus: snapshot.data!.docs[0]
                                                ['status'],
                                            orderStatusDate: snapshot
                                                .data!.docs[0]['txTime'],
                                            statusList: satatusList,
                                            orderId: widget.orderid,
                                            reportedStatusList: [],
                                          )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      /*satatusList[1].status == false
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.07,
                                  vertical: screenHeight * 0.01),
                              child: blackButton("Cancel Order", () {
                                showCancelDialog(context);
                              }, screenWidth, screenHeight * 0.05),
                            )
                          : SizedBox.shrink(),*/
                      /*  if (satatusList[satatusList.length - 2].status == true &&
                          satatusList[satatusList.length - 1].status == false)
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.07,
                                  vertical: screenHeight * 0.01),
                              child: blackButton("Confirm the Delivery", () {
                                showDeliveredDialog(context);
                              }, screenWidth, screenHeight * 0.05),
                            ),
                          ],
                        )*/
                    ],
                  );
                }
                return Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Center(child: Text('Loading!...')),
                );
              },
            ),
          ),
        )
        //:Center(child: Text("Loading..."),),
        );
  }

  Widget deliveringLocation() {
    return (pickupPoint == '')
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Address',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.black.withOpacity(0.8)),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.deliveryAddress,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.8)),
                textAlign: TextAlign.left,
              ),
            ],
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivering Pickup Point',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.black.withOpacity(0.8)),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                pickupPoint,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.8)),
                textAlign: TextAlign.left,
              ),
            ],
          );
  }

  cancelOrder() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderid)
        .set(
      {'status': 'Order Cancelled'},
      SetOptions(merge: true),
    ).then((value) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Order cancelled successfully');
    });
  }

  showCancelDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        cancelOrder();
      },
    );
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Text("Are you sure,you want to cancell this order?"),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDeliveredDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        showAddImageDialog(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Text("Are you sure,you recieved this order?"),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAddImageDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        showAddImageUploadDialog(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
        recievedOrder();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: const Text("Do you want to add image of the received product?"),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAddImageUploadDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("Confirm"),
      onPressed: () {
        Navigator.of(context).pop();
        recievedOrder();
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
        recievedOrder();
      },
    );

    // set up the AlertDialog

    // show the dialog
    Timer? timer;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        File? image_new;

        return StatefulBuilder(
          builder: (context, setState) {
            timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              setState(() {
                image_new = _image!;
              });
            });
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              title: const Text("Upload Image"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  image_new != null
                      ? Image.file(File(image_new!.path))
                      : SizedBox.shrink(),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.07,
                          vertical: MediaQuery.of(context).size.height * 0.01),
                      child: InkWell(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: Center(
                            child: Text(
                              satatusList[satatusList.length - 1].image.isEmpty
                                  ? 'Choose Image'
                                  : 'Change Image',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              actions: [cancelButton, okButton],
            );
          },
        );
      },
    ).then((value) {
      timer!.cancel();
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
    /*  StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('sightings/${Path.basename(_image.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;*/
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
      // setState(() {
      returnURL = fileURL;
      satatusList[satatusList.length - 1].image = returnURL;
      String encoded = jsonEncode(satatusList);
      print(encoded);
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderid)
          .set(
        {'DeliveryStatus': encoded},
        SetOptions(merge: true),
      ).then((value) {
        // Navigator.of(context).pop();
        //Fluttertoast.showToast(msg: 'Order recieved successfully');
      });
      Navigator.of(context).pop();
      // });
    });
  }

  recievedOrder() async {
    showLoadingIndicator(context);

    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderid)
        .set(
      {'status': '${satatusList[satatusList.length - 1].name}'},
      SetOptions(merge: true),
    ).then((value) async {
      for (var i = 0; i < satatusList.length; i++) {
        //setState(() {
        satatusList[i].status = true;
        // });

        if (i == satatusList.length - 1) {
          // setState(() {
          satatusList[i].date = DateTime.now().toString();
          satatusList[i].image = returnURL;
          //});
        }
      }
      String encoded = jsonEncode(satatusList);
      print(encoded);
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderid)
          .set(
        {'DeliveryStatus': encoded},
        SetOptions(merge: true),
      ).then((value) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: 'Order received successfully');
        sendNotificationToAdmin(
            "Order ${widget.orderid} received by customer at ${DateTime.now().toString()}",
            "Order Completed");
        sendNotificationToDriver(
            "Order ${widget.orderid} received by customer at ${DateTime.now().toString()}",
            "Order Completed",
            widget.orderid);

        showRatingDialog(context);
        //Navigator.of(context).pop();
      });
    });
  }

  showRatingDialog(BuildContext context) {
    String comment = '';
    String vendorRating = '';
    // set up the button
    Widget okButton = TextButton(
      child: Text("Rate Now"),
      onPressed: () {
        if (vendorRating == '') {
          Fluttertoast.showToast(msg: 'choose a rating');
        } else {
          RateVendor().addRating(context, vendorRating, comment);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Not Now"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        print(comment);
        print(vendorRating);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Text("Rate Vendor"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: MediaQuery.of(context).size.height * 0.042,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                vendorRating = rating.toString();
              });
              print(rating);
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          TextField(
            onChanged: (v) {
              setState(() {
                comment = v;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              hintText: 'Comments if any',
            ),
          ),
        ],
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
