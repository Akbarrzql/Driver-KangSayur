// To parse this JSON data, do
//
//     final analisaModel = analisaModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AnalisaModel analisaModelFromJson(String str) => AnalisaModel.fromJson(json.decode(str));

String analisaModelToJson(AnalisaModel data) => json.encode(data.toJson());

class AnalisaModel {
  final String status;
  final String message;
  final Data data;

  AnalisaModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AnalisaModel.fromJson(Map<String, dynamic> json) => AnalisaModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  final num jumlahMengatar;
  final num totalJarak;

  Data({
    required this.jumlahMengatar,
    required this.totalJarak,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    jumlahMengatar: json["jumlah_mengatar"],
    totalJarak: json["total_jarak"],
  );

  Map<String, dynamic> toJson() => {
    "jumlah_mengatar": jumlahMengatar,
    "total_jarak": totalJarak,
  };
}
