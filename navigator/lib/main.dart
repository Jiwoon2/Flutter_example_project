import 'package:flutter/material.dart';
import 'package:navigator/ScreenA.dart';
import 'package:navigator/ScreenB.dart';
import 'package:navigator/ScreenC.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: const FirstPage(),
      initialRoute: '/',
      routes: {
        '/': (context)=> ScreenA(),
        '/b': (context)=> ScreenB(),
        '/c': (context)=> ScreenC(),
      },
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context2) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('go second'),
          onPressed: () { //버튼을 누르면 두번째 페이지를 쌓아올림
            Navigator.push(
              context2,
              MaterialPageRoute(
                builder: (_) => SecondPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('go first'),
          onPressed: () {
            Navigator.pop(ctx); //자신이 사라져야하므로 context는 ctx
          },
        ),
      ),
    );
  }
}
