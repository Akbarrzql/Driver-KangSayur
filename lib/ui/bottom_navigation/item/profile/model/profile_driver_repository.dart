// To parse this JSON data, do
//
//     final profileDriverdModel = profileDriverdModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProfileDriverdModel profileDriverdModelFromJson(String str) => ProfileDriverdModel.fromJson(json.decode(str));

String profileDriverdModelToJson(ProfileDriverdModel data) => json.encode(data.toJson());

class ProfileDriverdModel {
  final int status;
  final String message;
  final Data data;

  ProfileDriverdModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProfileDriverdModel.fromJson(Map<String, dynamic> json) => ProfileDriverdModel(
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
  final int driverId;
  final String photo;
  final String name;
  final int phoneNumber;
  final String jenisKendaraan;
  final String nomorPolisi;

  Data({
    required this.driverId,
    required this.photo,
    required this.name,
    required this.phoneNumber,
    required this.jenisKendaraan,
    required this.nomorPolisi,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    driverId: json["driver_id"],
    photo: json["photo"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    jenisKendaraan: json["jenis_kendaraan"],
    nomorPolisi: json["nomor_polisi"],
  );

  Map<String, dynamic> toJson() => {
    "driver_id": driverId,
    "photo": photo,
    "name": name,
    "phone_number": phoneNumber,
    "jenis_kendaraan": jenisKendaraan,
    "nomor_polisi": nomorPolisi,
  };
}
