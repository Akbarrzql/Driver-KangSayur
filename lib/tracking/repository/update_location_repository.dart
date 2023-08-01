import 'package:driver_kangsayur/contants/app_contans.dart';
import 'package:driver_kangsayur/tracking/model/update_location_driver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class UpdateLocationPageRepository {
  Future<UpdateLokasiModel> updateLocation(String latitude, String longitude, String transactionCode);
}

class UpdateLocationRepository extends UpdateLocationPageRepository{
  @override
  Future<UpdateLokasiModel> updateLocation(String latitude, String longitude, String transactionCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    final responseProduk = await http.get(Uri.parse("${AppConstants.baseUrl}driver/order/updateLoc?lat=$latitude&long=$longitude&transaction_code=$transactionCode"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer U07US5u8O1Y6FTJtRMttkTGeW5l9apKzyB5kcD4t',
      },);

    print(responseProduk.body);
    print(responseProduk.statusCode);

    if(responseProduk.statusCode == 200){
      UpdateLokasiModel produkModel = updateLokasiModelFromJson(responseProduk.body);
      return produkModel;
    }else{
      throw Exception('Gagal mendapatkan data');
    }
  }
}