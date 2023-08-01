import 'package:driver_kangsayur/contants/app_contans.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/model/pesanan_driver_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class PesananDriverPageRepository{
  Future<PesananDriverModel> pesananDriver();
}

class PesananDriverRepository extends PesananDriverPageRepository{

  @override
  Future<PesananDriverModel> pesananDriver() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    final responseProduk = await http.get(Uri.parse("${AppConstants.baseUrl}driver/order/list"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer U07US5u8O1Y6FTJtRMttkTGeW5l9apKzyB5kcD4t',
      },);

    print(responseProduk.body);
    print(responseProduk.statusCode);

    if(responseProduk.statusCode == 200){
      PesananDriverModel produkModel = pesananDriverModelFromJson(responseProduk.body);
      return produkModel;
    }else{
      throw Exception('Gagal mendapatkan data');
    }
  }

}

