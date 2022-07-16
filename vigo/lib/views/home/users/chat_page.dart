import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vigo/providers/auth_provider.dart';
import 'package:vigo/utils/constants.dart';

class Chat extends ConsumerStatefulWidget {
  final String? peerid;
  final String? userid;
  final String? selectedId;

  Chat({Key? key, this.peerid, this.userid, this.selectedId}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final messagesController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  List<QueryDocumentSnapshot> listMessage = List.from([]);
  String? profileImage;
  bool? textEmpty = false;
  String? chatWithName;
  bool? isLoading = false;
  bool isShowSticker = false;
  File? imageFile;
  bool active = true;

  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('ebuka ${widget.peerid}');
    super.initState();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var authservice = ref.watch(authViewModel);
    print('ebuka ${widget.peerid}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'User name',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 40,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Constants.color1,
                        Constants.color2,
                      ])),
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                  ),
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(60)),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Constants.color1,
                        Constants.color2,
                      ],
                    ),
                  ),
                  child: StreamBuilder(
                      stream: firestore
                          .collection('chat')
                          .doc(widget.peerid)
                          .collection('Messages')
                          .orderBy('timesStamp', descending: true)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        listMessage.addAll(snapshot.data!.docs);
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data.docs.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Icon(
                                    FontAwesomeIcons.comments,
                                    size: 100,
                                  ),
                                ),
                                Text(
                                  'Say Hello',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            reverse: true,
                            controller: listScrollController,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 14,
                                        right: 14,
                                        top: 10,
                                        bottom: 10),
                                    child: Align(
                                      alignment: (widget.userid ==
                                              snapshot.data.docs[index]
                                                  ['idFrom'])
                                          ? Alignment.topRight
                                          : Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment: widget.userid ==
                                                snapshot.data.docs[index]
                                                    ['idFrom']
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: (widget.userid ==
                                                        snapshot.data
                                                                .docs[index]
                                                            ['idFrom'])
                                                    ? Colors.grey.shade400
                                                    : Colors.red[200]),
                                            padding: EdgeInsets.all(16),
                                            child: Text(
                                              snapshot.data.docs[index]
                                                  ['content'],
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          Icon(
                                            Icons.done_all,
                                            color: Colors.grey,
                                            size: 17,
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            });
                      }),
                ),
              ),
              Container(
                height: Platform.isIOS ? 70 : 60,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                          controller: messagesController,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          focusNode: focusNode,
                          maxLines: null,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 45,
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
                      child: GestureDetector(
                        onTap: () async {
                          if (messagesController.text.trim().isNotEmpty &&
                              messagesController.text.trim() != '') {
                            authservice.sendMessage(
                                content: messagesController.text.trim(),
                                selectedUserID: widget.selectedId,
                                peerId: widget.peerid);
                            messagesController.clear();
                            listScrollController.animateTo(0.0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut);
                          }
                        },
                        child: const Icon(
                          Icons.send,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      if (document.get('idFrom') == auth.currentUser!.uid) {
        // Right (my message)
        return Column(
          children: [
            // if (document.get('replyMessage') != null)

            Text('Hello'),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  child: Text(
                    DateFormat('hh:mm a')
                        .format(document.get('timestamp').toDate())
                        .toString(),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            )
          ],
        );
      } else {
        // Left (peer message)
        return Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Hello'),
              Row(
                children: [
                  Container(
                    child: Text(
                      DateFormat('hh:mm a')
                          .format(document.get('timestamp').toDate())
                          .toString(),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              )
            ],
          ),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }
}
