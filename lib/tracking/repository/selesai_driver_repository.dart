import 'package:driver_kangsayur/contants/app_contans.dart';
import 'package:driver_kangsayur/tracking/model/selesai_driver_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class SelesaiPageRepository{
  Future<SelesaiPengirimanModel> selesai(String userId, String storeId, String transactionCode,);
}

class Selesairepository extends SelesaiPageRepository{

  @override
  Future<SelesaiPengirimanModel> selesai(String userId, String storeId, String transactionCode,) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    final responseKonfirmasi= await http.put(Uri.parse("${AppConstants.baseUrl}driver/order/update/status?user_id=$userId&store_id=$storeId&transaction_code=$transactionCode"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },);

    print(responseKonfirmasi.statusCode);
    print(responseKonfirmasi.body);

    if(responseKonfirmasi.statusCode == 200) {
      SelesaiPengirimanModel konfirmasiModel = selesaiPengirimanModelFromJson(responseKonfirmasi.body);
      return konfirmasiModel;
    } else {
      throw Exception('Gagal mendapatkan data');
    }
  }

}