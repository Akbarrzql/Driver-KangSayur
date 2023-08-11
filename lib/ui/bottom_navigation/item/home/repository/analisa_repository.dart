import 'package:driver_kangsayur/contants/app_contans.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/model/analisa_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class AnalisaPageRepository {
  Future<AnalisaModel> getAnalisa();
}

class AnalisaRepository implements AnalisaPageRepository {
  @override
  Future<AnalisaModel> getAnalisa() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    final responseProduk = await http.get(Uri.parse("${AppConstants.baseUrl}driver/analisa"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },);

    print(responseProduk.body);
    print(responseProduk.statusCode);

    if(responseProduk.statusCode == 200){
      AnalisaModel analisaModel = analisaModelFromJson(responseProduk.body);
      return analisaModel;
    }else{
      throw Exception('Gagal mendapatkan data');
    }
  }
}