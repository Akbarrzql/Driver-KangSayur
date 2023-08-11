import 'package:driver_kangsayur/ui/bottom_navigation/item/home/model/analisa_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AnalisaState{}

class AnalisaInitial extends AnalisaState {}

class AnalisaLoading extends AnalisaState {}

class AnalisaSuccess extends AnalisaState {
  final AnalisaModel analisaModel;

  AnalisaSuccess(this.analisaModel);
}

class AnalisaFailure extends AnalisaState {
  final String errorMessage;

  AnalisaFailure(this.errorMessage);
}