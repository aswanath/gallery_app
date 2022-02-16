
import 'package:flutter/material.dart';
import 'package:gallery_app/pages/home_page.dart';

class SplashScreen extends StatefulWidget {


  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    goHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(child: Text("My Gallery",
            style: TextStyle(fontSize: 40, color: Colors.redAccent),)),
        ],
      ),
    );
  }

  Future<void> goHome() async{
    await Future.delayed(const Duration(seconds: 2),()
    {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context)=> HomePage()));
    });
  }
}
