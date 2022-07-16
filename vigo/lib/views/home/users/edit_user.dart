
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vigo/enums/text_field_type_enum.dart';
import 'package:vigo/providers/auth_provider.dart';
import 'package:vigo/widget/custom_button.dart';
import 'package:vigo/widget/customfield.dart';

class EditUser extends ConsumerStatefulWidget {
  const EditUser({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditUserState();
}

class _EditUserState extends ConsumerState<EditUser> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isAdmin = false;
  bool isEditor = true;
  @override
  Widget build(BuildContext context) {
    var _authViewModel = ref.watch(authViewModel);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text(
          'Edit profile',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(
              height: 20,
            ),
            CustomField(
              borderSide: const BorderSide(color: Colors.grey),
              headtext: 'User name',
              hint: 'Enter user name',
              fieldType: TextFieldType.name,
              controller: nameController,
              validate: true,
              style: const TextStyle(fontSize: 13),
              pIcon: const Icon(
                Icons.person,
                color: Colors.red,
                size: 14,
              ),

              //sIcon: const IsObscure(),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomField(
              borderSide: const BorderSide(color: Colors.grey),
              headtext: 'User email',
              hint: 'Enter user email',
              fieldType: TextFieldType.email,
              controller: emailController,
              validate: true,
              style: const TextStyle(fontSize: 13),
              pIcon: const Icon(
                Icons.email,
                color: Colors.red,
                size: 14,
              ),
              textInputFormatters: [
                FilteringTextInputFormatter.deny(RegExp('[ ]')),
                // LengthLimitingTextInputFormatter(4),
                // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              //sIcon: const IsObscure(),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomField(
              borderSide: const BorderSide(color: Colors.grey),
              headtext: 'User phone number',
              hint: 'Enter user phone number',
              fieldType: TextFieldType.phone,
              textInputFormatters: [
                FilteringTextInputFormatter.deny(RegExp('[ ]')),
                // LengthLimitingTextInputFormatter(4),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: phoneController,
              validate: true,
              style: const TextStyle(fontSize: 13),
              pIcon: const Icon(
                Icons.call,
                color: Colors.red,
                size: 14,
              ),
              //sIcon: const IsObscure(),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomField(
              borderSide: const BorderSide(color: Colors.grey),
              headtext: 'Password',
              hint: 'Enter password',
              fieldType: TextFieldType.name,
              controller: passController,
              textInputFormatters: [
                FilteringTextInputFormatter.deny(RegExp('[ ]')),
                // LengthLimitingTextInputFormatter(4),
                // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validate: true,
              style: const TextStyle(fontSize: 13),
              pIcon: const Icon(
                Icons.lock,
                color: Colors.red,
                size: 14,
              ),
              //sIcon: const IsObscure(),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomField(
              borderSide: const BorderSide(color: Colors.grey),
              headtext: 'Admin',
              hint: 'Is user Admin?',
              readonly: true,

              validate: false,
              style: const TextStyle(fontSize: 13),
              pIcon: const Icon(
                Icons.admin_panel_settings,
                color: Colors.red,
                size: 14,
              ),
              sIcon: Switch(
                  value: isAdmin,
                  onChanged: (value) {
                    setState(() {
                      isAdmin = value;
                    });
                  }),
              //sIcon: const IsObscure(),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomField(
              borderSide: const BorderSide(color: Colors.grey),
              headtext: 'Editor',
              hint: 'Is user Editor??',
              readonly: true,

              validate: false,
              style: const TextStyle(fontSize: 13),
              pIcon: const Icon(
                Icons.badge,
                color: Colors.red,
                size: 14,
              ),

              sIcon: Switch(
                  value: isEditor,
                  onChanged: (value) {
                    setState(() {
                      isEditor = value;
                    });
                  }),
              //sIcon: const IsObscure(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: CustomButton(
              title: _authViewModel.signUpLoading
                  ? const Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
              onclick: () {
                var form = _formKey.currentState;
                if (form!.validate()) {
                  form.save();
                  _authViewModel.userSignUpService(
                      email: emailController.text.toString(),
                      password: passController.text.toString(),
                     
                      name: nameController.text.toString(),
                      number: phoneController.text.toString(),
                      picture: '');
                } else {}
              },
              color: Colors.red,
              borderColor: true),
        ),
      ),
    );
  }
}
