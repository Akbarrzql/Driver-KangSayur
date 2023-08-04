import 'package:driver_kangsayur/contants/app_contans.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat/model/riwayat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class RiwayatPageRepository {
  Future<RiwayatModel> riwyayatDriver();
}

class RiwayatRepository extends RiwayatPageRepository {
  @override
  Future<RiwayatModel> riwyayatDriver() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    final responseProduk = await http.get(Uri.parse("${AppConstants.baseUrl}driver/riwayat/selesai/diantar"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },);

    print(responseProduk.body);
    print(responseProduk.statusCode);

    if(responseProduk.statusCode == 200){
      RiwayatModel riwayatModel = riwayatModelFromJson(responseProduk.body);
      return riwayatModel;
    }else{
      throw Exception('Gagal mendapatkan data');
    }
  }
}