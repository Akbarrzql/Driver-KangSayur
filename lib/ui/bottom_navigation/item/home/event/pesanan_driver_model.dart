import 'package:flutter/cupertino.dart';

@immutable
abstract class PesananPageEvent {}

class GetPesanan extends PesananPageEvent {}

class GetKonfirmasi extends PesananPageEvent {
  final String userId;
  final String storeId;
  final String transactionCode;

  GetKonfirmasi(this.transactionCode, this.userId, this.storeId);
}

class FilterPesanan extends PesananPageEvent {
  final String keyword;

  FilterPesanan(this.keyword);
}