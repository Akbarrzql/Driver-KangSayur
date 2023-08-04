import 'package:flutter/cupertino.dart';

@immutable
abstract class RiwayatEvent{}

class GetRiwayat extends RiwayatEvent{}

class FilterProdukRiwayat extends RiwayatEvent {
  final String keyword;

  FilterProdukRiwayat(this.keyword);
}