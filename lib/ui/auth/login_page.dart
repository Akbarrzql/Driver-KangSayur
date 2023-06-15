import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/ui/widget/dialog_alert.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: SafeArea(
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorValue.hintColor,
                      width: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: ColorValue.hintColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorValue.hintColor,
                      width: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: isPasswordVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: ColorValue.hintColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: ColorValue.hintColor,
                          ),
                        ),
                      ),
                    ),
                  ),
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
                      if(_emailController.text.isEmpty) {
                        setState(() {
                          _emailHasError = true;
                        });
                        showErrorDialog(context, "Perhatian" ,'Email tidak boleh kosong');
                      } else if(!_isValidEmail(_emailController.text)) {
                        setState(() {
                          _emailHasError = true;
                        });
                        showErrorDialog(context, "Perhatian" ,'Email tidak valid');
                      } else if(_passwordController.text.isEmpty) {
                        showErrorDialog(context, 'Perhatian', 'Password tidak boleh kosong');
                      } else if(_passwordController.text.length < 6) {
                        showErrorDialog(context, 'perhatian', 'Password minimal 6 karakter');
                      } else {
                        showDialogLogin(context, 'Selamat Datang, Sudah siap untuk mengantar pesanan?');
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
                onPressed: () {},
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
