import 'package:dotted_line/dotted_line.dart';
import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat/model/riwayat_model.dart';
import 'package:driver_kangsayur/ui/widget/main_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailRiwayatPage extends StatefulWidget {
  const DetailRiwayatPage({Key? key, required this.data}) : super(key: key);
  final Datum2 data;

  @override
  State<DetailRiwayatPage> createState() => _DetailRiwayatPageState();
}

class _DetailRiwayatPageState extends State<DetailRiwayatPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Detail Riwayat',
          style: textTheme.headline6!.copyWith(
            color: ColorValue.neutralColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: ColorValue.neutralColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                        'https://kangsayur.nitipaja.online${widget.data.userProfile}'),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.namaPemesan,
                            style: textTheme.bodyText2!.copyWith(
                              color: ColorValue.neutralColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Divider(
                  color: ColorValue.hintColor.withOpacity(0.5),
                  thickness: 1,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cardAlamat(widget.data.alamatToko, widget.data.alamat),
                      const SizedBox(height: 20),
                      Text(
                        'Detail Pembayaran',
                        style: textTheme.bodyText2!.copyWith(
                          color: ColorValue.neutralColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.data.barangPesanan.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.data.barangPesanan[index].namaProduk,
                                style: textTheme.bodyText2!.copyWith(
                                  color: ColorValue.neutralColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                    .format(widget.data.barangPesanan[index].hargaVariant),
                                style: textTheme.bodyText2!.copyWith(
                                  color: ColorValue.neutralColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Ongkos Kirim",
                                style: textTheme.bodyText2!.copyWith(
                                  color: ColorValue.neutralColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                    .format(widget.data.tagihan.ongkosKirim),
                                style: textTheme.bodyText2!.copyWith(
                                  color: ColorValue.neutralColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(
                    indent: 150,
                    endIndent: 0,
                    color: ColorValue.hintColor.withOpacity(0.5),
                    thickness: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: textTheme.bodyText2!.copyWith(
                              color: ColorValue.neutralColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                locale: 'id',
                                symbol: 'Rp ',
                                decimalDigits: 0)
                                .format(widget.data.total),
                            style: textTheme.bodyText2!.copyWith(
                              color: ColorValue.neutralColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Jenis Pembayaran',
                            style: textTheme.bodyText2!.copyWith(
                              color: ColorValue.neutralColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Tunai',
                                style: textTheme.bodyText2!.copyWith(
                                  color: ColorValue.neutralColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.money,
                                size: 24,
                                color: ColorValue.primaryColor,
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: main_button('Download Bukti', context, onPressed: (){},)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardAlamat(String penjemputan, String dropOut){
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ColorValue.hintColor,
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 35, bottom: 10, left: 10),
            child: Column(
              children: [
                Stack(
                  children: const [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: ColorValue.primaryColor,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  width: 1,
                  height: 25,
                  color: ColorValue.hintColor,
                  //break line
                  child: const DottedLine(
                    direction: Axis.vertical,
                    lineThickness: 1.0,
                    dashLength: 5.0,
                    dashColor: ColorValue.neutralColor,
                    dashGapColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Stack(
                  children: const [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: ColorValue.tertiaryColor,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tempat penjemputan barang',
                      style: textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: ColorValue.neutralColor,
                          fontSize: 12
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 300,
                      child: Text(
                        penjemputan.length > 70 ? '${penjemputan.substring(0, 70)}...' : penjemputan,
                        style: textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorValue.neutralColor,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(
                  height: 1,
                  thickness: 0.5,
                  color: ColorValue.neutralColor,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tempat drop out barang',
                          style: textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: ColorValue.neutralColor,
                              fontSize: 12
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 250,
                          child: Text(
                            dropOut.length > 70 ? '${dropOut.substring(0, 70)}...' : dropOut,
                            style: textTheme.bodyText2!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ColorValue.neutralColor,
                                fontSize: 14
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
