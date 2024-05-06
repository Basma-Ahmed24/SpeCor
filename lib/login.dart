import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:specor/firebase/auth.dart';
import 'package:specor/home.dart';
import 'package:specor/reg.dart';
import 'package:get/get.dart';
import 'package:specor/specor_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'const.dart';
class Login extends StatefulWidget{
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  TextEditingController email=TextEditingController();
  TextEditingController pass=TextEditingController();
  bool isLoading = false;

  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     appBar: AppBar(
       title: Text("Login"),
       backgroundColor: Colors.black87,centerTitle: true,
     ),
     body: Container(
       color: Colors.black,
       child: Column
         (
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Padding(padding: EdgeInsets.all(8),
             child: TextFormField
               (
controller: email,
               style: TextStyle(color: Colors.white),
               cursorColor: Colors.black,
               decoration: InputDecoration(
                 hintText: "email",
                 hintStyle: TextStyle(color: Colors.grey),
                 focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                   borderSide: BorderSide(color: Colors.black87)
                 ),
                 enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                   borderSide: BorderSide(color: Colors.grey)
                 ),
                 fillColor: Colors.grey.shade800,
                 filled: true
               ),
             ),
           ),
           SizedBox(height: 10.h,),
           Padding(padding: EdgeInsets.all(8),
             child: TextFormField
               (
               controller: pass,
               style: TextStyle(color: Colors.white),
               cursorColor: Colors.black,
               decoration: InputDecoration(
                   hintText: "password",
                   hintStyle: TextStyle(color: Colors.grey),
                   focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                       borderSide: BorderSide(color: Colors.black87)
                   ),
                   enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                       borderSide: BorderSide(color: Colors.grey)
                   ),
                   fillColor: Colors.grey.shade800,
                   filled: true
               ),
             ),
           ),
           InkWell(onTap: (){
             if (email.text.isNotEmpty && pass.text.isNotEmpty) {
               setState(() {
                 isLoading = true;
               });

               logIn(email.text, pass.text).then((user) {
                 if (user != null) {
                   print("Login Sucessfull");
                   setState(() {
                     isLoading = false;
                   });
                   Navigator.push(
                       context, MaterialPageRoute(builder: (_) => Home()));
                 } else {
                   print("Login Failed");
                   setState(() {
                     isLoading = false;
                   });
                 }
               });
             } else {
               print("Please fill form correctly");
             }
           // auth.login(email.text, pass.text);
               //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));


             // else{
             //   Fluttertoast.showToast(msg: "User not found",
             //       toastLength: Toast.LENGTH_LONG,
             //       gravity: ToastGravity.BOTTOM,
             //       timeInSecForIosWeb: 1,
             //       backgroundColor: Colors.redAccent,
             //       textColor: Colors.white,
             //       fontSize: 14.sp);
             //
             //
             // }

           },
           child: Container(

            decoration: BoxDecoration(
             border: Border.all(color: Colors.grey.shade800),
              borderRadius: BorderRadius.circular(15)
            ),
             padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
             child:isLoading
                 ? Center(
               child: Container(

                 child: CircularProgressIndicator(),
               ),
             )
                 :  Text('Login',style: TextStyle(color: Colors.white),),
           ),
           ),
           SizedBox(height: 10.h,),
           InkWell(onTap: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Register()));

             },
             child: Container(

               decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey.shade800),
                   borderRadius: BorderRadius.circular(15)
               ),
               padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
               child: Text('Register',style: TextStyle(color: Colors.white),),
             ),
           )
         ],
       )
     ),
   );
  }
}