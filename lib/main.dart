// ignore_for_file: use_build_context_synchronously, duplicate_ignore, empty_catches, unused_import, unnecessary_import, avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
 
import 'package:chat/signin.dart';
import 'package:chat/signup.dart';
import 'package:chat/taskscreen.dart';
import 'package:chat/welcomscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(   MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Change(),
      builder: (context, child) {
        return MaterialApp(
          key: navigatorkey,
          home:const Welcomescreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
class Change extends ChangeNotifier {
//  List<QueryDocumentSnapshot>
  List data = [];
  List taskdata = [];
  List subdata = [];
  bool secure = false;
  bool dark = false;
  final auth = FirebaseAuth.instance;
   

  // ---------------------------------------
  void changesecure() {
    try {
      secure = !secure;
      // ignore: empty_catches
    } catch (e) {}
    notifyListeners();
  }

  //--------------------------------------
  void scaffoldmessanger(BuildContext context, String string) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(string)));
  }

//-----------------------------------------
 
  Future<void> signinwithemailandpassword(
      TextEditingController email,
      TextEditingController password,
      BuildContext context,
      Widget Function() page,
      String string,
      String actiontext1,
      String actiontext2,
      Function() fun1,
      Function() fun2) async {
    try {
      // محاولة تسجيل الدخول
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      // تحقق من أن المستخدم الحالي ليس null وأن البريد الإلكتروني تم التحقق منه
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        // التنقل إلى الصفحة المحددة
        navigate(context, page);
      } else if (FirebaseAuth.instance.currentUser != null &&
          !FirebaseAuth.instance.currentUser!.emailVerified) {
        // عرض رسالة توضيحية إذا لم يتم التحقق من البريد الإلكتروني
        alert(
            context,
            FirebaseAuthException(
                code: 'email-not-verified',
                message: 'Please verify your email to continue.'),
            actiontext1,
            actiontext2,
            fun1, () async {
          await FirebaseAuth.instance.currentUser!.sendEmailVerification();
          Navigator.of(context).pop();
        });
      }
    } on FirebaseAuthException catch (e) {
      // التعامل مع أخطاء FirebaseAuthException
      print(e);
      alert(context, e, actiontext1, actiontext2, fun1, fun2);
    } catch (e) {
      // التعامل مع الأخطاء العامة الأخرى
      print(e);
      alert(
          context,
          FirebaseAuthException(
              code: 'unknown-error', message: 'An unknown error occurred.'),
          actiontext1,
          actiontext2,
          fun1,
          fun2);
    }
  }

//--------------------------------------------------------
  void alert(BuildContext context, var e, String actiontext1,
      String actiontext2, Function() fun1, Function() fun2) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("$e"),
              actions: [
                TextButton(
                    onPressed: () {
                      fun1();
                    },
                    child: Text(actiontext1)),
                TextButton(
                    onPressed: () {
                      fun2();
                    },
                    child: Text(actiontext2))
              ],
            ));
  }
  //--------------------------------------->

  void signinwithgoogle(
      BuildContext context,
      Widget Function() page,
      String actiontext1,
      String actiontext2,
      Function() fun1,
      Function() fun2) async {
    try {
      final googleuser = await GoogleSignIn().signIn();
      if (googleuser != null) {
        final googleauth = await googleuser.authentication;
        final googlecredintial = GoogleAuthProvider.credential(
            idToken: googleauth.idToken, accessToken: googleauth.accessToken);
        await auth.signInWithCredential(googlecredintial);
        if (FirebaseAuth.instance.currentUser != null) {
          navigatreplace(context, () => page());
        }
      }
    } catch (e) {
      print(e);
      alert(context, e, actiontext1, actiontext2, fun1, fun2);
    }
  }

//---------------------------------------------------------------------------
  void createuserwithemailandpassword(String email, String password,
      BuildContext context, Widget Function() page) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        navigatreplace(context, () => page());
      } else {
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                e.toString(),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()));
                    },
                    child: const Text("ok"))
              ],
            );
          });
    }
    notifyListeners();
  }

//-------------------------------------------------------------
  void getmessage() async {
    await for (var snapshot
        in FirebaseFirestore.instance.collection('messages').snapshots()) {
      // ignore: unused_local_variable
      for (var message in snapshot.docs) {}
    }
    notifyListeners();
  }

  void loading(isloading) {
    isloading = false;
    notifyListeners();
  }

  void changedark(bool value) {
    dark = value;
    notifyListeners();
  }

  void navigate(BuildContext context, Widget Function() page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page()));
  }

  void navigatreplace(BuildContext context, Widget Function() page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return page();
    }));
  }

  //---------------------------------------------------------
  void logout(BuildContext context, String string, String actiontext1,
      String actiontext2, Function() fun1, Function() fun2) async {
    alert(context, string, actiontext1, actiontext2, fun1, fun2);
    await FirebaseAuth.instance.signOut();
  }

  //--------------------------------------------------------
  void adddata({
    required TextEditingController? catagory,
    required BuildContext? context,
  }) async {
    await FirebaseFirestore.instance
        .collection('progect')
        .add({'place': catagory!.text, 'time': FieldValue.serverTimestamp()});
    catagory.clear();

    notifyListeners();
  }

