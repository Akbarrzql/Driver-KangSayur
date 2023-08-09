// To parse this JSON data, do
//
//     final riwayatModel = riwayatModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RiwayatModel riwayatModelFromJson(String str) => RiwayatModel.fromJson(json.decode(str));

String riwayatModelToJson(RiwayatModel data) => json.encode(data.toJson());

class RiwayatModel {
  final String status;
  final String message;
  final List<Datum2> data;

  RiwayatModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RiwayatModel.fromJson(Map<String, dynamic> json) => RiwayatModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum2>.from(json["data"].map((x) => Datum2.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum2 {
  final String userProfile;
  final String namaPemesan;
  final int nomorTelfon;
  final String alamat;
  final double userLat;
  final double userLong;
  final String alamatToko;
  final double tokoLat;
  final double tokoLong;
  final int userId;
  final String dipesan;
  final String kategori;
  final List<BarangPesanan> barangPesanan;
  final Tagihan tagihan;
  final double total;

  Datum2 ({
    required this.userProfile,
    required this.namaPemesan,
    required this.nomorTelfon,
    required this.alamat,
    required this.userLat,
    required this.userLong,
    required this.alamatToko,
    required this.tokoLat,
    required this.tokoLong,
    required this.userId,
    required this.dipesan,
    required this.kategori,
    required this.barangPesanan,
    required this.tagihan,
    required this.total,
  });

  factory Datum2.fromJson(Map<String, dynamic> json) => Datum2(
    userProfile: json["user_profile"],
    namaPemesan: json["nama_pemesan"],
    nomorTelfon: json["nomor_telfon"],
    alamat: json["alamat"],
    userLat: json["user_lat"]?.toDouble(),
    userLong: json["user_long"]?.toDouble(),
    alamatToko: json["alamat_toko"],
    tokoLat: json["toko_lat"]?.toDouble(),
    tokoLong: json["toko_long"]?.toDouble(),
    userId: json["user_id"],
    dipesan: json["dipesan"],
    kategori: json["kategori"],
    barangPesanan: List<BarangPesanan>.from(json["barang_pesanan"].map((x) => BarangPesanan.fromJson(x))),
    tagihan: Tagihan.fromJson(json["tagihan"]),
    total: json["total"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "user_profile": userProfile,
    "nama_pemesan": namaPemesan,
    "nomor_telfon": nomorTelfon,
    "alamat": alamat,
    "user_lat": userLat,
    "user_long": userLong,
    "alamat_toko": alamatToko,
    "toko_lat": tokoLat,
    "toko_long": tokoLong,
    "user_id": userId,
    "dipesan": dipesan,
    "kategori": kategori,
    "barang_pesanan": List<dynamic>.from(barangPesanan.map((x) => x.toJson())),
    "tagihan": tagihan.toJson(),
    "total": total,
  };
}

class BarangPesanan {
  final int id;
  final int transactionCode;
  final int productId;
  final int variantId;
  final int storeId;
  final int userId;
  final String notes;
  final int alamatId;
  final String statusDiulas;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String variantImg;
  final String variant;
  final String variantDesc;
  final int stok;
  final int hargaVariant;
  final String namaProduk;
  final double? rating;
  final int kategoriId;
  final int tokoId;
  final int ulasanId;
  final int isOnsale;
  final int jumlahPembelian;

  BarangPesanan({
    required this.id,
    required this.transactionCode,
    required this.productId,
    required this.variantId,
    required this.storeId,
    required this.userId,
    required this.notes,
    required this.alamatId,
    required this.statusDiulas,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.variantImg,
    required this.variant,
    required this.variantDesc,
    required this.stok,
    required this.hargaVariant,
    required this.namaProduk,
    required this.rating,
    required this.kategoriId,
    required this.tokoId,
    required this.ulasanId,
    required this.isOnsale,
    required this.jumlahPembelian,
  });

  factory BarangPesanan.fromJson(Map<String, dynamic> json) => BarangPesanan(
    id: json["id"],
    transactionCode: json["transaction_code"],
    productId: json["product_id"],
    variantId: json["variant_id"],
    storeId: json["store_id"],
    userId: json["user_id"],
    notes: json["notes"],
    alamatId: json["alamat_id"],
    statusDiulas: json["status_diulas"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    variantImg: json["variant_img"],
    variant: json["variant"],
    variantDesc: json["variant_desc"],
    stok: json["stok"],
    hargaVariant: json["harga_variant"],
    namaProduk: json["nama_produk"],
    rating: json["rating"]?.toDouble(),
    kategoriId: json["kategori_id"],
    tokoId: json["toko_id"],
    ulasanId: json["ulasan_id"],
    isOnsale: json["is_onsale"],
    jumlahPembelian: json["jumlah_pembelian"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaction_code": transactionCode,
    "product_id": productId,
    "variant_id": variantId,
    "store_id": storeId,
    "user_id": userId,
    "notes": notes,
    "alamat_id": alamatId,
    "status_diulas": statusDiulas,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "variant_img": variantImg,
    "variant": variant,
    "variant_desc": variantDesc,
    "stok": stok,
    "harga_variant": hargaVariant,
    "nama_produk": namaProduk,
    "rating": rating,
    "kategori_id": kategoriId,
    "toko_id": tokoId,
    "ulasan_id": ulasanId,
    "is_onsale": isOnsale,
    "jumlah_pembelian": jumlahPembelian,
  };
}

class Tagihan {
  final int totalHarga;
  final double ongkosKirim;

  Tagihan({
    required this.totalHarga,
    required this.ongkosKirim,
  });

  factory Tagihan.fromJson(Map<String, dynamic> json) => Tagihan(
    totalHarga: json["total_harga"],
    ongkosKirim: json["ongkos_kirim"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "total_harga": totalHarga,
    "ongkos_kirim": ongkosKirim,
  };
}
