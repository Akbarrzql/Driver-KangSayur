import 'dart:async';
import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/ui/auth/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Color _backgroundColor = ColorValue.tertiaryColor;
  double _logoSize = 200.0;
  double _logoMargin = 0.0;
  double _opacity = 1.0;
  double _circleSize = 800.0;

  // void getToken() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? token = pref.getString('token');
  //   if (token != null) {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const BottomNavigation(),
  //         ));
  //   } else if (token == null) {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const OnboardingScreen(),
  //         ));
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      setState(() {
        _backgroundColor = Colors.white;
        _logoSize = 150.0;
        _logoMargin = 25.0;
        _opacity = 0.0;
        _circleSize = 300.0;
      });
      Timer(const Duration(seconds: 3), (){
        // getToken();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 3),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(seconds: 5),
                  width: _circleSize,
                  height: _circleSize,
                  margin: EdgeInsets.all(_logoMargin),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}