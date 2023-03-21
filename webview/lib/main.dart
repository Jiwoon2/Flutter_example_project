import 'package:flutter/material.dart';
import 'package:webview/home_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '/webview_controller.dart';
import 'package:get/get.dart';

// void main() async {
//   //전역에 webview controller get 세팅
//   Get.put(WebviewMainController());
//
//   //Getx controller는 get find로 가져올 수 있다.
//   //controller 안에 'get to => Get.find()'를 사용하면 Get put으로 세팅한 값들을 가져올 수 있다.
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

void main() {
//   //전역에 webview controller get 세팅
  Get.put(WebviewMainController());
  runApp(const MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyStatefulWidget(), //밑의 위젯 실행
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

//class _MyAppState extends State<MyApp> {
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  //Webview에서 세팅한 WebviewController 불러오기
  final controller = WebviewMainController.to.getController();

  //home으로 가는 버튼 함수
  void goHome() {
    controller.loadRequest(Uri.parse('https://www.youtube.com/')); //컨트롤러에서 접속을 막음
  }

  //앱 나가기 전 dialog
  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('no'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  //뒤로가기 로직(핸드폰 뒤로가기 버튼 클릭시)
  Future<bool> onGoBack() async {
    //=> Webview의 뒤로가기가 가능하면
    if (await controller.canGoBack()) {
      controller.goBack(); //=> Webview 뒤로가기
      return Future.value(false); //=> onWillPop은 false면 앱을 끄지 않는다.
    } else {
      Future<bool> dialogResult = showExitPopup(); //앱을 종료하는 알림창
      return Future.value(dialogResult); //=> true이면 앱 끄기;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('widget.title'),
      ),
      body: WillPopScope(
          child: WebViewWidget(controller: controller), //컨트롤러로 웹뷰 연결
          onWillPop: () => onGoBack() //뒤로 가기 로직
          //return Future.value(true); //뒤로가기 허용안함
          ),
      floatingActionButton: Stack(children: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: goHome,
            tooltip: 'goHome',
            child: const Icon(Icons.home_outlined),
          ),
        ),
      ]),
    );
  }
}
