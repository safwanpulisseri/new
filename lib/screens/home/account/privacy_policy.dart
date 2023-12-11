import 'package:flutter/material.dart';
import 'package:rupee_app/screens/home/account/account.dart';

class ScreenPrivacyPolicy extends StatelessWidget {
  const ScreenPrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenAccount()));
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Login_logo.png',
                          height: 70,
                          width: 70,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 1600,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      child: Text(
                        "This privacy policy was last updated on November 7, 2023.Thanks for joining Rupee App. At Rupee App we respect your privacy and want you to understand how we collect, use and share information about you. This privacy policy covers our data collection practices and describes your rights regarding your personal data.Unless we link to another policy or state, this Privacy Policy applies when you visit or use Rupee App , our websites and other related services. The same applies to prospective customers of our business and enterprise products.By using the Services, you agree to the terms of this Privacy Policy. If you do not agree to this Privacy Policy or any other agreement governing your use of the Services, you must not use the Services.If you have questions or need support, please contact us at safwanpulisseri123@gmail.com",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
