import 'package:flutter/material.dart';

import '../../common/color_value.dart';

class ListChart extends StatelessWidget {
  const ListChart({Key? key, required this.imagePelanggan, required this.namePelanggan, required this.pesanPelanggan, required this.waktuPesan, required this.onTap}) : super(key: key);
  final String imagePelanggan;
  final String namePelanggan;
  final String pesanPelanggan;
  final String waktuPesan;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: AssetImage(imagePelanggan),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namePelanggan,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: ColorValue.neutralColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        pesanPelanggan,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: ColorValue.neutralColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    waktuPesan,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: ColorValue.neutralColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.red,
                    ),
                    child: const Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(
            height: 1,
            color: ColorValue.hintColor,
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
