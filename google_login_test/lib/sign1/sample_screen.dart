import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_platform.dart';

class SampleScreen extends StatefulWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  LoginPlatform _loginPlatform = LoginPlatform.none; //현재 로그인한 플랫폼을 저장할 변수 선언
  String userName = '';

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn(); //로그인 진행 -> 계정 선택하는 로그인. 바로 로그인x. 삭제해도 이전 계정남아있음

    if (googleUser != null) {
      //로그인 됐으면 출력
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      setState(() {
        //구글로 변경
        _loginPlatform = LoginPlatform.google;
        userName = googleUser.displayName!;
      });
    }
  }

  Future<UserCredential> signInWithGoogle2() async {//공식문서
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        await GoogleSignIn().signOut(); //로그아웃
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
          child: _loginPlatform != LoginPlatform.none
              ? _logoutButton() //none이 아니면 로그아웃 버튼 위젯
              : Row( //로그인 안됐으면 로그인 버튼 위젯
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _loginButton(
                      'google_logo',
                      signInWithGoogle,
                    )
                  ],
                )),
    );
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    return Card(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage('image/red.jpg'),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(35.0),
          ),
          onTap: onTap, //tap하면 함수 실행
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: Text('로그아웃'),
    );
  }
}
