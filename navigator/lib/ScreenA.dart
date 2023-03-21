import 'package:flutter/material.dart';
import 'package:navigator/ScreenB.dart';
import 'package:navigator/ScreenC.dart';

class ScreenA extends StatelessWidget {
  const ScreenA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/b'); //b화면으로 이동
               // Navigator.pushNamedAndRemoveUntil(context, '/b', (_)=>false); // 첫시작 '/b'화면으로 전환됨. 모든페이지 제거 후 b화면 push
              //    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ScreenB(),), (route) => false);//모든페이지 제거 후 b화면 push

               // Navigator.popAndPushNamed(context, '/b');
              },
              child: Text("go B"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/c');
              },
              child: Text("go C"),
            ),
          ],
        ),
      ),
    );
  }
}
