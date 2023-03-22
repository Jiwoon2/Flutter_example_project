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
  runApp(const MyApp());
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

  print(FirebaseAuth.instance.currentUser
      ?.displayName); //로그인 안했는데도 이게 있음.. 로그아웃 후 다시 빌드하면 null

  FirebaseAuth.instance.authStateChanges().listen((event) {
    //로그인 변화
    if (event == null) {
      print("signed out 홈");
    } else {
      print(
          "signed in 홈"); //노유저에 signed in 이 뜬다..... event가 있기 때문에 뜬다면.. 이게 이전 로그인한 정보가 있다는거겠지
    }
  });


}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuto = false;
  UserCredential? userCredential;


  void goLogin() async{
    GoogleSignInAccount? user =  await GoogleSignInApi.login();
    GoogleSignInAuthentication? googleAuth = await user!.authentication;

    var credential = GoogleAuthProvider.credential( accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    //user, OAuthcredential을 포함
    userCredential =  await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential != null) { //머임 왜 2-3번임
      print('로그인 성공 === Google???');
      print(userCredential);
    } else {

    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: Login(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> user) {
          if (user.hasData) { //유저가 있을 때
            goLogin();
            return GoogleLoggedInPage();
            //return SampleScreen();
          } else {// 없으면 로그인 화면
            return Login();
          }
        },
      ),
      //SampleScreen()
    );
  }
}
