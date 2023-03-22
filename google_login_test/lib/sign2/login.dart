import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_login_test/sign2/google_logged_in_page.dart';
import 'package:google_login_test/sign2/google_sign_in_api.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    GoogleSignInAccount? user = await GoogleSignInApi.login();

    GoogleSignInAuthentication? googleAuth = await user!.authentication;

    var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );

    //user, OAuthcredential을 포함
    UserCredential? userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential != null) {
      print('로그인 성공 === Google');
      print(userCredential);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => GoogleLoggedInPage() //페이지연결, userCredential넘겨줌
      ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('로그인 실패 === Google')
      ));
    }

    FirebaseAuth.instance.authStateChanges().listen((event) { //로그인 변화
      if(event== null){
        print("signed out");
      }else{
        print("signed in");
      }
    });

    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SNS LOGIN'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            SizedBox(
              width: 180.0,
              height: 48.0,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    width: 5.0,
                    color: Colors.red,
                  ),
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: Icon(Icons.add),
                label: Text('Google 로그인'),
                onPressed: () async {
                  await loginWithGoogle(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


}