import 'package:flutter/material.dart';
import 'package:learn_app/core/color_constants.dart';
import 'package:learn_app/signin.dart';
import 'package:learn_app/signup.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Image(image: AssetImage('assets/images/sisan.png')),
          const SizedBox(
            height: 25,
          ),
          const Image(image: AssetImage('assets/images/mentor_slider_cw_mobile.png')),
          const SizedBox(
            height: 25,
          ),
          const Text('From The Top 1%',
          style: TextStyle(
            fontSize: 36,
           fontWeight: FontWeight.w600,

           color: Colors.white,
           fontFamily: 'Sans'),),
           const SizedBox(
            height: 8,
           ),
           const Text('"Guiding Futures, One Mentorship at a Time!"',
           style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color:Colors.grey,
            fontFamily: 'Sans'
           ),),
            const SizedBox(
            height: 45,
           ),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 120,
              vertical: 20,
            )
          ),
           child: const Text("GET STARTED")),

           const SizedBox(
            height: 12,
           ),

           ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignIn()));
           },
           style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 140,
              vertical: 20
            )
           ),
            child: const Text("Log In"))
        ],
      ),
    );
  }
}