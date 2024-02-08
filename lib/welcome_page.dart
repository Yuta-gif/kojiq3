import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'phone_sms.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Promotion',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        fontFamily: 'M PLUS Rounded 1c',
      ),
      home: PromotionScreen(),
    );
  }
}

class PromotionScreen extends StatefulWidget {
  @override
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  final _controller = PageController();
  double _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF05fcf0), // custom-cyan色
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _controller,
            children: List.generate(4, (index) {
              return buildPage(context, isLastPage: index == 3);
            }),
            onPageChanged: (value) {
              setState(() {
                _currentPage = value.toDouble();
              });
            },
          ),
          if (_currentPage.round() != 3)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: DotsIndicator(
                  dotsCount: 4,
                  position: _currentPage.round(),
                  decorator: DotsDecorator(
                    activeColor: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPage(BuildContext context, {bool isLastPage = false}) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/light.png'),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 24),
                Text(
                  '働いたらお金はすぐにGet!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'お給料がすぐに振り込まれます\n(3日以内には振り込まれます)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                    ),
                  ),
                ),
                if (isLastPage) // Add this line
                  ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SmsAuthPage()),
    );
  },
  child: Text('はじめる'),
  style: ElevatedButton.styleFrom(
    primary: Colors.blue, // Button color
    onPrimary: Colors.white, // Text color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30), // Rounded corners
    ),
  ),
),
              ],
            ),
          ),
        ),
      ],
    );
  }
}