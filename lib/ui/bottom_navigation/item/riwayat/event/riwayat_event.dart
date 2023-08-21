import 'package:flutter/cupertino.dart';

@immutable
abstract class RiwayatEvent{}

class GetRiwayat extends RiwayatEvent{
  final String filterId;

  GetRiwayat(this.filterId);
}

class FilterProdukRiwayat extends RiwayatEvent {
  final String keyword;

  FilterProdukRiwayat(this.keyword);
}