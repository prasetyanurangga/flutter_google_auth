import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teacher_track/constants/strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    User? user;


    @override
    initState() {
        super.initState();
        setState(() {
            user = FirebaseAuth.instance.currentUser;
        });
        listenToUserChanges();
    }

    void listenToUserChanges() {
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
            setState(() {
                this.user = user;
            });
        });
    }



    Future<dynamic> signInWithGoogle() async {
        try {
            final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
            
            final GoogleSignInAuthentication? googleAuth =
                await googleUser?.authentication;

            

            final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth?.accessToken,
                idToken: googleAuth?.idToken,
            );

            

            var result = await FirebaseAuth.instance.signInWithCredential(credential);
            print(result.user?.displayName);
        } on Exception catch (e) {
            print('exception->$e');
        }
    }

    @override
    Widget build(BuildContext context) {

        Widget buildBody() {
            return  Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          Text("Display Name : ${user?.displayName ?? 'Not Logged In'}"),
                          SizedBox(height: 16),
                          ElevatedButton(
                                onPressed: (){
                                    if(user == null){
                                        signInWithGoogle();
                                    }
                                    else{
                                        FirebaseAuth.instance.signOut();
                                    }
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),// Add elevation
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0), // Add rounded corners
                                        ),
                                    ),
                                ),
                                child: user == null ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        SvgPicture.asset(
                                            'assets/icons/google.svg', // Path to your Google logo SVG asset
                                            height: 24.0, // Adjust the height as needed
                                            width: 24.0, // Adjust the width as needed
                                        ),
                                        const SizedBox(width: 12.0), // Add spacing between the logo and text
                                        const Text(
                                            'Sign In with Google',
                                            style: TextStyle(
                                            fontSize: 16.0, // Adjust the font size as needed
                                            color: Colors.black, // Adjust the text color as needed
                                            ),
                                        ),
                                    ],
                                ) : const Text(
                                        'Sign In with Google',
                                        style: TextStyle(
                                        fontSize: 16.0, // Adjust the font size as needed
                                        color: Colors.black, // Adjust the text color as needed
                                        ),
                                    ),
                          )
                      ],
                  ),
                ),
            );
        }

        return  Scaffold(
            body: SafeArea(
                child: buildBody(),
            )
        );
    }
}