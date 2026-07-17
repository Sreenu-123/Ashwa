import 'package:flutter/material.dart';

class SplashScreen
    extends
        StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<
    SplashScreen
  >
  createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends
        State<
          SplashScreen
        > {
  @override
  Widget
  build(
    BuildContext
    context,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/ashwa.png',
              width: 180,
              height: 180,
            ),
          ),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ashwa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 33,
                  ),
                ),

                SizedBox(
                  height: 0,
                ),

                Text(
                  'Your Intelligent Horse Riding Trainer',
                  style: TextStyle(
                    color: Color.fromARGB(
                      255,
                      198,
                      197,
                      197,
                    ),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
