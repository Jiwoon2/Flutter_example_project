import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  final int price = 2000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream builder'),
      ),
      body: StreamBuilder<int>(
        initialData: price, //최초의 값으로 사용할 데이터
        stream: addStreamValue(), //새로 데이터가 들어올때마다 snapshot에 저장
        builder: (context, snapshot) {
          //스트림과 연결되어 지속적으로 데이터가 들어옴-> 결과 반영할 builder 필요
          final priceNumber = snapshot.data.toString();
          return Center(
            child: Text(
              priceNumber,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.blue,
              ),
            ),
          );
        },
      ),
    );
  }

  Stream<int> addStreamValue() {
    return Stream<int>.periodic(
      //매초마다 1씩 증가하는 데이터 하나씩 생성
      Duration(seconds: 1),
      (count) => price + count, //이 데이터를 count변수에 담아서 매번 price에 더함
    );
  }
}
