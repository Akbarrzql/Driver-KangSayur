import 'package:driver_kangsayur/contants/app_contans.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/model/pesanan_driver_model.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/model/profile_driver_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class ProfileDriverPageRepository{
  Future<ProfileDriverdModel> pesananDriver();
}

class ProfileDriverRepository extends ProfileDriverPageRepository{

  @override
  Future<ProfileDriverdModel> pesananDriver() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    final responseProfileDriver = await http.get(Uri.parse("${AppConstants.baseUrl}driver/profile"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },);

    print(responseProfileDriver.body);
    print(responseProfileDriver.statusCode);

    if(responseProfileDriver.statusCode == 200){
      ProfileDriverdModel profileDriverModel = profileDriverdModelFromJson(responseProfileDriver.body);
      return profileDriverModel;
    }else{
      throw Exception('Gagal mendapatkan data');
    }
  }

}

