import 'dart:developer';
import 'package:book_a_bite_user/controller/general_controller.dart';
import 'package:book_a_bite_user/modules/login/logic.dart';
import 'package:book_a_bite_user/modules/sign_up/logic.dart';
import 'package:book_a_bite_user/route_generator.dart';
import 'package:book_a_bite_user/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthentication {
  void signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user!.uid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        Get.find<GeneralController>()
            .boxStorage
            .write('uid', user.uid.toString());
        Get.find<GeneralController>()
            .boxStorage
            .write('userName', user.displayName);
        log('user exist');
        Get.find<GeneralController>().boxStorage.write('session', 'active');
        Get.find<GeneralController>().boxStorage.write('loginType', 'email');
        Get.find<GeneralController>().updateFormLoader(false);

        Get.offAllNamed(PageRoutes.home);
      } else {
        Get.find<GeneralController>().boxStorage.write('uid', user.uid);
        _firestore.collection('users').doc(user.uid).set({
          'name': 'Guest',
          'phone': user.phoneNumber ?? '',
          'image': user.photoURL ?? '',
          'address': '',
          'role': 'customer',
          'email': user.email,
          'uid': user.uid,
        });
        FirebaseFirestore.instance
            .collection('zero_heroes')
            .doc()
            .set({'uid': user.uid, 'name': 'Guest', 'bite_points': 0});
        Get.find<GeneralController>().updateFormLoader(false);
        Get.find<GeneralController>().boxStorage.write('session', 'active');

        Get.offAllNamed(PageRoutes.home);
      }
      log('Google-->>${user.email}');
      // Once signed in, return the UserCredential
      // return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
      Get.find<GeneralController>().updateFormLoader(false);
    }
  }

  void signInWithEmailAndPassword() async {
    try {
      final User? user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Get.find<LoginLogic>().emailController.text,
        password: Get.find<LoginLogic>().passwordController.text,
      ))
              .user;
      Get.find<GeneralController>().updateFormLoader(false);
      if (user != null) {
        log(user.uid.toString());
        Get.find<GeneralController>()
            .boxStorage
            .write('uid', user.uid.toString());
        Get.find<GeneralController>()
            .boxStorage
            .write('userName', user.displayName);
        log('user exist');
        Get.find<GeneralController>().boxStorage.write('session', 'active');

        Get.find<GeneralController>().boxStorage.write('loginType', 'email');
        Get.offAllNamed(PageRoutes.home);
        Get.find<LoginLogic>().emailController.clear();
        Get.find<LoginLogic>().passwordController.clear();
        Get.find<LoginLogic>().phoneController.clear();
      } else {
        log('user not found');
        Get.find<GeneralController>().boxStorage.remove('session');
      }
    } on FirebaseAuthException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
        colorText: Colors.white,
        backgroundColor: customThemeColor.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: Get.find<SignUpLogic>().emailController.text,
              password: Get.find<SignUpLogic>().passwordController.text)
          .then((user) {
        Get.find<GeneralController>().boxStorage.write('uid', user.user!.uid);
        Get.find<GeneralController>()
            .boxStorage
            .write('userName', Get.find<SignUpLogic>().nameController.text);
        _firestore.collection('users').doc(user.user!.uid).set({
          'name': Get.find<SignUpLogic>().nameController.text,
          'phone': Get.find<SignUpLogic>().phoneNumber,
          'address': Get.find<SignUpLogic>().addressController.text,
          // 'lng': Get.find<SignUpLogic>().longitudeString,
          // 'lat': Get.find<SignUpLogic>().latitudeString,
          'image': Get.find<SignUpLogic>().downloadURL,
          'email': Get.find<SignUpLogic>().emailController.text,
          'role': 'customer',
          'uid': user.user!.uid,
        });
        FirebaseFirestore.instance.collection('zero_heroes').doc().set({
          'uid': user.user!.uid,
          'name': Get.find<SignUpLogic>().nameController.text,
          'bite_points': 0
        });
      });
      Get.find<GeneralController>().updateFormLoader(false);
      Get.find<GeneralController>().boxStorage.write('session', 'active');

      Get.find<GeneralController>().boxStorage.write('loginType', 'email');

      Get.offAllNamed(PageRoutes.home);

      Get.find<SignUpLogic>().emailController.clear();
      Get.find<SignUpLogic>().passwordController.clear();
      return true;
    } on FirebaseAuthException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
        colorText: Colors.white,
        backgroundColor: customThemeColor.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
      log(e.toString());
      return false;
    }
  }

  Future signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    Get.find<GeneralController>().boxStorage.remove('uid');
    Get.find<GeneralController>().boxStorage.remove('session');
    Get.find<GeneralController>().boxStorage.remove('preferences');
    Get.find<GeneralController>().boxStorage.remove('loginType');
    Get.find<GeneralController>().boxStorage.remove('fcmToken');
    Get.offAllNamed(PageRoutes.login);
  }
}
