import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:vigo/providers/auth_provider.dart';
import 'package:vigo/providers/home_navigation_provider.dart';
import 'package:vigo/views/onboarding/login.dart';

class MyDrawerPage extends ConsumerStatefulWidget {
  const MyDrawerPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyDrawerPageState();
}

class _MyDrawerPageState extends ConsumerState<MyDrawerPage> {
  GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var authservice = ref.watch(authViewModel);
    final _viewModel = ref.watch(homeViewModel);
    return SafeArea(
      child: Drawer(
        elevation: 10,
        backgroundColor: Colors.black,
        child: Container(
            width: 300,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 130,
                    child: DrawerHeader(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red
                                // image: DecorationImage(
                                //     image: Asset(
                                //         _editProfileData.user.data!.profilePhoto),
                                //     fit: BoxFit.cover),
                                ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 150,
                                child: Text(
                                  box.read('name'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  widgetList('Users', Icons.person, () {
                    authservice.getAllUserAdmin();
                    _viewModel.changeIndex(1);
                    Navigator.pop(context);
                  }),
                  widgetList('Logout', Icons.logout, () {
                    showDialogWithFields();
                  })
                ],
              ),
            )),
      ),
    );
  }

  Widget widgetList(String? name, IconData? icon, Function? onclick) {
    return InkWell(
      onTap: () async {
        onclick!();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.withOpacity(0.3),
                child: Icon(
                  icon!,
                  color: name == 'Logout' ? Colors.red : Colors.red,
                  size: 20,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                name!,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDialogWithFields() {
    var authservice = ref.watch(authViewModel);
    final _viewModel = ref.watch(homeViewModel);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                box.remove('name');
                box.remove('email');
                box.remove('phone');
                box.remove('admin');
                box.remove('editor');
                box.remove('picture');
                _viewModel.changeIndex(0);
                authservice.box.erase();
                await FirebaseAuth.instance
                    .signOut()
                    .then((value) => Get.offAll(() => const Login()));
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
