import 'package:bhaapp/order/my_orders_screen.dart';
import 'package:bhaapp/profile/widget/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/constants/colors.dart';
import '../common/widgets/appBar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar("My Profile",
            [Padding(
              padding: const EdgeInsets.only(right:18.0),
              child: Center(
                child: Text('Edit Profile',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: splashBlue,
                      fontSize: 12
                  ),),
              ),
            )],false),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.08
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight*0.02,),
                Container(
                  height: 88,
                    width: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black
                  ),
                  child: Center(
                    child: Icon(Icons.person,color: Colors.white,size: 30,),
                  ),
                ),
                SizedBox(height: screenHeight*0.02,),
                Text('Kaushik Chandraskhar',style:
                  GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xff030303)
                  ),),
                SizedBox(height: screenHeight*0.01,),
                Text('kaushik007@gmail.com',style:
                GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xff030303)
                ),),
                SizedBox(height: screenHeight*0.03,),
                profileTile(
                  'My Orders',
                    (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderScreen(show_back: true,)));
                    }
                ),
                SizedBox(height: screenHeight*0.01,),
                profileTile(
                    'My Wishlists',
                        (){
                    }
                ),
                SizedBox(height: screenHeight*0.01,),
                profileTile(
                    'My Addresses',
                        (){
                      Navigator.pushNamed(context, '/change_address');
                    }
                ),
                SizedBox(height: screenHeight*0.01,),
                profileTile(
                    'Payment Methods',
                        (){
                          Navigator.pushNamed(context, '/change_payment');
                    }
                ),
                SizedBox(height: screenHeight*0.01,),
                profileTile(
                    'Notifications',
                        (){
                    }
                ),
              ],
            ),
          ),
        )
    );
  }
}
