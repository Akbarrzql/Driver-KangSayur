import 'package:flutter/cupertino.dart';

@immutable
abstract class UpdateLocationPageEvent {}

class UpdateLocation extends UpdateLocationPageEvent {
  final String latitude;
  final String longitude;
  final String transactionCode;

  UpdateLocation({required this.latitude, required this.longitude, required this.transactionCode});
}

class SelesaiPengiriman extends UpdateLocationPageEvent {
  final String userId;
  final String storeId;
  final String transactionCode;

  SelesaiPengiriman(this.userId, this.storeId, this.transactionCode);
}