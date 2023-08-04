import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/model/profile_driver_repository.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ProfileDriverPageState {}

class ProfileDriverPageInitial extends ProfileDriverPageState {}

class ProfileDriverPageLoading extends ProfileDriverPageState {}

class ProfileDriverPageSuccess extends ProfileDriverPageState {
  final ProfileDriverdModel profileDriverModel;

  ProfileDriverPageSuccess(this.profileDriverModel);
}

class LogoutDriver extends ProfileDriverPageState{}

class ProfileDriverPageError extends ProfileDriverPageState {
  final String errorMessage;

  ProfileDriverPageError(this.errorMessage);
}