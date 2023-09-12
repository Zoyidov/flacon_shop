import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.baseDark,
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.baseDark
                ),
                child: const Icon(Icons.person,color: Colors.white,size: 50,),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Here should be user\'s name',style: TextStyle(fontSize: 20,color: Colors.grey),),
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.payment,size: 30,),
                          SizedBox(width: 10),
                          Text('Payment',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w400),),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.payment,size: 30,),
                          SizedBox(width: 10),
                          Text('Balance',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w400),),
                        ],
                      ),
                      Text('\$765',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w400),),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.recycling,size: 30,),
                          SizedBox(width: 10),
                          Text('Restore Purchase',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w400),),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.help_outline,size: 30,),
                          SizedBox(width: 10),
                          Text('Help',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w400),),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.settings,size: 30,),
                          SizedBox(width: 10),
                          Text('Setting',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w400),),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  SizedBox(height: 70),
                  Row(
                    children: [
                      Icon(Icons.logout,size: 30,),
                      SizedBox(width: 10),
                      Text('Log out',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w400),),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

