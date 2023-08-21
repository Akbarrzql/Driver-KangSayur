import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/tracking/tracking_driver.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/bloc/analisa_bloc.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/bloc/pesanan_driver_bloc.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/event/analisa_event.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/event/pesanan_driver_model.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/item/map_view.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/model/pesanan_driver_model.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/repository/analisa_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/repository/home_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/repository/konfirmasi_driver_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/state/analisa_state.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/state/pesanan_driver_state.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/bloc/profile_driver_bloc.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/event/profile_driver_event.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/repository/logout_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/repository/profile_driver_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/state/profile_driver_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_action/slide_action.dart';
import 'package:intl/intl.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {

  List<Datum> _filteredHome = [];
  DateTimeRange? selectedDate;
  TextEditingController _searchController = TextEditingController();
  bool isFinish = false;
  late PesananDriverBloc pesananDriverBloc;
  late AnalisaPageBloc analisaPageBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pesananDriverBloc = PesananDriverBloc(konfirmasiDriverRepository: KonfirmasiRepository(), pesananDriverRepository: PesananDriverRepository());
    analisaPageBloc = AnalisaPageBloc(analisaPageRepository: AnalisaRepository());
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshPesananDriverPage,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocProvider(
                    create: (context) => ProfileDriverBloc(profileDriverRepository: ProfileDriverRepository(), logoutRepository: LogoutRepository())..add(GetProfileDriver()),
                    child: BlocBuilder<ProfileDriverBloc, ProfileDriverPageState>(
                      builder: (context, state) {
                        if(state is ProfileDriverPageLoading){
                          return shimmerProfileHome();
                        } else if (state is ProfileDriverPageSuccess){
                          final profileDriverModel = state.profileDriverModel;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(
                                    'https://kangsayur.nitipaja.online${profileDriverModel.data.photo}'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Halo, ${profileDriverModel.data.name}',
                                style: textTheme.bodyText1!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: ColorValue.neutralColor),
                              ),
                            ],
                          );
                        } else if (state is ProfileDriverPageError){
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(
                                      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 20,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(
                                      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 20,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
                  BlocProvider(
                    create: (context) => analisaPageBloc..add(GetAnalisa()),
                    child: BlocBuilder<AnalisaPageBloc, AnalisaState>(
                      builder: (context, state) {
                        if(state is AnalisaLoading){
                          return shimmerAnalisa();
                        }else if (state is AnalisaSuccess){
                          final analisaModel = state.analisaModel;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Analisa',
                                    style: textTheme.headline5!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: ColorValue.secondaryColor,
                                        fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              GridView.count(
                                controller: ScrollController(keepScrollOffset: false),
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                childAspectRatio: 1.8,
                                children: [
                                  card_analytic(ColorValue.secondaryColor, "Total mengantar", analisaModel.data.jumlahMengatar.toString()),
                                  card_analytic(const Color(0xFFEE6C4D), "Jarak perjalanan", "${analisaModel.data.totalJarak.toStringAsFixed(1)} Km"),
                                ],
                              ),
                            ],
                          );
                        }else if (state is AnalisaFailure){
                          print(state.errorMessage);
                          return Center(
                            child: Text(
                              state.errorMessage,
                              style: textTheme.subtitle1!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: ColorValue.hintColor),
                            ),
                          );
                        }else {
                          return shimmerAnalisa();
                        }
                      },
                    )
                  ),
                  const SizedBox(height: 20,),
                  BlocProvider(
                      create: (context) => pesananDriverBloc..add(GetPesanan()),
                      child: BlocBuilder<PesananDriverBloc, PesananDriverPageState>(
                        builder: (context, state) {
                          if(state is PesananDriverPageLoading){
                            return shimmerList();
                          } else if (state is PesananDriverPageLoaded){
                            final pesananDriverModel = state.pesananDriverModel;
                            _filteredHome = pesananDriverModel.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Anterin',
                                  style: textTheme.headline5!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: ColorValue.secondaryColor,
                                      fontSize: 16
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total barang yang harus diantar: ',
                                      style: textTheme.subtitle1!.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: ColorValue.hintColor),
                                    ),
                                    Text(
                                      _filteredHome.length.toString(),
                                      style: textTheme.subtitle1!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: ColorValue.neutralColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width * 0.7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: ColorValue.hintColor,
                                          width: 1,
                                        ),
                                      ),
                                      //child textfield
                                      child: TextField(
                                        onChanged: (value) {
                                          context.read<PesananDriverBloc>().add(FilterPesanan(value));
                                        },
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            color: ColorValue.hintColor,
                                          ),
                                          hintText: 'Cari Nama Pemesan',
                                          hintStyle: textTheme.subtitle1!.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: ColorValue.hintColor),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.only(left: 10),
                                        ),
                                        textAlign: TextAlign.left,
                                        textAlignVertical: TextAlignVertical.center,
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: ColorValue.hintColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const MapViewDriver(),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.map_outlined,
                                          color: ColorValue.hintColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _filteredHome.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: 185,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: ColorValue.primaryColor,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: ColorValue.hintColor,
                                          width: 0.5,
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 125,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: ColorValue.hintColor,
                                                  width: 0.5,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 24,
                                                        backgroundImage: NetworkImage(
                                                            'https://kangsayur.nitipaja.online/${_filteredHome[index].userProfile}'),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            _filteredHome[0].namaPemesan,
                                                            style: textTheme.subtitle1!.copyWith(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 16,
                                                                color: ColorValue.neutralColor),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Dipesan :',
                                                                style: textTheme.subtitle1!.copyWith(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14,
                                                                    color: ColorValue.neutralColor),
                                                              ),
                                                              Text(
                                                                _filteredHome[0].dipesan,
                                                                style: textTheme.subtitle1!.copyWith(
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 14,
                                                                    color: ColorValue.hintColor),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const SizedBox(height: 20),
                                                              Container(
                                                                width: 200,
                                                                child: Text(
                                                                  _filteredHome[index].barangPesanan[0].namaProduk,
                                                                  style: textTheme.subtitle1!.copyWith(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 14,
                                                                      color: ColorValue.neutralColor),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(context).size.width * 0.09,
                                                                child: Text(
                                                                  _filteredHome[index].barangPesanan[0].jumlahPembelian.toString(),
                                                                  style: textTheme.subtitle1!.copyWith(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 14,
                                                                      color: ColorValue.neutralColor),
                                                                  textAlign: TextAlign.right,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 55,),
                                                  Row(
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          bottom_sheet(context, navigate: () {
                                                            pesananDriverBloc.add(GetKonfirmasi(
                                                              _filteredHome[index].barangPesanan[0].userId.toString(),
                                                              _filteredHome[index].barangPesanan[0].storeId.toString(),
                                                              _filteredHome[index].barangPesanan[0].transactionCode.toString(),
                                                            ));
                                                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TrackingDriver(
                                                              transactionCode : _filteredHome[index].barangPesanan[0].transactionCode.toString(),
                                                              latUser:_filteredHome[index].userLat,
                                                              longUser: _filteredHome[index].userLong,
                                                              detailpesananDriverModel: _filteredHome[index],
                                                            ),), (route) => false);
                                                          },);
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          primary: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          'Antar',
                                                          style: textTheme.subtitle1!.copyWith(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 14,
                                                              color: ColorValue.neutralColor),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Total : ',
                                                            style: textTheme.subtitle1!.copyWith(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 14,
                                                                color: Colors.white),
                                                          ),
                                                          Text(
                                                            NumberFormat.currency(
                                                                locale: 'id',
                                                                symbol: 'Rp ',
                                                                decimalDigits: 0)
                                                                .format(_filteredHome[index].total),
                                                            style: textTheme.subtitle1!.copyWith(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 14,
                                                                color: Colors.white),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            );
                          }else if(state is FilteredHome){
                            _filteredHome = state.filteredHome;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Anterin',
                                  style: textTheme.headline5!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: ColorValue.secondaryColor,
                                      fontSize: 16
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total barang yang harus diantar: ',
                                      style: textTheme.subtitle1!.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: ColorValue.hintColor),
                                    ),
                                    Text(
                                      _filteredHome.length.toString(),
                                      style: textTheme.subtitle1!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: ColorValue.neutralColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width * 0.7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: ColorValue.hintColor,
                                          width: 1,
                                        ),
                                      ),
                                      //child textfield
                                      child: TextField(
                                        onChanged: (value) {
                                          context.read<PesananDriverBloc>().add(FilterPesanan(value));
                                        },
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            color: ColorValue.hintColor,
                                          ),
                                          hintText: 'Cari Nama Pemesan',
                                          hintStyle: textTheme.subtitle1!.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: ColorValue.hintColor),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.only(left: 10),
                                        ),
                                        textAlign: TextAlign.left,
                                        textAlignVertical: TextAlignVertical.center,
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: ColorValue.hintColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const MapViewDriver(),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.map_outlined,
                                          color: ColorValue.hintColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _filteredHome.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: 185,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: ColorValue.primaryColor,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: ColorValue.hintColor,
                                          width: 0.5,
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 125,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: ColorValue.hintColor,
                                                  width: 0.5,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 24,
                                                        backgroundImage: NetworkImage(
                                                            'https://kangsayur.nitipaja.online/${_filteredHome[index].userProfile}'),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            _filteredHome[0].namaPemesan,
                                                            style: textTheme.subtitle1!.copyWith(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 16,
                                                                color: ColorValue.neutralColor),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Dipesan :',
                                                                style: textTheme.subtitle1!.copyWith(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14,
                                                                    color: ColorValue.neutralColor),
                                                              ),
                                                              Text(
                                                                _filteredHome[0].dipesan,
                                                                style: textTheme.subtitle1!.copyWith(
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 14,
                                                                    color: ColorValue.hintColor),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const SizedBox(height: 20),
                                                              Container(
                                                                width: 200,
                                                                child: Text(
                                                                  _filteredHome[index].barangPesanan[0].namaProduk,
                                                                  style: textTheme.subtitle1!.copyWith(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 14,
                                                                      color: ColorValue.neutralColor),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(context).size.width * 0.09,
                                                                child: Text(
                                                                  _filteredHome[index].barangPesanan[0].jumlahPembelian.toString(),
                                                                  style: textTheme.subtitle1!.copyWith(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 14,
                                                                      color: ColorValue.neutralColor),
                                                                  textAlign: TextAlign.right,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 55,),
                                                  Row(
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          bottom_sheet(context, navigate: () {
                                                            pesananDriverBloc.add(GetKonfirmasi(
                                                              _filteredHome[index].barangPesanan[0].userId.toString(),
                                                              _filteredHome[index].barangPesanan[0].storeId.toString(),
                                                              _filteredHome[index].barangPesanan[0].transactionCode.toString(),
                                                            ));
                                                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TrackingDriver(
                                                              transactionCode : _filteredHome[index].barangPesanan[0].transactionCode.toString(),
                                                              latUser:_filteredHome[index].userLat,
                                                              longUser: _filteredHome[index].userLong,
                                                              detailpesananDriverModel: _filteredHome[index],
                                                            ),), (route) => false);
                                                          },);
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          primary: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          'Antar',
                                                          style: textTheme.subtitle1!.copyWith(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 14,
                                                              color: ColorValue.neutralColor),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Total : ',
                                                            style: textTheme.subtitle1!.copyWith(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 14,
                                                                color: Colors.white),
                                                          ),
                                                          Text(
                                                            NumberFormat.currency(
                                                                locale: 'id',
                                                                symbol: 'Rp ',
                                                                decimalDigits: 0)
                                                                .format(_filteredHome[index].total),
                                                            style: textTheme.subtitle1!.copyWith(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 14,
                                                                color: Colors.white),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            );
                          }
                          else if (state is PesananDriverPageError){
                            return shimmerList();
                          } else {
                            return shimmerList();
                          }
                        },
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  //bottom sheet
  void bottom_sheet(BuildContext context, {VoidCallback? navigate}){
    final textTheme = Theme.of(context).textTheme;
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Image(
                  image: AssetImage('assets/images/food_delivery.png'),
                  height: 150,
                  width: 150,
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                'Peringatan !',
                style: textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: ColorValue.neutralColor),
              ),
              const SizedBox(height: 10,),
              Text(
                'Pesanan yang kamu antar tidak bisa kamu batalkan lho! jadi hati-hati dalam pemilihan',
                style: textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: ColorValue.hintColor),
              ),
              const SizedBox(height: 20,),
              SlideAction(
                trackBuilder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        // Show loading if async operation is being performed
                        state.isPerformingAction
                            ? "Tunggu sebentar..."
                            : "Mengantar Pesanan",
                        style: textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ColorValue.neutralColor)
                      ),
                    ),
                  );
                },
                thumbBuilder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorValue.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      // Show loading indicator if async operation is being performed
                      child: state.isPerformingAction
                          ? const CupertinoActivityIndicator(
                        color: Colors.white,
                      )
                          : const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                action: () async {
                  await Future.delayed(
                    const Duration(seconds: 2),
                    navigate,
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget shimmerAnalisa(){
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 10,),
          GridView.count(
            controller: ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: ColorValue.hintColor,
                    width: 0.5,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: ColorValue.hintColor,
                    width: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget card_analytic(Color color, String title, String value) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
          padding: const EdgeInsets.all(10),
          height: 100,
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white),
              ),
              const Spacer(),
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white),
              ),
            ],
          )),
    );
  }


  Future<void> showDatePickerDialog(BuildContext context, int variableIndex) async {
    //date range picker dialog
    final DateTimeRange? pickedDate = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now()),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      setState(() {
        switch (variableIndex) {
          case 1:
            selectedDate = pickedDate;
            break;
          default:
            break;
        }
      });
    }
  }

  Future<void> _refreshPesananDriverPage() async {
    pesananDriverBloc.add(GetPesanan());
    analisaPageBloc.add(GetAnalisa());
    ProfileDriverBloc(profileDriverRepository: ProfileDriverRepository(), logoutRepository: LogoutRepository()).add(GetProfileDriver());
  }

  Widget shimmerList(){
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 5,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 10,),
              Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Container(
            height: 185,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: ColorValue.hintColor,
                width: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            height: 185,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: ColorValue.hintColor,
                width: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget shimmerProfileHome(){
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}
