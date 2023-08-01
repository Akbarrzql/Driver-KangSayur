import 'package:driver_kangsayur/tracking/model/selesai_driver_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class UpdateLocationPageState {}

class InitialUpdateLocationPageState extends UpdateLocationPageState {}

class UpdateLocationPageLoading extends UpdateLocationPageState {}

class UpdateLocationPageLoaded extends UpdateLocationPageState {}

class SelesaiUpdateLocationPage extends UpdateLocationPageState {
  final SelesaiPengirimanModel selesaiPengirimanModel;

  SelesaiUpdateLocationPage(this.selesaiPengirimanModel);
}

class UpdateLocationPageError extends UpdateLocationPageState {
  final String errorMessage;

  UpdateLocationPageError(this.errorMessage);
}
