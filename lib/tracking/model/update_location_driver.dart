// To parse this JSON data, do
//
//     final updateLokasiModel = updateLokasiModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UpdateLokasiModel updateLokasiModelFromJson(String str) => UpdateLokasiModel.fromJson(json.decode(str));

String updateLokasiModelToJson(UpdateLokasiModel data) => json.encode(data.toJson());

class UpdateLokasiModel {
  final String status;
  final String message;

  UpdateLokasiModel({
    required this.status,
    required this.message,
  });

  factory UpdateLokasiModel.fromJson(Map<String, dynamic> json) => UpdateLokasiModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
