import 'package:driver_kangsayur/ui/bottom_navigation/item/home/model/konfirmasi_driver_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/model/pesanan_driver_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PesananDriverPageState {}

class InitialPesananDriverPageState extends PesananDriverPageState {}

class PesananDriverPageLoading extends PesananDriverPageState {}

class PesananDriverPageLoaded extends PesananDriverPageState {
  final PesananDriverModel pesananDriverModel;

  PesananDriverPageLoaded(this.pesananDriverModel);
}

class KonfirmasiDriverPageLoaded extends PesananDriverPageState {
  final KonfirmasiPesananDriverModel konfirmasiPesananDriverModel;

  KonfirmasiDriverPageLoaded(this.konfirmasiPesananDriverModel);
}

class PesananDriverPageError extends PesananDriverPageState {
  final String errorMessage;

  PesananDriverPageError(this.errorMessage);
}

