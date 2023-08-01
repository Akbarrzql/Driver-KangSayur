import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/ui/auth/login_page.dart';
import 'package:driver_kangsayur/ui/widget/main_button.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: ColorValue.secondaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 50),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _listData("Nama Driver", "Mr Budiman Wididaw"),
                        const SizedBox(height: 20,),
                        _listData("Nomor Telepon", "085123456789"),
                        const SizedBox(height: 20,),
                        _listData("Kendaraan", "Supra XYZ"),
                        const SizedBox(height: 20,),
                        _listData("Plat Nomor", "B 1234 ABC"),
                        const SizedBox(height: 20,),
                        main_button('Keluar', context, onPressed: (){
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                                  (route) => false
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listData(String tittle, String name){
    final textTheme = Theme.of(context).textTheme;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tittle,
            style: textTheme.headline6!.copyWith(
              color: ColorValue.neutralColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8,),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                name,
                style: TextStyle(
                  color: ColorValue.neutralColor.withOpacity(0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
