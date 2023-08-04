import 'package:flutter/cupertino.dart';

@immutable
abstract class ProfileDriverPageEvent {}

class GetProfileDriver extends ProfileDriverPageEvent {}

class GetLogoutDriver extends ProfileDriverPageEvent {}
