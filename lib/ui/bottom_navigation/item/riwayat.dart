import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/ui/widget/card_verifikasi.dart';
import 'package:flutter/material.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
                    child: const Icon(
                      Icons.tune,
                      color: ColorValue.hintColor,
                    ),
                  ),
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
                    onPressed: (){},
                  );
                },
              ),
            ],
          ),
        ),
      )
    );
  }


}
