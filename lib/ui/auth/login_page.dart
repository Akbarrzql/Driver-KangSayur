import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/ui/auth/bloc/login_bloc.dart';
import 'package:driver_kangsayur/ui/auth/event/login_event.dart';
import 'package:driver_kangsayur/ui/auth/repository/login_repository.dart';
import 'package:driver_kangsayur/ui/auth/state/login_state.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/bottom_navigation.dart';
import 'package:driver_kangsayur/ui/widget/custom_textfield.dart';
import 'package:driver_kangsayur/ui/widget/dialog_alert.dart';
import 'package:driver_kangsayur/validator/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isPasswordVisible = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _emailHasError = false;

  bool _isValidEmail(String email) {
    // Validasi input email menggunakan Regular Expression
    RegExp emailRegex = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        caseSensitive: false,
        multiLine: false);

    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginPageBloc(loginRepository: LoginRepository()),
        child: Scaffold(
          body: BlocConsumer<LoginPageBloc, LoginPageState>(
            listener: (context, state) {},
            builder: (context, state) {
              if(state is InitialLoginPageState){
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Masuk',
                            style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorValue.secondaryColor,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              "Selamat datang, masuk untuk akses anda ke aplikasi driver KangSayur",
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xff1E1E1E),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomTextFormField(
                            controller: _emailController,
                            label: 'Email',
                            textInputType: TextInputType.emailAddress,
                            validator: (value) =>  InputValidator.emailValidator(value),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            controller: _passwordController,
                            label: 'Password',
                            isPassword: true,
                            textInputType: TextInputType.visiblePassword,
                            validator: (value) =>  InputValidator.passwordValidator(value),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Lupa Password?',
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: ColorValue.secondaryColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<LoginPageBloc>(context).add(LoginButtonPressed(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      margin: EdgeInsets.fromLTRB(24, 0, 24, 80),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text('Terdapat kesalahan pada inputan'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: ColorValue.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(
                                'Masuk',
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is LoginPageLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is LoginPageLoaded){
                return const BottomNavigation();
              } else if (state is LoginPageError){
                return const Center(
                  child: Text('Terdapat kesalahan saat login'),
                );
              } else {
                return const Center(
                  child: Text('Terdapat kesalahan saat login'),
                );
              }
            },
          )
        ),
      );
  }

  void showDialogLogin(BuildContext context, String message) {
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      builder: (context) {
        //alert dialog terapat gambar
        return AlertDialog(
          title: Text(
            message,
            style: textTheme.headline6!.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorValue.secondaryColor,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          content: Image.asset(
            'assets/images/food_delivery.png',
            width: 200,
            height: 200,
          ),
          actions: [
            //elevated button in center bottom
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomNavigation(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: ColorValue.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                child: Text(
                  'Mulai perjalanan',
                  style: textTheme.bodyText1!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
