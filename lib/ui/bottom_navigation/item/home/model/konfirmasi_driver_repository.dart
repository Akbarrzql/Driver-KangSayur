// To parse this JSON data, do
//
//     final konfirmasiPesananModel = konfirmasiPesananModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

KonfirmasiPesananDriverModel konfirmasiPesananModelFromJson(String str) => KonfirmasiPesananDriverModel.fromJson(json.decode(str));

String konfirmasiPesananModelToJson(KonfirmasiPesananDriverModel data) => json.encode(data.toJson());

class KonfirmasiPesananDriverModel {
  final String message;

  KonfirmasiPesananDriverModel({
    required this.message,
  });

  factory KonfirmasiPesananDriverModel.fromJson(Map<String, dynamic> json) => KonfirmasiPesananDriverModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
