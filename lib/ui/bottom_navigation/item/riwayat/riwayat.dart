import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat/bloc/riwayat_bloc.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat/event/riwayat_event.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat/model/riwayat_model.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat/repository/riwayat_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat/state/riwayat_state.dart';
import 'package:driver_kangsayur/ui/riwayat/detail_riwayat.dart';
import 'package:driver_kangsayur/ui/widget/card_verifikasi.dart';
import 'package:driver_kangsayur/ui/widget/main_button.dart';
import 'package:flutter/material.dart';
import 'package:driver_kangsayur/ui/widget/checkbox.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Datum2> filteredRiwayatDriver = [];
  final _searchController = TextEditingController();
  List<bool> isChecked = [false, false, false, false];
  List<String> textChip = ['Terbaru', 'Terlama', 'Terjauh', 'Terdekat'];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
        create: (context) =>
            RiwayatDriverBloc(riwayatRepository: RiwayatRepository())
              ..add(GetRiwayat("0")),
        child: BlocBuilder<RiwayatDriverBloc, RiwayatState>(
          builder: (context, state) {
            if (state is RiwayatLoading) {
              return shimmerRiwayat();
            } else if (state is RiwayatSuccess) {
              final riwayat = state.riwayat;
              filteredRiwayatDriver = riwayat.data;
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
                              width: MediaQuery.of(context).size.width * 0.858,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: ColorValue.hintColor,
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  context
                                      .read<RiwayatDriverBloc>()
                                      .add(FilterProdukRiwayat(value));
                                },
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
                                  contentPadding:
                                      const EdgeInsets.only(left: 10),
                                ),
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          height: 30,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: ActionChip(
                                    label: Text(textChip[index]),
                                    labelStyle: textTheme.subtitle1!.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: isChecked[index]
                                            ? Colors.white
                                            : ColorValue.primaryColor),
                                    backgroundColor: isChecked[index]
                                        ? ColorValue.primaryColor
                                        : const Color(0xFFD7FEDF),
                                    onPressed: () {
                                      setState(() {
                                        isChecked[index] = !isChecked[index];
                                        BlocProvider.of<RiwayatDriverBloc>(
                                                context)
                                            .add(GetRiwayat(index.toString()));
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        filteredRiwayatDriver.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.network(
                                        "https://assets2.lottiefiles.com/packages/lf20_md6cjjSl1R.json",
                                        height: 200,
                                        width: 200),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Text(
                                        'Riwayat kamu masih kosong nih, yuk mulai perjalananmu sekarang!',
                                        textAlign: TextAlign.center,
                                        style: textTheme.headline6!.copyWith(
                                            color: ColorValue.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: filteredRiwayatDriver.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CardVerifikasi(
                                    tanggalVerifikasiProduk:
                                        filteredRiwayatDriver[index].dipesan,
                                    namaVerifikasiProduk:
                                        filteredRiwayatDriver[index]
                                            .barangPesanan[0]
                                            .namaProduk,
                                    descVerifikasiProduk:
                                        filteredRiwayatDriver[index]
                                            .barangPesanan[0]
                                            .variantDesc,
                                    gambarVerifikasiProduk:
                                        'https://kangsayur.nitipaja.online${filteredRiwayatDriver[index].barangPesanan[0].variantImg}',
                                    statusVerifikasiProduk:
                                        filteredRiwayatDriver[index]
                                            .barangPesanan[0]
                                            .status,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailRiwayatPage(
                                            data: filteredRiwayatDriver[index],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                      ],
                    ),
                  ),
                ),
              ));
            } else if (state is FilteredRiwayat) {
              filteredRiwayatDriver = state.filteredRiwayat;
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
                              width: MediaQuery.of(context).size.width * 0.858,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: ColorValue.hintColor,
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  context
                                      .read<RiwayatDriverBloc>()
                                      .add(FilterProdukRiwayat(value));
                                },
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
                                  contentPadding:
                                      const EdgeInsets.only(left: 10),
                                ),
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ActionChip(
                                    label: Text(textChip[index]),
                                    labelStyle: textTheme.subtitle1!.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: isChecked[index]
                                            ? ColorValue.primaryColor
                                            : ColorValue.neutralColor),
                                    backgroundColor: isChecked[index]
                                        ? ColorValue.primaryColor.withOpacity(0.2)
                                        : ColorValue.neutralColor.withOpacity(0.2),
                                    onPressed: () {
                                      setState(() {
                                        isChecked[index] = !isChecked[index];

                                        BlocProvider.of<RiwayatDriverBloc>(
                                            context)
                                            .add(GetRiwayat(index.toString()));
                                      });
                                    },
                                  ),
                                );
                              },
                            )
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        filteredRiwayatDriver.isEmpty
                            ? Center(
                                //lotie loading
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.network(
                                        "https://assets2.lottiefiles.com/packages/lf20_md6cjjSl1R.json",
                                        height: 200,
                                        width: 200),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Text(
                                        'Riwayat kamu masih kosong nih, yuk mulai perjalananmu sekarang!',
                                        textAlign: TextAlign.center,
                                        style: textTheme.headline6!.copyWith(
                                            color: ColorValue.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: filteredRiwayatDriver.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CardVerifikasi(
                                    tanggalVerifikasiProduk:
                                        filteredRiwayatDriver[index].dipesan,
                                    namaVerifikasiProduk:
                                        filteredRiwayatDriver[index]
                                            .barangPesanan[0]
                                            .namaProduk,
                                    descVerifikasiProduk:
                                        filteredRiwayatDriver[index]
                                            .barangPesanan[0]
                                            .variantDesc,
                                    gambarVerifikasiProduk:
                                        'https://kangsayur.nitipaja.online${filteredRiwayatDriver[index].barangPesanan[0].variantImg}',
                                    statusVerifikasiProduk:
                                        filteredRiwayatDriver[index]
                                            .barangPesanan[0]
                                            .status,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailRiwayatPage(
                                            data: filteredRiwayatDriver[index],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                      ],
                    ),
                  ),
                ),
              ));
            } else if (state is RiwayatError) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              );
            } else {
              return shimmerRiwayat();
            }
          },
        ));
  }

  void bottomSheet(BuildContext context) {
    final mainContext = context;
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
          //row cehckbox 2
          return Container(
            height: 180,
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
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: ColorValue.neutralColor,
                  thickness: 1,
                  height: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
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
                              checkBox(
                                isChecked[0],
                                'Terbaru',
                                (value) {
                                  setState(() {
                                    isChecked[0] = value!;
                                    BlocProvider.of<RiwayatDriverBloc>(
                                            mainContext)
                                        .add(GetRiwayat("0"));
                                  });
                                },
                              ),
                              checkBox(
                                isChecked[1],
                                'Terlama',
                                (value) {
                                  setState(() {
                                    isChecked[1] = value!;
                                    BlocProvider.of<RiwayatDriverBloc>(
                                            mainContext)
                                        .add(GetRiwayat("1"));
                                  });
                                },
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              checkBox(
                                isChecked[1],
                                'Terjauh',
                                (value) {
                                  setState(() {
                                    isChecked[2] = value!;
                                    BlocProvider.of<RiwayatDriverBloc>(
                                            mainContext)
                                        .add(GetRiwayat("2"));
                                  });
                                },
                              ),
                              checkBox(
                                isChecked[3],
                                'Terdekat',
                                (value) {
                                  setState(() {
                                    isChecked[3] = value!;
                                    BlocProvider.of<RiwayatDriverBloc>(
                                            mainContext)
                                        .add(GetRiwayat("3"));
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // main_button('Terapkan', context, onPressed: () {
                      //   Navigator.pop(context);
                      // }),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget shimmerRiwayat() {
    final textTheme = Theme.of(context).textTheme;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
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
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text(textChip[index]),
                          labelStyle: textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: isChecked[index]
                                  ? ColorValue.primaryColor
                                  : ColorValue.neutralColor),
                          backgroundColor: isChecked[index]
                              ? ColorValue.primaryColor.withOpacity(0.2)
                              : ColorValue.neutralColor.withOpacity(0.2),
                          onPressed: () {
                            setState(() {
                              isChecked[index] = !isChecked[index];
                            });
                          },
                        ),
                      );
                    },
                  )
                ),
                const SizedBox(
                  height: 24,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return CardVerifikasi(
                      tanggalVerifikasiProduk: '2021-08-20',
                      namaVerifikasiProduk: 'Bawang Merah',
                      descVerifikasiProduk: 'Bawang merah ukuran besar',
                      gambarVerifikasiProduk:
                          'https://images.unsplash.com/photo-1597362925123-77861d3fbac7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dmVnZXRhYmxlc3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60',
                      statusVerifikasiProduk: 'Selesai',
                      onPressed: () {},
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget checkBox(
    bool isCheckbox,
    final String name,
    void Function(bool?)? onChanged,
  ) {
    return Row(
      children: [
        Checkbox(
          value: isCheckbox,
          onChanged:
              onChanged != null ? (newValue) => onChanged(newValue) : null,
        ),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
