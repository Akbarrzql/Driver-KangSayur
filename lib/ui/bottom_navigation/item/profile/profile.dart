import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/ui/auth/login_page.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/bloc/profile_driver_bloc.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/event/profile_driver_event.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/repository/logout_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/repository/profile_driver_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/state/profile_driver_state.dart';
import 'package:driver_kangsayur/ui/widget/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (context) => ProfileDriverBloc(profileDriverRepository: ProfileDriverRepository(), logoutRepository: LogoutRepository())..add(GetProfileDriver()),
      child: BlocBuilder<ProfileDriverBloc, ProfileDriverPageState>(
        builder: (context, state) {
          if(state is ProfileDriverPageLoading){
            return shimmerProfile();
          } else if (state is ProfileDriverPageSuccess){
            final data = state.profileDriverModel;
            final mainContext = context;
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
                                _listData("Nama Driver", data.data.name),
                                const SizedBox(height: 20,),
                                _listData("Nomor Telepon", "+62${data.data.phoneNumber.toString()}"),
                                const SizedBox(height: 20,),
                                _listData("Kendaraan", data.data.jenisKendaraan),
                                const SizedBox(height: 20,),
                                _listData("Plat Nomor", data.data.nomorPolisi),
                                const SizedBox(height: 20,),
                                main_button('Keluar', context, onPressed: (){
                                  logout(context, mainContext);
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://kangsayur.nitipaja.online${data.data.photo}'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ProfileDriverPageError){
            return shimmerProfile();
          } else {
            return shimmerProfile();
          }
        },
      )
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

  Widget shimmerProfile(){
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SafeArea(
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
                        _listData("Nama Driver", "Loading..."),
                        const SizedBox(height: 20,),
                        _listData("Nomor Telepon", "Loading..."),
                        const SizedBox(height: 20,),
                        _listData("Kendaraan", "Loading..."),
                        const SizedBox(height: 20,),
                        _listData("Plat Nomor", "Loading..."),
                        const SizedBox(height: 20,),
                        main_button('Keluar', context, onPressed: (){}),
                      ],
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[100],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout(BuildContext context, BuildContext context2) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<ProfileDriverBloc>(context2).add(GetLogoutDriver());
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPage()),
                      (route) => false
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
