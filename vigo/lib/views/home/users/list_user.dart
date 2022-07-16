import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vigo/providers/auth_provider.dart';
import 'package:vigo/styles/custom_colors.dart';

class ListUsers extends ConsumerStatefulWidget {
  const ListUsers({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListUsersState();
}

class _ListUsersState extends ConsumerState<ListUsers> {
  GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var authservice = ref.watch(authViewModel);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text(
          'Chat',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(
            height: 30,
          ),
          authservice.allUserAdmins.data == null
              ? const Center(
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator()),
                )
              : authservice.allUserAdmins.data!.isEmpty == true
                  ? const Center(
                      child: Text('No User here'),
                    )
                  : Column(
                      children: List.generate(
                          authservice.allUserAdmins.data!.length,
                          (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: Offset(0.1, 0.3)),
                                    ],
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      onTap: () {
                                        // Get.to(() => ViewAdminDetails(
                                        //       name: authservice.allUserAdmins
                                        //           .data![index]['name'],
                                        //       emal: authservice.allUserAdmins
                                        //           .data![index]['email'],
                                        //       number: authservice.allUserAdmins
                                        //           .data![index]['phone'],
                                        //       admin: authservice.allUserAdmins
                                        //           .data![index]['admin'],
                                        //       editor: authservice.allUserAdmins
                                        //           .data![index]['editor'],
                                        //       picture: authservice.allUserAdmins
                                        //           .data![index]['picture'],
                                        //     ));
                                      },
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            CustomColors.grey.withOpacity(0.4),
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                authservice.allUserAdmins
                                                    .data![index]['picture']),
                                      ),
                                      title: Text(
                                          authservice.allUserAdmins.data![index]
                                              ['name'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                      subtitle: Text(
                                          authservice.allUserAdmins.data![index]
                                              ['email'],
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey)),
                                      trailing: InkWell(
                                        onTap: () {
                                          showDialogWithFields();
                                        },
                                        child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor: CustomColors.grey
                                                .withOpacity(0.2),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                    )
        ],
      ),
    );
  }

  void showDialogWithFields() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete Admin'),
          content: const Text('Sure you want to delete this Admin?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {},
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
