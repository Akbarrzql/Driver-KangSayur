// To parse this JSON data, do
//
//     final selesaiPengirimanModel = selesaiPengirimanModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SelesaiPengirimanModel selesaiPengirimanModelFromJson(String str) => SelesaiPengirimanModel.fromJson(json.decode(str));

String selesaiPengirimanModelToJson(SelesaiPengirimanModel data) => json.encode(data.toJson());

class SelesaiPengirimanModel {
  final String message;

  SelesaiPengirimanModel({
    required this.message,
  });

  factory SelesaiPengirimanModel.fromJson(Map<String, dynamic> json) => SelesaiPengirimanModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
