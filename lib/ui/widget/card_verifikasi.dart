import 'package:flutter/material.dart';
import '../../common/color_value.dart';

class CardVerifikasi extends StatelessWidget {
  CardVerifikasi({Key? key, required this.jenisVerifikasiProduk, required this.tanggalVerifikasiProduk, required this.namaVerifikasiProduk , required this.descVerifikasiProduk,required this.gambarVerifikasiProduk, required this.statusVerifikasiProduk, required this.onPressed}) : super(key: key);
  final String jenisVerifikasiProduk;
  final String tanggalVerifikasiProduk;
  final String namaVerifikasiProduk;
  final String descVerifikasiProduk;
  final String gambarVerifikasiProduk;
  final String statusVerifikasiProduk;
  final void Function()? onPressed;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: ColorValue.hintColor,
          width: 0.5,
        ),
      ),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                              'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jenisVerifikasiProduk,
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: ColorValue.neutralColor,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            tanggalVerifikasiProduk,
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: ColorValue.neutralColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                  alignment: Alignment.topRight,
                  child: Container(
                    alignment: Alignment.center,
                    height: 20,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: statusVerifikasiProduk == "Pending" ? const Color(0xFFFDF2B2) : statusVerifikasiProduk == "Ditolak" ? const Color(0xFFFFEAEF) : const Color(0xFFD7FEDF)
                    ),
                    child: Text(
                      statusVerifikasiProduk == "Pending" ? "Diproses" : statusVerifikasiProduk == "Rejected" ? "Ditolak" : "Selesai",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: statusVerifikasiProduk == "Pending" ? const Color(0xFFEB6D18) : statusVerifikasiProduk == "Rejected" ? const Color(0xFFD6001C) : ColorValue.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: ColorValue.hintColor,
              thickness: 0.5,
            ),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image:  DecorationImage(
                        image: NetworkImage(gambarVerifikasiProduk),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaVerifikasiProduk,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: ColorValue.neutralColor,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Container(
                        width: 200,
                        child: Text(
                          descVerifikasiProduk,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: ColorValue.hintColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5,),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(85, 25),
                        primary: ColorValue.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Lihat Detail",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