//--------------------------------------------------------------
  void addinnercatagory(
      int index, TextEditingController catagorycontroller) async {
    var element = await FirebaseFirestore.instance
        .collection('progect')
        .doc(data[index].id)
        .collection(data[index]['place'])
        .add({
      "name": catagorycontroller.text,
      'time': FieldValue.serverTimestamp()
    });
    catagorycontroller.clear();
    notifyListeners();
  }

//---------------------------------------------------------------
  void addsubdata(
      {required int mostoldindex,
      required int oldindex,
      required TextEditingController subcontroller}) async {
    await FirebaseFirestore.instance
        .collection('progect')
        .doc(data[mostoldindex].id)
        .collection(data[mostoldindex]['place'].toString())
        .doc(taskdata[oldindex].id)
        .collection(taskdata[oldindex]['name'].toString())
        .add(
            {"data": subcontroller.text, 'time': FieldValue.serverTimestamp()});
    subcontroller.clear();
    notifyListeners();
  }

  //-------------------------------------------------------------
  void getdata() async {
    QuerySnapshot<Map<String, dynamic>> element = await FirebaseFirestore
        .instance
        .collection('progect')
        .orderBy('time')
        .get();
    data.clear();
    data.addAll(element.docs);
    notifyListeners();
  }

//------------------------------------------------------------------
  void deletedata(int index) {
    FirebaseFirestore.instance
        .collection('progect')
        .doc(data[index].id)
        .delete();
    //data.removeAt(index);
    notifyListeners();
  }

//--------------------------------------------------------------------
  void deleteinnerdata({required int index, required int oldindex}) {
    FirebaseFirestore.instance
        .collection('progect')
        .doc(data[oldindex].id)
        .collection(data[oldindex]['place'].toString())
        .doc(taskdata[index].id)
        .delete();
    //  taskdata.removeAt(index);

    notifyListeners();
  }

//--------------------------------------------------------------------
  void deletesubdata(int mostoldindex, int oldindex, int index) async {
    await FirebaseFirestore.instance
        .collection('progect')
        .doc(data[mostoldindex].id)
        .collection(data[mostoldindex]['place'].toString())
        .doc(taskdata[oldindex].id)
        .collection(taskdata[oldindex]['name'].toString())
        .doc(subdata[index].id)
        .delete();
    notifyListeners();
  }

//--------------------------------------------------------------------
  void updatesubdata(int mostoldindex, int oldindex, int index,
      TextEditingController subcontroller) async {
    await FirebaseFirestore.instance
        .collection('progect')
        .doc(data[mostoldindex].id)
        .collection(data[mostoldindex]['place'].toString())
        .doc(taskdata[oldindex].id)
        .collection(taskdata[oldindex]['name'].toString())
        .doc(subdata[index].id)
        .update({"data": subcontroller.text});
    subcontroller.clear();
    notifyListeners();
  }

//--------------------------------------------------------------------
  void updateinnerdata(
      int oldindex, int index, TextEditingController newplace) async {
    await FirebaseFirestore.instance
        .collection('progect')
        .doc(data[oldindex].id)
        .collection(data[oldindex]['place'].toString())
        .doc(taskdata[index].id)
        .update({'name': newplace.text});

    newplace.clear();
    notifyListeners();
  }

  //-------------------------------------------------------------------
  void update(
      {required int index,
      required TextEditingController updatecontroller}) async {
    await FirebaseFirestore.instance
        .collection('progect')
        .doc(data[index].id)
        .update({'place': updatecontroller.text});
    notifyListeners();
  }

//---------------------------------------------------------------------
  void getinnerdata({
    required int oldindex,
  }) async {
    QuerySnapshot<Map<String, dynamic>> element = await FirebaseFirestore
        .instance
        .collection('progect')
        .doc(data[oldindex].id)
        .collection(data[oldindex]['place'].toString())
        .orderBy('time')
        .get();

    taskdata.clear();
    taskdata.addAll(element.docs);
    notifyListeners();
  }

  //----------------------------------------------------------------------
  void getsubdata({required int mostoldindex, required int oldindex}) async {
    QuerySnapshot<Map<String, dynamic>> element = await FirebaseFirestore
        .instance
        .collection('progect')
        .doc(data[mostoldindex].id)
        .collection(data[mostoldindex]['place'].toString())
        .doc(taskdata[oldindex].id)
        .collection(taskdata[oldindex]['name'].toString())
        .orderBy('time')
        .get();
    subdata.clear();
    subdata.addAll(element.docs);
    notifyListeners();
  }

  List balance = [];
  void getbalance() async {
    QuerySnapshot<Map<String, dynamic>> element =
        await FirebaseFirestore.instance.collection('balance').get();
    balance.clear();
    balance.addAll(element.docs);
    notifyListeners();
  }

  File? file;
  String? url;

  Future<void> getimage({required bool iscamera}) async {
    try {
      final ImagePicker imagepicker = ImagePicker();
      final XFile? filepath = await imagepicker.pickImage(
        source: iscamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (filepath != null) {
        file = File(filepath.path);
        String imageName = basename(filepath.path);

        // Create a reference to the location you want to upload to in Firebase Storage
        var refStorage =
            FirebaseStorage.instance.ref().child('images/$imageName');

        // Upload the file to Firebase Storage
        await refStorage.putFile(file!);

        // Get the download URL
        url = await refStorage.getDownloadURL();
      }
    } catch (e) {
      print('Error occurred while picking or uploading image: $e');
    }
    notifyListeners();
  }
}
