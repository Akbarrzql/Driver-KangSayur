import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat/model/riwayat_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class RiwayatState{}

class RiwayatInitial extends RiwayatState{}

class RiwayatLoading extends RiwayatState{}

class RiwayatSuccess extends RiwayatState{
  final RiwayatModel riwayat;

  RiwayatSuccess(this.riwayat);
}

class FilteredRiwayat extends RiwayatState{
  final List<Datum2> filteredRiwayat;

  FilteredRiwayat(this.filteredRiwayat);
}

class RiwayatError extends RiwayatState{
  final String errorMessage;

  RiwayatError(this.errorMessage);
}