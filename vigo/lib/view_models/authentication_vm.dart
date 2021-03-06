import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vigo/models/future_manager.dart';
import 'package:vigo/providers/auth_provider.dart';
import 'package:vigo/view_models/base_vm.dart';
import 'package:vigo/views/home/navigation_page.dart';
import 'package:vigo/views/onboarding/login.dart';

class AuthViewModel extends BaseViewModel {
  final Reader reader;
  bool isLoading = false;
  bool signUpLoading = false;

  AuthViewModel(this.reader) : super(reader) {
    getUserDetails();
    getAllUserAdmin();
  }
  FutureManager<DocumentSnapshot<Object?>> loggedUser = FutureManager();
  FutureManager<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      allUserAdmins = FutureManager();

  CollectionReference admin = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> data = [];

  GetStorage box = GetStorage();
  bool uploadImage = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  userLoginService({required String email, required String password}) async {
    isLoading = true;
    notifyListeners();
    final res = await reader(authServiceProvider)
        .signIn(email: email, password: password);
    if (res != null) {
      print('my Id ${res.uid}');
      isLoading = false;
      getUserDetails();
      Get.offAll(() => const HomeNavigation());

      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  userSignUpService(
      {required String email,
      required String password,
      required String name,
      required String number,
      required String picture}) async {
    signUpLoading = true;
    notifyListeners();
    final res = await reader(authServiceProvider).signUp(
        email: email,
        password: password,
        name: name,
        number: number,
        picture: picture);
    if (res != null) {
      signUpLoading = false;
      Get.to(() => Login());

      notifyListeners();
    } else {
      signUpLoading = false;
      notifyListeners();
    }
  }

  // get user information
  Future getUserDetails() async {
    loggedUser.load();
    notifyListeners();
    final data = await admin.doc(_auth.currentUser!.uid).get();
    if (data.exists) {
      loggedUser.onSuccess(data);
      box.write('name', data['name']);
      box.write('email', data['email']);
      box.write('phone', data['phone']);
      box.write('picture', data['picture']);
      box.write('lastMessage', data['lastMessage']);
      box.write('id', data.id);

      notifyListeners();
      print('my data ${data['name']}');

      return data;
    } else {
      loggedUser.onError('Error');
      notifyListeners();
    }
  }

  //get all user admins

  Future getAllUserAdmin() async {
    allUserAdmins.load();
    notifyListeners();
    final firestoreInstance = FirebaseFirestore.instance.collection('Users');

    await firestoreInstance
        .orderBy('timesStamp', descending: true)
        .get()
        .then((value) {
      if (value.docs.isEmpty != true) {
        allUserAdmins.onSuccess(value.docs);

        notifyListeners();
      } else {
        allUserAdmins.onError('Error');
        notifyListeners();
      }

      return value;
    });
  }

  //update a users details
  Future updateUsersDetail({required String picture}) async {
    uploadImage = true;
    notifyListeners();
    final firestoreInstance = FirebaseFirestore.instance.collection('Users');

    await firestoreInstance.doc(_auth.currentUser!.uid).update({
      "picture": picture,
    }).then((value) {
      box.write('picture', picture);
      uploadImage = false;
      notifyListeners();
      Fluttertoast.showToast(
          msg: "Picture Updated Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  //chat user
  sendMessage({String? selectedUserID, String? content, String? peerId}) async {
    var documentReference = firestore
        .collection('chat')
        .doc(peerId)
        .collection('Messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'idFrom': _auth.currentUser!.uid,
          'idTo': selectedUserID,
          'timesStamp': FieldValue.serverTimestamp(),
          'content': content,
        },
      );
    }).then((value) async {
      getUserDetails();
      final firestoreInstance = FirebaseFirestore.instance.collection('Users');
      await firestoreInstance.doc(_auth.currentUser!.uid).update({
        "lastMessage": content,
        'timesStamp': DateTime.now().toString(),
      }).then((value) {
        getUserDetails();
        box.write('lastMessage', content);

        notifyListeners();
      });
      await firestoreInstance.doc(selectedUserID!).update({
        "lastMessage": content,
        'timesStamp': DateTime.now().toString(),
      }).then((value) {
        getUserDetails();
        box.write('lastMessage', content);

        notifyListeners();
      });
      // var data = firestore
      //     .collection('chat')
      //     .doc(selectedUserID)
      //     .collection('Messages')
      //     .doc(DateTime.now().millisecondsSinceEpoch.toString());

      // FirebaseFirestore.instance.runTransaction((transaction) async {
      //   transaction.set(
      //     data,
      //     {
      //       'idFrom': _auth.currentUser!.uid,
      //       'idTo': selectedUserID,
      //       'timesStamp': FieldValue.serverTimestamp(),
      //       'content': content,
      //     },
      //   );
      // });
    });
  }
}
