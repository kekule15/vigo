import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vigo/providers/auth_provider.dart';
import 'package:vigo/utils/constants.dart';
import 'package:vigo/views/home/users/edit_user.dart';
import 'package:vigo/views/home/users/list_user.dart';

class UserProfile extends ConsumerStatefulWidget {
  // final dynamic data;
  final String? id;
  final QuerySnapshot<Map<String, dynamic>>? userImages;
  final String? name;
  final String? bio;
  final String? gender;
  final String? email;
  final String? phone;
  final String? location;

  const UserProfile(
      {Key? key,
      this.userImages,
      this.id,
      this.name,
      this.bio,
      this.gender,
      this.email,
      this.phone,
      this.location})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  GetStorage box = GetStorage();

  XFile? image;
  final ImagePicker _picker = ImagePicker();

  takePhoto(ImageSource source, cxt) async {
    var authservice = ref.watch(authViewModel);
    setState(() {
      authservice.uploadImage = true;
    });
    final pickedFile = await _picker.pickImage(
        source: source, imageQuality: 50, maxHeight: 500.0, maxWidth: 500.0);
    if (pickedFile != null) {
      setState(() {
        image = pickedFile;
      });
      final refData = FirebaseStorage.instance
          .ref()
          .child('Images')
          .child('admin')
          // ignore: prefer_adjacent_string_concatenation
          .child('images-${Timestamp.now().millisecondsSinceEpoch.toString()}');
      await refData.putFile(File(image!.path.toString()));
      imageUrl = await refData.getDownloadURL();
      authservice.updateUsersDetail(picture: imageUrl!);
      setState(() {
        authservice.uploadImage = false;
      });
    }

    // Navigator.pop(cxt);
  }

  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    var authservice = ref.watch(authViewModel);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          'Welcome ',
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: (() {
                        authservice.getAllUserAdmin();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ListUsers()));
                      }),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Constants.color1,
                              Constants.color2,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.supervised_user_circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditUser()));
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Constants.color1,
                          Constants.color2,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.edit_note,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: authservice.loggedUser.data == null
          ? const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(
              children: <Widget>[
                InkWell(
                    onTap: () async {
                      await takePhoto(ImageSource.gallery, context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 30),
                          height: 130,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                              image: box.read('picyure') == ''
                                  ? const DecorationImage(image: AssetImage(''))
                                  : DecorationImage(
                                      image: NetworkImage(box.read('picture')),
                                      fit: BoxFit.cover)),
                        ),
                        authservice.uploadImage == true
                            ? const Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                    ),
                                  ),
                                ))
                            : const SizedBox(),
                      ],
                    )),
                InkWell(
                  onTap: () async {
                    await takePhoto(ImageSource.gallery, context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 170, left: 20),
                    child: Text(
                      'Add Picture',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 200,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(60.0)),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Constants.color1,
                          Constants.color2,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30.0))),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.red,
                                  size: 14,
                                ),
                              ),
                              title: Text(
                                //  widget.data!['email'] ?? 'No Email',
                                //'Email',
                                box.read('name'),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30.0))),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                child: const Icon(
                                  Icons.phone,
                                  color: Colors.red,
                                  size: 14,
                                ),
                              ),
                              title: Text(
                                // widget.data!['phoneNumber'] ?? 'No Phone Number',
                                //'Phone number',
                                box.read('phone'),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30.0))),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                child: const Icon(
                                  Icons.email,
                                  color: Colors.red,
                                  size: 14,
                                ),
                              ),
                              title: Text(
                                // widget.data!['location'] ?? 'No Location',
                                //'Location',
                                box.read('email'),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
