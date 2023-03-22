import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_login_test/home_screen.dart';
import 'package:google_login_test/sign1/sample_screen.dart';
import 'package:google_login_test/sign2/google_logged_in_page.dart';
import 'package:google_login_test/sign2/google_sign_in_api.dart';
import 'package:google_login_test/sign2/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //파이어베이스 초기화

  isLogin();
  runApp(MyApp());
}

void isLogin() async {
  GoogleSignInAccount? user =
      await GoogleSignIn().currentUser; //현재 유저를 받아왔을때-> 근데 구글 로그인도 안했으니까 없는게 맞음
  if (user == null) {
    print('노 유저');
  } else {
    //있으면
    print('유저 is in');
  }


  //로그인 안했는데도 이름뜸.. 로그아웃 후 다시 빌드하면 null
  print(FirebaseAuth.instance.currentUser?.displayName);

  //현재 인증상태 확인
  FirebaseAuth.instance.authStateChanges().listen((event) {
    //로그인 변화
    if (event == null) {
      print("signed out 홈");
    } else {
      print(
          "signed in 홈"); //노유저에 signed in 이 뜬다..... event가 있기 때문에 뜬다면.. 이게 이전 로그인한 정보가 있다는거겠지
      //내가 로그아웃을 한 적이 없으니까 있다고 뜨는듯
    }
  });

}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  bool isAuto = false;
  UserCredential? userCredential;

  void goLogin() async{
    GoogleSignInAccount? user =  await GoogleSignInApi.login();
    GoogleSignInAuthentication? googleAuth = await user!.authentication;

    var credential = GoogleAuthProvider.credential( accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    //user, OAuthcredential을 포함
    userCredential =  await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential != null) { //stateful하고 stream으로 빌드해서 여러번 출력된듯
      print('로그인 성공 === Google???');
      print(userCredential);
    } else {

    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      // home: StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, AsyncSnapshot<User?> user) {
      //     if (user.hasData) { //유저가 있을 때 -> stream으로 해서 로그인하고나서 실행되는듯..
      //       goLogin();
      //       //return GoogleLoggedInPage(userCredential: userCredential);
      //       return SampleScreen();
      //     } else {// 없으면 로그인 화면
      //       return Login();
      //     }
      //   },
      // ),

      //SampleScreen()
    );
  }
}
