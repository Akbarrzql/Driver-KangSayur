import 'dart:convert';
import 'package:driver_kangsayur/contants/app_contans.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/model/konfirmasi_driver_repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class KonfirmasiPageRepository {
  Future<KonfirmasiPesananDriverModel> konfirmasi(String userId, String storeId, String transactionCode,);
}

class KonfirmasiRepository extends KonfirmasiPageRepository{

  @override
  Future<KonfirmasiPesananDriverModel> konfirmasi(String userId, String storeId, String transactionCode,) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    final responseKonfirmasi= await http.put(Uri.parse("${AppConstants.baseUrl}driver/order/antar?user_id=$userId&store_id=$storeId&transaction_code=$transactionCode"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },);

    print(responseKonfirmasi.statusCode);
    print(responseKonfirmasi.body);

    if(responseKonfirmasi.statusCode == 200) {
      KonfirmasiPesananDriverModel konfirmasiModel = konfirmasiPesananModelFromJson(responseKonfirmasi.body);
      return konfirmasiModel;
    } else {
      throw Exception('Gagal mendapatkan data');
    }
  }

}
