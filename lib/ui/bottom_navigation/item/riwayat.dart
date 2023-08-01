import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/ui/riwayat/detail_riwayat.dart';
import 'package:driver_kangsayur/ui/widget/card_verifikasi.dart';
import 'package:driver_kangsayur/ui/widget/main_button.dart';
import 'package:flutter/material.dart';
import 'package:driver_kangsayur/ui/widget/checkbox.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {

  final _searchController = TextEditingController();
  final bool _isCheckbox2 = false;
  final bool _isCheckbox3 = false;
  final bool _isCheckbox4 = false;
  final bool _isCheckbox5 = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
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
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: ColorValue.hintColor,
                          ),
                          hintText: 'Cari alamat pengantaran',
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
                    GestureDetector(
                      onTap: (){
                        bottomSheet();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: ColorValue.hintColor,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.tune,
                          color: ColorValue.hintColor,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24,),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return CardVerifikasi(
                      jenisVerifikasiProduk: 'Bahan Pokok',
                      tanggalVerifikasiProduk: '5 Maret 2023',
                      namaVerifikasiProduk: 'Brokoli / 1KG',
                      descVerifikasiProduk: '1 Kilogram Brokoli dari petani lokal',
                      // gambarVerifikasiProduk: 'assets/images/wortel.png',
                      statusVerifikasiProduk: 'Selesai',
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailRiwayatPage(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
  
  void bottomSheet(){
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
        builder: (context){
          //row cehckbox 2
          return Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, top: 15, bottom: 5),
                  child: Text(
                    'Filter',
                    style: textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
                Divider(
                  color: ColorValue.neutralColor,
                  thickness: 1,
                  height: 2,
                ),
                const SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ModalCheckbox(
                                isCheckbox: _isCheckbox2,
                                name: 'Terbaru',
                              ),
                              ModalCheckbox(
                                isCheckbox: _isCheckbox3,
                                name: 'Terlama',
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ModalCheckbox(
                                isCheckbox: _isCheckbox4,
                                name: 'Terjauh',
                              ),
                              ModalCheckbox(
                                isCheckbox: _isCheckbox5,
                                name: 'Terdekat',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      main_button('Terapkan', context, onPressed: (){}),
                    ],
                  ),
                )

              ],
            ),
          );
        }
    );
  }
}
