import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:vigo/enums/text_field_type_enum.dart';
import 'package:vigo/providers/auth_provider.dart';
import 'package:vigo/utils/constants.dart';
import 'package:vigo/utils/svgs.dart';
import 'package:vigo/views/onboarding/create_user.dart';
import 'package:vigo/widget/customfield.dart';
import 'package:vigo/widget/image_widgets.dart';
import 'package:get/get.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordCOntroller = TextEditingController();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();
  bool btnState = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    var _authViewModel = ref.watch(authViewModel);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topRight,
            //   end: Alignment.bottomLeft,
            //   colors: [
            //     Constants.color1,
            //     Constants.color2,
            //   ],
            // ),
            ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              Center(
                  child: SvgImage(
                asset: peopleIcon,
                height: 200,
              )),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                // ignore: deprecated_member_use
                child: Column(
                  children: [
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
                      height: 30,
                    ),
                    CustomField(
                      borderSide: const BorderSide(color: Colors.grey),
                      headtext: 'Password',
                      hint: 'Enter password',
                      fieldType: TextFieldType.name,
                      controller: passwordCOntroller,
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
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.red,
                          checkColor: Colors.white,
                          side: BorderSide(width: 1, color: Colors.black),
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          }),
                      const Text(
                        'Remeber me',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      // Get.to(() => const ForgotPasswordPage());
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
              InkWell(
                onTap: () async {
                  await _workIt();
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Constants.color1,
                        Constants.color2,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: _authViewModel.isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'New to VigoPlace?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.to(const RegisterUser());
                    },
                  text: 'Click ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'to get ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'Registered',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(const RegisterUser());
                        },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _workIt() async {
    var _authViewModel = ref.watch(authViewModel);
    setState(() {
      _authViewModel.isLoading = true;
    });
    final FormState? form = _formKey.currentState;
    if (!form!.validate()) {
      setState(() {
        _authViewModel.isLoading = false;
      });
    } else {
      form.save();
      _authViewModel.userLoginService(
          email: emailController.text, password: passwordCOntroller.text);
    }
  }
}
